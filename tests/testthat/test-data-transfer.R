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
  expect_named(cfg, c("version", "type", "series"))
  expect_false(any(vapply(cfg, is.null, logical(1))))
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
  json <- as.character(htmlwidgets:::toJSON(w))

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
