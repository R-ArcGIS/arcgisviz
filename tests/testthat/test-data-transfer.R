# Coverage for the R -> JSON payload that the browser's createModel()
# consumes. The shapes asserted here are read directly out of
# @arcgis/charts-components' dist (see R/arc-data.R for the file/line
# references) - if a bump to the SDK changes them, these should fail.

test_df <- function() {
  data.frame(category = c("a", "b", "c"), value = c(1, 5, 3))
}

grouped_df <- function() {
  data.frame(
    category = c("a", "a", "b", "b"),
    grp = c("x", "y", "x", "y"),
    value = c(1, 2, 3, 4)
  )
}

test_that("as_feature_layer() produces the IFeatureLayer shape createModel reads", {
  lyr <- as_feature_layer(test_df())

  expect_identical(lyr@layerType, "ArcGISFeatureLayer")

  # `gi` (dist/chunks/index2.js) reads exactly these paths off iLayer.
  fc_layer <- lyr@featureCollection$layers[[1]]
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
  expect_identical(widget_json(list(title = cfg$title)), "{\"title\":null}")

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
      as_feature_layer(sent)@featureCollection$layers[[
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

  # A numeric column can only be a gradient, and an aggregating query never
  # returns it.
  expect_error(
    (arc_bar(test_df(), category) |> set_color(value))@webchart,
    "grouping column"
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
  expect_identical(
    widget_json(list(query = cfg$series[[1]]$query)),
    "{\"query\":null}"
  )
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
  lyr <- as_feature_layer(test_df())
  expect_identical(
    lyr@featureCollection$layers[[1]]$layerDefinition$objectIdField,
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

test_that("a coloured scatterplot names the column in its tooltip", {
  cfg <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |> set_color(category))@webchart
  )
  # An array, not a bare string - the client spreads it into outFields.
  expect_identical(
    cfg$series[[1]]$additionalTooltipFields,
    list("category")
  )

  plain <- s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)
  expect_null(plain$series[[1]]$additionalTooltipFields)

  # Only the scatterplot series takes extra tooltip fields.
  bars <- s7x::as_vector(
    (arc_col(test_df(), category, value) |> set_color(category))@webchart
  )
  expect_null(bars$series[[1]]$additionalTooltipFields)
})

test_that("set_tooltip() names extra fields and joins the coloured column", {
  df <- data.frame(
    category = c("a", "b", "c"),
    value = c(1, 5, 3),
    note = c("x", "y", "z")
  )

  named <- s7x::as_vector(
    (arc_scatter(df, category, value) |> set_tooltip(note))@webchart
  )
  expect_identical(named$series[[1]]$additionalTooltipFields, list("note"))

  # The coloured column comes first, and is not repeated if also named.
  both <- s7x::as_vector(
    (arc_scatter(df, category, value) |>
      set_color(category) |>
      set_tooltip(note, category))@webchart
  )
  expect_identical(
    both$series[[1]]$additionalTooltipFields,
    list("category", "note")
  )

  # No columns clears the list.
  cleared <- s7x::as_vector(
    (arc_scatter(df, category, value) |>
      set_tooltip(note) |>
      set_tooltip())@webchart
  )
  expect_null(cleared$series[[1]]$additionalTooltipFields)
})

test_that("set_tooltip() refuses histograms and unknown columns", {
  expect_error(
    arc_histogram(test_df(), value) |> set_tooltip(category),
    "does not apply"
  )
  expect_error(
    arc_scatter(test_df(), category, value) |> set_tooltip(missing_col),
    "must be a column"
  )
})

test_that("set_tooltip() labels a field by its argument name", {
  df <- data.frame(category = c("a", "b"), value = c(1, 5), note = c("x", "y"))
  chart <- arc_scatter(df, category, value) |>
    set_tooltip(`The note` = note)

  # The label rides over as the field's alias, which is what the chart
  # renders a field name with (_e(), chunks/index3.js:646).
  fields <- tooltip_aliased(
    as_feature_layer(df),
    chart@tooltip
  )@featureCollection$layers[[1]]$layerDefinition$fields
  expect_identical(fields$alias[fields$name == "note"], "The note")
  expect_identical(fields$alias[fields$name == "value"], "value")
})

test_that("a non-scatter chart ships a tooltip lookup keyed by mark", {
  df <- data.frame(
    city = c("a", "a", "b"),
    state = c("s1", "s1", "s2"),
    pop = c(1, 2, 3)
  )
  chart <- arc_bar(df, city) |> set_stat("count") |> set_tooltip(State = state)
  payload <- tooltip_payload(chart)

  expect_identical(payload$labels, list("State"))
  # One series, so the lookup falls back to the "*" key.
  expect_identical(payload$lookup[["*"]][["a"]], list("s1"))
  expect_identical(payload$lookup[["*"]][["b"]], list("s2"))

  # Scatter names its own fields, so it ships no lookup.
  expect_null(tooltip_payload(arc_scatter(df, pop, pop) |> set_tooltip(state)))
})

test_that("a tooltip field must be constant within each mark", {
  df <- data.frame(
    species = c("a", "a", "b"),
    island = c("i1", "i2", "i3"),
    mass = c(1, 2, 3)
  )
  chart <- arc_bar(df, species) |>
    set_stat("count") |>
    set_tooltip(Island = island)

  expect_error(tooltip_payload(chart), "not constant within each mark")
})

test_that("a heat chart keys its tooltip lookup by both axes", {
  df <- data.frame(
    row = c("a", "a", "b"),
    col = c("x", "y", "x"),
    note = c("n1", "n2", "n3")
  )
  payload <- tooltip_payload(arc_heat(df, row, col) |> set_tooltip(note))

  expect_identical(payload$lookup[["*"]][["a\ry"]], list("n2"))
  expect_identical(payload$lookup[["*"]][["b\rx"]], list("n3"))
})

test_that("colouring by a column other than x splits into one series each", {
  grouped <- data.frame(
    category = c("a", "a", "b", "b"),
    grp = c("x", "y", "x", "y"),
    value = c(1, 2, 3, 4)
  )
  cfg <- s7x::as_vector(
    (arc_bar(grouped, category) |> set_color(grp))@webchart
  )

  expect_length(cfg$series, 2)
  # ga() (index2.js:593) reads the where clause, so the split rides there.
  expect_identical(
    vapply(cfg$series, function(s) s$query$where, character(1)),
    c("grp='x'", "grp='y'")
  )
  # `name` is what the legend shows; `id` only has to be unique.
  expect_identical(
    vapply(cfg$series, function(s) s$name, character(1)),
    c("x", "y")
  )
  expect_identical(
    vapply(cfg$series, function(s) s$id, character(1)),
    c("series1", "series2")
  )

  # Each series keeps the aggregation, and carries its own colour rather
  # than leaning on a renderer.
  expect_identical(
    as.character(cfg$series[[1]]$query$groupByFieldsForStatistics),
    "category"
  )
  expect_length(cfg$series[[1]]$query$outStatistics, 1)
  expect_identical(cfg$series[[1]]$fillSymbol$color, c(31, 120, 180, 255))
  expect_identical(cfg$series[[2]]$fillSymbol$color, c(166, 206, 227, 255))
  expect_null(cfg$chartRenderer)
  expect_null(cfg$colorMatch)

  # Dodged unless asked otherwise.
  expect_identical(cfg$stackedType, "sideBySide")
  expect_null(
    s7x::as_vector(arc_bar(grouped, category)@webchart)$stackedType
  )
})

test_that("a split chart needs no derived colour column", {
  grouped <- data.frame(
    category = c("a", "b"),
    grp = c("x", "y"),
    value = c(1, 2)
  )
  chart <- arc_col(grouped, category, value) |> set_color(grp)
  expect_identical(names(chart_data(chart)), names(grouped))

  # No aggregation means no outStatistics, which is what the client keys
  # BarAndLineSplitByNoAggregation off.
  cfg <- s7x::as_vector(chart@webchart)
  expect_identical(cfg$series[[1]]$query$where, "grp='x'")
  expect_null(cfg$series[[1]]$query$outStatistics)
})

test_that("position maps ggplot2's vocabulary onto stackedType", {
  grouped <- data.frame(
    category = c("a", "b"),
    grp = c("x", "y")
  )
  stacked <- s7x::as_vector(
    (arc_bar(grouped, category, position = "stack") |> set_color(grp))@webchart
  )
  expect_identical(stacked$stackedType, "stacked")

  filled <- s7x::as_vector(
    (arc_bar(grouped, category) |>
      set_color(grp) |>
      set_position("fill"))@webchart
  )
  expect_identical(filled$stackedType, "stacked100")

  expect_error(arc_bar(grouped, category, position = "nope"), "position")
  expect_error(set_position(arc_bar(grouped, category), "nope"), "position")
})

test_that("a split where clause escapes quotes the way the client parses it", {
  quoted <- data.frame(
    category = c("a", "b"),
    grp = c("O'Hare", "Dulles")
  )
  cfg <- s7x::as_vector(
    (arc_bar(quoted, category) |> set_color(grp))@webchart
  )
  expect_identical(
    vapply(cfg$series, function(s) s$query$where, character(1)),
    c("grp='Dulles'", "grp='O''Hare'")
  )
})

test_that("only bar and line split; other types keep colouring per item", {
  grouped <- data.frame(
    category = c("a", "b"),
    grp = c("x", "y"),
    value = c(1, 2)
  )
  cfg <- s7x::as_vector(
    (arc_scatter(grouped, value, value) |> set_color(grp))@webchart
  )
  expect_length(cfg$series, 1)
  expect_identical(cfg$chartRenderer$type, "simple")

  # A continuous colour is a scale, not a group, so it never splits.
  numeric <- s7x::as_vector(
    (arc_col(grouped, category, value) |> set_color(value))@webchart
  )
  expect_length(numeric$series, 1)
})

test_that("each split series names its statistic after its own level", {
  # The client folds every series into one query and reshapes the result
  # keyed by outStatisticFieldName (ns(), index2.js:1793), so a shared name
  # makes every series read the same column and draw identical bars.
  grouped <- data.frame(
    category = c("a", "a", "b", "b"),
    grp = c("x", "y", "x", "y"),
    value = c(1, 2, 3, 4)
  )

  counted <- s7x::as_vector(
    (arc_bar(grouped, category) |> set_color(grp))@webchart
  )
  out <- vapply(
    counted$series,
    function(s) s$query$outStatistics[[1]]$outStatisticFieldName,
    character(1)
  )
  expect_identical(out, c("COUNT_OBJECT_ID_x", "COUNT_OBJECT_ID_y"))
  # The series reads the reshaped data by `y`, so the two have to agree.
  expect_identical(vapply(counted$series, function(s) s$y, character(1)), out)

  averaged <- s7x::as_vector(
    (arc_chart(grouped) |>
      set_type("bar") |>
      set_x(category) |>
      set_y(value) |>
      set_stat("mean") |>
      set_color(grp))@webchart
  )
  expect_identical(
    vapply(averaged$series, function(s) s$y, character(1)),
    c("AVG_VALUE_x", "AVG_VALUE_y")
  )

  # An unsplit chart keeps the SDK's own `_0` convention.
  plain <- s7x::as_vector(arc_bar(grouped, category)@webchart)
  expect_identical(plain$series[[1]]$y, "COUNT_OBJECT_ID_0")
})

test_that("set_size() sends a sizePolicy on the scatter series", {
  sized <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |>
      set_size(value, range = c(4, 20)))@webchart
  )
  policy <- sized$series[[1]]$sizePolicy
  expect_identical(policy$type, "sizeScale")
  expect_identical(policy$field, "value")
  expect_identical(policy$scaleType, "linear")
  expect_identical(policy$minSize, 4)
  expect_identical(policy$maxSize, 20)

  # An omitted range leaves the SDK's own 5 to 30 in place.
  bare <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |> set_size(value))@webchart
  )
  expect_null(bare$series[[1]]$sizePolicy$minSize)
  expect_null(bare$series[[1]]$sizePolicy$maxSize)

  # "log" is ggplot2's spelling of the spec's "logarithmic".
  logged <- s7x::as_vector(
    (arc_scatter(test_df(), category, value) |>
      set_size(value, scale = "log"))@webchart
  )
  expect_identical(logged$series[[1]]$sizePolicy$scaleType, "logarithmic")

  expect_null(
    s7x::as_vector(arc_scatter(test_df(), category, value)@webchart)$series[[
      1
    ]]$sizePolicy
  )
})

test_that("set_size() only applies where markers exist", {
  # sizePolicy is declared on WebChartScatterplotSeries alone
  # (web-chart.d.ts:843).
  expect_error(set_size(arc_bar(test_df(), category), value), "does not apply")
  expect_error(
    set_size(arc_scatter(test_df(), category, value), category),
    "must map a numeric column"
  )
  expect_error(
    set_size(arc_scatter(test_df(), category, value), value, range = 5),
    "must be two numbers"
  )
  expect_error(
    set_size(arc_scatter(test_df(), category, value), value, range = c(9, 2)),
    "small to large"
  )
})

test_that("box plots split into groups but never stack", {
  grouped <- data.frame(
    category = c("a", "a", "b", "b"),
    grp = c("x", "y", "x", "y"),
    value = c(1, 2, 3, 4)
  )
  cfg <- s7x::as_vector(
    (arc_boxplot(grouped, category, value) |> set_color(grp))@webchart
  )

  # BoxPlotMonoFieldAndCategoryAndSplitBy: a real where clause alongside a
  # category x (xn(), index2.js:600).
  expect_length(cfg$series, 2)
  expect_identical(
    vapply(cfg$series, function(s) s$query$where, character(1)),
    c("grp='x'", "grp='y'")
  )
  expect_identical(cfg$series[[1]]$fillSymbol$color, c(31, 120, 180, 255))

  # Only bar and line read stackedType, so a box plot sends none and
  # refuses a position outright rather than accepting it silently.
  expect_null(cfg$stackedType)
  expect_error(
    set_position(arc_boxplot(grouped, category, value)),
    "does not apply"
  )
})

test_that("position is refused by the chart types that cannot stack", {
  # Only Gr() and G0() set amCharts stacking, and Zr() dispatches G0 for
  # BarSeries alone (customElement.js:16839).
  expect_error(
    set_position(arc_histogram(test_df(), value)),
    "does not apply to histogram"
  )
  expect_error(
    set_position(arc_heat(test_df(), category, value)),
    "does not apply to heat"
  )
  expect_error(
    arc_histogram(test_df(), value) |> set_position("stack"),
    "Only .* charts stack"
  )
})

test_that("the config carries a legend only where one was asked for", {
  # Zc() (chunks/index3.js:654) gates the legend on the chart having entries,
  # so R sends nothing and lets the client's own rule stand.
  plain <- s7x::as_vector(arc_col(test_df(), category, value)@webchart)
  expect_null(plain$legend)

  # A series names itself in the legend, so an ungrouped one is named after
  # what it plots rather than "series1".
  expect_identical(plain$series[[1]]$name, "value")

  split <- arc_bar(grouped_df(), category) |>
    set_color(grp) |>
    set_legend(visible = FALSE)
  expect_false(s7x::as_vector(split@webchart)$legend$visible)
})

test_that("asking for a legend the client will not draw is an error", {
  # Zc() returns false for one bar series, so `visible` would be read and
  # then ignored (customElement.js:12080).
  expect_error(
    s7x::as_vector(
      (arc_col(test_df(), category, value) |>
        set_legend(visible = TRUE))@webchart
    ),
    "has none"
  )

  # Heat is one of the two types that always has a legend - the gradient
  # itself (tf(), customElement.js:11062).
  heat <- arc_heat(test_df(), category, value) |> set_legend(visible = TRUE)
  expect_true(s7x::as_vector(heat@webchart)$legend$visible)

  grouped <- arc_bar(grouped_df(), category) |>
    set_color(grp) |>
    set_legend(visible = TRUE)
  expect_true(s7x::as_vector(grouped@webchart)$legend$visible)
})

test_that("set_legend() layers repeated calls and titles the legend", {
  chart <- arc_bar(grouped_df(), category) |>
    set_color(grp) |>
    set_legend(position = "bottom") |>
    set_legend(title = "Key")

  legend <- s7x::as_vector(chart@webchart)$legend
  expect_identical(legend$position, "bottom")
  # The client's own text setter leaves `visible` alone (P(),
  # chunks/data-labels-visibility.js:25), so the title says so itself.
  expect_identical(legend$title$content$text, "Key")
  expect_true(legend$title$visible)

  expect_error(set_legend(chart, position = "sideways"), "must be one of")
  expect_error(set_legend(chart, visible = "yes"), "must be")
  expect_error(set_legend(chart, title = 1), "must be a single string")
})

test_that("a pie sends no axes and reads its subtype off the query", {
  # tt() (chunks/index.js:765) is the one default config with no `axes` key,
  # and deepMerge maps over the array, so sending a pair would add one.
  counted <- s7x::as_vector(arc_pie(test_df(), category)@webchart)
  expect_null(counted$axes)

  # ya() (index2.js:589): grouped statistics is PieFromCategory.
  query <- counted$series[[1]]$query
  expect_identical(as.character(query$groupByFieldsForStatistics), "category")
  expect_identical(counted$series[[1]]$y, "COUNT_OBJECT_ID_0")

  # ...and an absent outStatistics is PieNoAggregation, which needs the
  # explicit null that deletes the model's own default query.
  plotted <- s7x::as_vector(arc_pie(test_df(), category, value)@webchart)
  expect_identical(plotted$series[[1]]$query, json_null)
  expect_identical(plotted$series[[1]]$y, "value")
})

test_that("set_pie() turns the pie into a doughnut and picks its labels", {
  series <- s7x::as_vector(
    arc_pie(
      test_df(),
      category,
      hole = 60,
      labels = c("category", "percent"),
      inside = TRUE
    )@webchart
  )$series[[1]]

  expect_identical(series$innerRadius, 60)
  expect_true(series$dataLabelsInside)
  # Naming one part turns the others off, so all three travel.
  expect_true(series$displayCategoryOnDataLabel)
  expect_false(series$displayNumericValueOnDataLabel)
  expect_true(series$displayPercentageOnDataLabel)

  expect_error(set_pie(arc_col(test_df(), category, value)), "only applies")
  expect_error(arc_pie(test_df(), category, labels = "nope"), "must be one of")
})

test_that("a gauge reduces the layer to one value on `x`", {
  cfg <- s7x::as_vector(arc_gauge(test_df(), value, stat = "mean")@webchart)

  # ce() (chunks/index.js:463) builds exactly one axis.
  expect_length(cfg$axes, 1)
  expect_identical(cfg$axes[[1]]$title$content$text, "mean(value)")

  # u() (gauge-model.js:70) reads the value off `x`, which under aggregation
  # has to name the statistic's output field.
  series <- cfg$series[[1]]
  expect_identical(series$x, "AVG_VALUE_0")
  expect_identical(
    series$query$outStatistics[[1]]$outStatisticFieldName,
    "AVG_VALUE_0"
  )
  # ue() groups by nothing - a group-by would return a row per group.
  expect_null(series$query$groupByFieldsForStatistics)
  expect_null(series$y)
})

test_that("set_gauge() reads one row verbatim and styles the dial", {
  cfg <- s7x::as_vector(
    arc_gauge(
      test_df(),
      value,
      feature = 2,
      hole = 30,
      angles = c(-180, 180),
      needle = FALSE
    )@webchart
  )

  expect_identical(cfg$subType, "featureGauge")
  expect_identical(cfg$innerRadius, 30)
  expect_identical(cfg$startAngle, -180)
  expect_identical(cfg$endAngle, 180)
  # R counts rows from one, the spec indexes features from zero.
  expect_identical(cfg$series[[1]]$featureIndex, 1)
  expect_identical(cfg$series[[1]]$x, "value")
  expect_identical(cfg$series[[1]]$query, json_null)
  expect_false(cfg$axes[[1]]$needle$visible)

  expect_error(arc_gauge(test_df(), value, feature = 0), "counting from 1")
  expect_error(arc_gauge(test_df(), value, angles = 90), "two numbers")
  # One reading has no marks for a scale to vary.
  expect_error(
    s7x::as_vector(
      (arc_gauge(test_df(), value) |> set_color(category))@webchart
    ),
    "does not apply to gauge"
  )
})

test_that("a radar chart is a line chart on a circular axis", {
  cfg <- s7x::as_vector(arc_radar(test_df(), category, value)@webchart)

  expect_identical(cfg$series[[1]]$type, "radarSeries")
  expect_length(cfg$axes, 2)
  # k() (index2.js:601) routes radar through ga(), so an unaggregated one
  # still needs the null that deletes the default count query.
  expect_identical(cfg$series[[1]]$query, json_null)

  # ...and it splits the way a line does.
  split <- arc_radar(grouped_df(), category, value) |>
    set_stat("mean") |>
    set_color(grp)
  series <- s7x::as_vector(split@webchart)$series
  expect_length(series, 2)
  expect_identical(
    vapply(series, function(s) s$query$where, character(1)),
    c("grp='x'", "grp='y'")
  )

  # Only bar and line stack (web-chart.d.ts:1307).
  expect_error(
    set_position(arc_radar(test_df(), category, value)),
    "does not apply"
  )
})

test_that("a radar's axes go untitled so the title stays off the plot", {
  # k() (chunks/index.js:253) centres an axis title inside its own axis,
  # which on a circular one is the middle of the chart.
  axes <- s7x::as_vector(arc_radar(test_df(), category, value)@webchart)$axes
  for (axis in axes) {
    expect_false(axis$title$visible)
    expect_identical(axis$title$content$text, "")
  }

  # The series still names itself for the legend.
  series <- s7x::as_vector(
    arc_radar(test_df(), category, value)@webchart
  )$series
  expect_identical(series[[1]]$name, "value")

  # set_labs() still wins, and no other type is affected.
  titled <- arc_radar(test_df(), category, value) |> set_labs(y = "Mass")
  expect_identical(
    s7x::as_vector(titled@webchart)$axes[[2]]$title$content$text,
    "Mass"
  )
  expect_identical(
    s7x::as_vector(arc_line(test_df(), category, value)@webchart)$axes[[
      1
    ]]$title$content$text,
    "category"
  )
})
