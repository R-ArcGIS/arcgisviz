# Coverage for the R -> JSON payload that the browser's createModel()
# consumes. The shapes asserted here are read directly out of
# @arcgis/charts-components' dist (see R/arc-data.R for the file/line
# references) - if a bump to the SDK changes them, these should fail.

test_df <- function() {
  data.frame(category = c("a", "b", "c"), value = c(1, 5, 3))
}

test_that("as_chart_layer() produces the IFeatureLayer shape createModel reads", {
  lyr <- as_chart_layer(test_df())

  expect_identical(lyr$layerType, "ArcGISFeatureLayer")

  # `gi` (dist/chunks/index2.js) reads exactly these paths off iLayer.
  fc_layer <- lyr$featureCollection$layers[[1]]
  expect_length(fc_layer$featureSet$features, 3)
  expect_identical(fc_layer$layerDefinition$objectIdField, "object_id")
  expect_true(nrow(fc_layer$layerDefinition$fields) == 3)
})

test_that("the config carries the series type createModel derives the chart type from", {
  cfg <- s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)

  # dist/chunks/model-types.js maps series type -> ModelType; there is no
  # separate chartType argument on this path.
  expect_identical(cfg$series[[1]]$type, "scatterSeries")
  expect_identical(cfg$series[[1]]$x, "category")
  expect_identical(cfg$series[[1]]$y, "value")
})

test_that("unset properties are dropped rather than sent as null", {
  cfg <- s7x::as_vector(arc_col(test_df(), category, value)@webchart)

  # createModel() layers `config` over its own defaults, so an explicit
  # null would override a default instead of falling back to it.
  # `title` is the deliberate exception - see the test below.
  expect_named(cfg, c("version", "type", "axes", "series", "title"))
  expect_false(any(vapply(cfg, is.null, logical(1))))
})

test_that("an unset title sends a null to delete the model's default", {
  # Every default config titles the chart with the localized "Chart" (m(),
  # dist/chunks/index.js:289), so an absent key would leave that in place.
  cfg <- s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)
  expect_identical(cfg$title, json_null)
  expect_identical(widget_json(cfg$title), "null")

  titled <- WebChart(
    title = WebChartText(
      type = "chartText",
      content = WebChartTextSymbol(type = "esriTS", text = "Penguins")
    )
  )
  expect_identical(s7x::as_vector(titled)$title$content$text, "Penguins")
})

test_that("axis titles come from the mapping, not the model's defaults", {
  # Tooltips label each value with the axis title and only fall back to the
  # field alias when it is empty (customElement.js:10170), so the localized
  # "X-axis"/"Count" defaults have to be overwritten.
  axes <- s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)$axes
  expect_identical(axes[[1]]$title$content$text, "category")
  expect_identical(axes[[2]]$title$content$text, "value")

  counted <- s7x::as_vector(arc_bar(test_df(), category)@webchart)$axes
  expect_identical(counted[[2]]$title$content$text, "count")

  agg <- arc_chart(test_df()) |>
    set_type("bar") |>
    set_x(category) |>
    set_y(value) |>
    set_stat("mean")
  expect_identical(
    s7x::as_vector(agg@webchart)$axes[[2]]$title$content$text,
    "mean(value)"
  )
})

test_that("set_labs() overrides chart-level text", {
  chart <- arc_scatter(test_df(), category, value) |>
    set_labs(
      title = "Values by category",
      subtitle = "a subtitle",
      caption = "a caption"
    )
  cfg <- s7x::as_vector(chart@webchart)

  expect_identical(cfg$title$content$text, "Values by category")
  expect_identical(cfg$subtitle$content$text, "a subtitle")
  # `caption` is the chart's footer; there is no `caption` in the spec.
  expect_identical(cfg$footer$content$text, "a caption")
})

test_that("set_labs() overrides axis titles and NULL removes them", {
  titled <- arc_scatter(test_df(), category, value) |>
    set_labs(x = "Category", y = "Value")
  axes <- s7x::as_vector(titled@webchart)$axes
  expect_identical(axes[[1]]$title$content$text, "Category")
  expect_identical(axes[[2]]$title$content$text, "Value")

  # A removed label has to blank the model's "X-axis"/"Count" default, so it
  # is sent as an invisible empty title rather than dropped.
  removed <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |> set_labs(x = NULL))@webchart
  )$axes
  expect_false(removed[[1]]$title$visible)
  expect_identical(removed[[1]]$title$content$text, "")
  expect_identical(removed[[2]]$title$content$text, "value")
})

test_that("set_labs() leaves omitted labels alone and rejects bad input", {
  chart <- arc_scatter(test_df(), category, value) |> set_labs(x = "Category")
  cfg <- s7x::as_vector(chart@webchart)

  expect_identical(cfg$title, json_null)
  expect_null(cfg$subtitle)
  expect_null(cfg$footer)

  # A later call only touches the labels it names.
  again <- s7x::as_vector((chart |> set_labs(title = "Hi"))@webchart)
  expect_identical(again$axes[[1]]$title$content$text, "Category")
  expect_identical(again$title$content$text, "Hi")

  expect_error(set_labs(chart, title = 1), "must be a single string")
  expect_error(set_labs(chart, "Hi"), class = "rlib_error_dots_nonempty")
})

test_that("a numeric colour mapping sends a colorInfo visual variable", {
  cfg <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |> set_color(value))@webchart
  )

  expect_true(cfg$colorMatch)
  expect_identical(cfg$chartRenderer$type, "simple")
  expect_identical(cfg$chartRenderer$symbol$type, "esriSMS")

  vv <- cfg$chartRenderer$visualVariables[[1]]
  expect_identical(vv$type, "colorInfo")
  expect_identical(vv$field, "value")

  # The ramp's own stops go over untouched, spread across the column's range.
  stops <- vv$stops
  expect_identical(stops[[1]]$value, 1)
  expect_identical(stops[[length(stops)]]$value, 5)
  # "Blue 3" is the SDK's defaultColorRampForCharts (class-breaks.js:475).
  expect_identical(stops[[1]]$color, c(239, 243, 255, 255))
})

test_that("categories ride integer codes on a visual variable", {
  # uniqueValue is ignored on the amCharts5 path, so categories go over as a
  # colorInfo VV against a derived numeric column - one stop per level, so no
  # value ever falls between stops and the interpolation never kicks in.
  chart <- arc_col(test_df(), category, value) |> set_color(category)
  cfg <- s7x::as_vector(chart@webchart)

  expect_identical(cfg$chartRenderer$type, "simple")

  vv <- cfg$chartRenderer$visualVariables[[1]]
  expect_identical(vv$field, "arcgisviz_color")

  stops <- vv$stops
  expect_null(names(stops))
  expect_identical(vapply(stops, function(s) s$value, double(1)), c(1, 2, 3))
  expect_identical(
    vapply(stops, function(s) s$label, character(1)),
    c("a", "b", "c")
  )
  # Paired-10, the SDK's own series palette (index.js:45).
  expect_identical(stops[[1]]$color, c(31, 120, 180, 255))

  # The codes have to reach the browser, so the layer carries the column.
  sent <- chart_data(chart)
  expect_identical(sent$arcgisviz_color, c(1L, 2L, 3L))
  expect_true(
    "arcgisviz_color" %in%
      as_chart_layer(sent)$featureCollection$layers[[
        1
      ]]$layerDefinition$fields$name
  )
})

test_that("an aggregating chart colours categories with a uniqueValue renderer", {
  # An aggregating query returns only the group-by field and the statistic, so
  # a derived code column would never come back - but `x` itself does.
  chart <- arc_bar(test_df(), category) |> set_color(category)
  cfg <- s7x::as_vector(chart@webchart)

  expect_identical(cfg$chartRenderer$type, "uniqueValue")
  expect_identical(cfg$chartRenderer$field1, "category")
  expect_identical(names(chart_data(chart)), names(test_df()))

  infos <- cfg$chartRenderer$uniqueValueInfos
  expect_null(names(infos))
  expect_identical(
    vapply(infos, function(i) i$value, character(1)),
    c("a", "b", "c")
  )
  expect_identical(infos[[1]]$symbol$color, c(31, 120, 180, 255))

  # Nothing but `x` survives the query, so nothing else can be coloured.
  grouped <- data.frame(
    category = c("a", "b"),
    grp = c("x", "y"),
    value = c(1, 2)
  )
  expect_error(
    (arc_chart(grouped) |>
      set_type("bar") |>
      set_x(category) |>
      set_y(value) |>
      set_stat("mean") |>
      set_color(grp))@webchart,
    "same column as"
  )
})

test_that("a numeric colour mapping adds no derived column", {
  chart <- arc_scatter(test_df(), category, value) |> set_color(value)
  expect_identical(names(chart_data(chart)), names(test_df()))
})

test_that("an unmapped chart sends neither a renderer nor colorMatch", {
  cfg <- s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)
  expect_null(cfg$chartRenderer)
  expect_null(cfg$colorMatch)
})

test_that("set_color() accepts a palette name or a colour vector", {
  ramped <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |>
      set_color(value, palette = "Red 1"))@webchart
  )
  expect_false(identical(
    ramped$chartRenderer$visualVariables[[1]]$stops[[1]]$color,
    c(239, 243, 255, 255)
  ))

  custom <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |>
      set_color(value, palette = c("white", "black")))@webchart
  )
  stops <- custom$chartRenderer$visualVariables[[1]]$stops
  expect_length(stops, 2)
  expect_identical(stops[[1]]$color, c(255, 255, 255, 255))
  expect_identical(stops[[2]]$color, c(0, 0, 0, 255))

  # A palette is a ramp name or colours; anything else faults as a colour.
  expect_error(
    set_color(arc_scatter(test_df(), category, value), value, palette = "Nope"),
    "valid colours"
  )
  expect_error(
    set_color(arc_scatter(test_df(), category, value), value, palette = "#GGG"),
    "valid colours"
  )
})

test_that("parse_color() handles names, hex, and hex with alpha", {
  expect_identical(
    s7x::as_vector(parse_color("steelblue")[[1]]),
    c(70, 130, 180, 255)
  )
  expect_identical(
    s7x::as_vector(parse_color("#4682B480")[[1]]),
    c(70, 130, 180, 128)
  )
  expect_length(parse_color(c("red", "blue")), 2)
  expect_error(parse_color("notacolour"), "valid colours")
})

test_that("set_axis() writes spec properties onto the named axis only", {
  chart <- arc_col(test_df(), category, value) |>
    set_axis("y", limits = c(0, 10), log = TRUE, zero_line = TRUE) |>
    set_axis("x", visible = FALSE)
  axes <- s7x::as_vector(chart@webchart)$axes

  expect_false(axes[[1]]$visible)
  expect_null(axes[[1]]$minimum)

  expect_identical(axes[[2]]$minimum, 0)
  expect_identical(axes[[2]]$maximum, 10)
  expect_true(axes[[2]]$isLogarithmic)
  expect_true(axes[[2]]$displayZeroLine)

  # The axis title still comes from the mapping.
  expect_identical(axes[[2]]$title$content$text, "value")
})

test_that("set_axis() accumulates and leaves an NA bound to the chart", {
  chart <- arc_col(test_df(), category, value) |>
    set_axis("y", limits = c(0, NA)) |>
    set_axis("y", integer_only = TRUE)
  y <- s7x::as_vector(chart@webchart)$axes[[2]]

  expect_identical(y$minimum, 0)
  expect_null(y$maximum)
  expect_true(y$integerOnlyValues)
})

test_that("set_axis() rejects bad input", {
  chart <- arc_col(test_df(), category, value)

  expect_error(set_axis(chart, "z"), class = "rlang_error")
  expect_error(set_axis(chart, "y", limits = 1), "must be two numbers")
  expect_error(set_axis(chart, "y", limits = c(10, 0)), "must be increasing")
  expect_error(set_axis(chart, "y", log = "yes"), "must be")
  expect_error(set_axis(chart, "y", tick_spacing = 0), "at least 1")
  expect_error(set_axis(chart, "y", TRUE), class = "rlib_error_dots_nonempty")
})

test_that("set_flipped() rotates the chart", {
  flipped <- arc_col(test_df(), category, value) |> set_flipped()
  expect_true(s7x::as_vector(flipped@webchart)$rotated)

  # Unset stays absent so the model's own default survives.
  expect_null(
    s7x::as_vector(arc_col(test_df(), category, value)@webchart)$rotated
  )
  expect_false(
    s7x::as_vector((flipped |> set_flipped(FALSE))@webchart)$rotated
  )
})

test_that("a histogram sends bins and no y", {
  cfg <- s7x::as_vector(arc_histogram(test_df(), value, bins = 10)@webchart)
  series <- cfg$series[[1]]

  expect_identical(series$type, "histogramSeries")
  expect_identical(series$x, "value")
  expect_identical(series$binCount, 10)
  # The frequency axis is derived, and only bar and line carry a query.
  expect_null(series$y)
  expect_null(series$query)

  # deepMerge maps over the source array, so a compacted-away axis would
  # shorten `axes` and delete one of the model's own.
  expect_length(cfg$axes, 2)
  expect_identical(cfg$axes[[2]]$type, "chartAxis")

  # set_histogram() reaches the same options from the core pipe.
  piped <- arc_chart(test_df()) |>
    set_type("histogram") |>
    set_x(value) |>
    set_histogram(bins = 4, transform = "log")
  piped_series <- s7x::as_vector(piped@webchart)$series[[1]]
  expect_identical(piped_series$binCount, 4)
  expect_identical(piped_series$dataTransformationType, "logarithmic")

  # Calls layer rather than reset.
  layered <- s7x::as_vector(set_histogram(piped, bins = 7)@webchart)$series[[1]]
  expect_identical(layered$binCount, 7)
  expect_identical(layered$dataTransformationType, "logarithmic")

  expect_error(set_histogram(arc_bar(test_df(), category)), "only applies")
  expect_error(arc_histogram(test_df(), value, bins = 0), "at least 1")
  expect_error(arc_histogram(test_df(), value, bins = 2.5), "whole number")
  expect_error(arc_histogram(test_df(), value, transform = "nope"), "one of")
  expect_error(set_histogram(piped, TRUE), class = "rlib_error_dots_nonempty")
})

test_that("a box plot carries y and its own config subtype", {
  chart <- arc_boxplot(test_df(), category, value)
  expect_true(S7::S7_inherits(chart@webchart, WebBoxPlot))

  cfg <- s7x::as_vector(chart@webchart)
  expect_identical(cfg$series[[1]]$type, "boxPlotSeries")
  expect_identical(cfg$series[[1]]$x, "category")
  expect_identical(cfg$series[[1]]$y, "value")
  expect_null(cfg$showOutliers)

  # Both paths reach the same properties on the WebBoxPlot subtype.
  sugar <- s7x::as_vector(
    arc_boxplot(test_df(), category, value, outliers = FALSE)@webchart
  )
  expect_false(sugar$showOutliers)

  piped <- s7x::as_vector(
    set_boxplot(chart, outliers = FALSE, standardize = TRUE)@webchart
  )
  expect_false(piped$showOutliers)
  expect_true(piped$standardizeValues)

  expect_error(set_boxplot(arc_bar(test_df(), category)), "only applies")
  expect_error(set_boxplot(chart, outliers = "no"), "must be")
})

test_that("a heat chart grids two columns", {
  chart <- arc_heat(test_df(), category, value)
  expect_true(S7::S7_inherits(chart@webchart, WebHeatChart))

  cfg <- s7x::as_vector(chart@webchart)
  expect_identical(cfg$series[[1]]$type, "heatSeries")
  expect_identical(cfg$series[[1]]$x, "category")
  expect_identical(cfg$series[[1]]$y, "value")
  expect_null(cfg$series[[1]]$query)

  # Without a category valueFormat on both axes the client reads this as a
  # half-built calendar heat chart (Io(), index2.js:4144) and renders a
  # placeholder asking for a date field.
  expect_identical(cfg$axes[[1]]$valueFormat$type, "category")
  expect_identical(cfg$axes[[2]]$valueFormat$type, "category")
  # Only heat charts get it.
  expect_null(
    s7x::as_vector(arc_bar(test_df(), category)@webchart)$axes[[1]]$valueFormat
  )

  # A set_axis() option still lands alongside the default.
  limited <- s7x::as_vector((chart |> set_axis("x", visible = FALSE))@webchart)
  expect_identical(limited$axes[[1]]$valueFormat$type, "category")
  expect_false(limited$axes[[1]]$visible)

  # Cells are shaded by their own heat rules, not by a chartRenderer, so
  # there is no column to map.
  expect_error(set_color(chart, category), "does not apply to heat")
  expect_error(set_color(chart), "required for a heat chart")

  # An Esri ramp goes over by name and the client builds the class breaks
  # itself (serial-chart-data.js:487).
  named <- s7x::as_vector(set_color(chart, palette = "Heatmap 3")@webchart)
  expect_identical(named$series[[1]]$heatRulesType, "renderer")
  expect_identical(
    named$series[[1]]$classBreaksRules$colorRampInfo$name,
    "Heatmap 3"
  )
  expect_null(named$chartRenderer)

  # Anything else collapses to the two colour gradient the spec allows.
  ramped <- s7x::as_vector(
    set_color(chart, palette = c("white", "navy"))@webchart
  )
  expect_identical(ramped$series[[1]]$heatRulesType, "gradient")
  expect_identical(
    ramped$series[[1]]$gradientRules$colorList,
    list(c(255, 255, 255, 255), c(0, 0, 128, 255))
  )
})

test_that("stat = 'identity' sends a null query to delete the default", {
  cfg <- s7x::as_vector(arc_col(test_df(), category, value)@webchart)

  # The default bar series ships a count aggregation; only an explicit null
  # gets rid of it, and BarAndLineNoAggregation needs it gone.
  expect_identical(cfg$series[[1]]$query, json_null)
  expect_identical(widget_json(cfg$series[[1]]$query), "null")
  expect_identical(cfg$series[[1]]$y, "value")
})

test_that("an aggregating stat binds y to the outStatisticFieldName", {
  chart <- arc_chart(test_df()) |>
    set_type("bar") |>
    set_x(category) |>
    set_y(value) |>
    set_stat("mean")
  query <- s7x::as_vector(chart@webchart)$series[[1]]$query

  # The spec types this string[]; a bare string breaks the JS `.map()`.
  expect_identical(
    widget_json(query$groupByFieldsForStatistics),
    '["category"]'
  )
  expect_identical(query$outStatistics[[1]]$statisticType, "avg")
  expect_identical(query$outStatistics[[1]]$onStatisticField, "value")
  expect_identical(
    query$outStatistics[[1]]$outStatisticFieldName,
    "AVG_VALUE_0"
  )

  # The query engine returns the aggregate under its output name, so that -
  # not the source column - is what the series has to plot.
  expect_identical(s7x::as_vector(chart@webchart)$series[[1]]$y, "AVG_VALUE_0")
})

test_that("arc_bar() counts rows per x and needs no y", {
  query <- s7x::as_vector(arc_bar(test_df(), category)@webchart)$series[[
    1
  ]]$query

  expect_identical(query$outStatistics[[1]]$statisticType, "count")
  expect_identical(query$outStatistics[[1]]$onStatisticField, oid_field)
  expect_identical(
    s7x::as_vector(arc_bar(test_df(), category)@webchart)$series[[1]]$y,
    "COUNT_OBJECT_ID_0"
  )

  # The query engine rejects fields the layer doesn't have.
  lyr <- as_chart_layer(test_df())
  expect_identical(
    lyr$featureCollection$layers[[1]]$layerDefinition$objectIdField,
    oid_field
  )
})

test_that("scatterplots ignore stat entirely", {
  chart <- arc_chart(test_df()) |>
    set_type("scatter") |>
    set_x(category) |>
    set_y(value) |>
    set_stat("sum")

  expect_identical(s7x::as_vector(chart@webchart)$series[[1]]$y, "value")
  expect_identical(s7x::as_vector(chart@webchart)$series[[1]]$query, json_null)
})

test_that("a Color coerces to the spec's [r,g,b,a] tuple", {
  expect_identical(
    s7x::as_vector(Color(r = 1, g = 2, b = 3, a = 255)),
    c(1, 2, 3, 255)
  )

  # A partly-specified color isn't one - it drops out as unset.
  expect_null(s7x::as_vector(Color(r = 1)))
})

test_that("the widget serializes with our own function, not htmlwidgets'", {
  w <- as_widget(arc_scatter(test_df(), category, value))
  expect_identical(attr(w$x, "TOJSON_FUNC", exact = TRUE), widget_json)
})

test_that("the widget payload serializes fields row-wise", {
  w <- as_widget(arc_scatter(test_df(), category, value))
  # Called the way htmlwidgets calls it, through the hook the test above
  # asserts is installed.
  json <- attr(w$x, "TOJSON_FUNC", exact = TRUE)(w$x)

  # The JS side does `fields.map(Field.fromJSON)`, so a columnar data frame
  # (jsonlite's default under htmlwidgets) would break it.
  expect_true(grepl('{"name":"object_id"', json, fixed = TRUE))
  expect_false(grepl('"name":["object_id"', json, fixed = TRUE))
})

test_that("widget_json() unboxes scalars and nulls out NA", {
  expect_identical(
    widget_json(list(a = 1, b = "x", c = NA, d = NA_character_)),
    '{"a":1.0,"b":"x","c":null,"d":null}'
  )
  # An empty list has to stay a JSON array - htmlwidgets' `evals`/`jsHooks`
  # are arrays client-side.
  expect_identical(widget_json(list(evals = list())), '{"evals":[]}')
})

test_that("rendering a chart without a type or data is an error", {
  expect_error(as_widget(arc_chart(test_df())), "set_type\\(\\)")
})
