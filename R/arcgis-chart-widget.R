# htmlwidgets binding for the <arcgis-chart> web component from
# @arcgis/charts-components. See srcjs/README.md for the JS-side
# architecture and docs/js-widget-architecture.md for the full data flow.
#
# Serialization of our S7 WebChart/WebChartBarChartSeries config classes
# into this widget's payload is deferred (see s7x to_json()/from_json(),
# not yet implemented). For now `i_layer` is a plain list - the JSON
# layer definition produced by arcgisutils (e.g. a `type = "featureCollection"`
# layer) - and only the x/y field mappings are set on the model directly.

#' Render an ArcGIS chart
#'
#' Creates an htmlwidget wrapping the `<arcgis-chart>` web component. The
#' chart's model and layer are created client-side (in the browser) from
#' `i_layer` via the JS `createModel()` function - no live ArcGIS Server
#' feature service is required when `i_layer` is a self-contained feature
#' collection (see `arcgisutils::as_layer()`/`as_feature_collection()`).
#'
#' @param i_layer A list giving the JSON layer definition (`IFeatureLayer`),
#'   e.g. built with `arcgisutils::as_layer()`.
#' @param chart_type One of the `@arcgis/charts-components` `ModelTypes`
#'   strings, e.g. `"barChart"`, `"lineChart"`, `"scatterplot"`. Validated
#'   against [ModelTypes()].
#' @param x_field,y_field Field names to assign to the chart's x/y axes.
#' @param width,height Widget sizing, passed to [htmlwidgets::createWidget()].
#' @param element_id Optional DOM element ID for the widget.
#'
#' @export
arcgis_chart <- function(
  i_layer,
  chart_type = "barChart",
  x_field = NULL,
  y_field = NULL,
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  chart_type <- ModelTypes(chart_type)

  x <- list(
    iLayer = i_layer,
    chartType = as.character(chart_type),
    xField = x_field,
    yField = y_field
  )

  htmlwidgets::createWidget(
    name = "arcgisChart",
    x = x,
    width = width,
    height = height,
    package = "arcgisviz",
    elementId = element_id,
    sizingPolicy = htmlwidgets::sizingPolicy(
      viewer.fill = TRUE,
      browser.fill = TRUE,
      knitr.figure = FALSE,
      knitr.defaultWidth = "100%",
      knitr.defaultHeight = "400px"
    )
  )
}

#' Shiny bindings for arcgis_chart
#'
#' @param outputId Output variable to read the chart from.
#' @param width,height Sizing, passed to [htmlwidgets::shinyWidgetOutput()].
#'
#' @export
arcgisChartOutput <- function(outputId, width = "100%", height = "400px") {
  htmlwidgets::shinyWidgetOutput(
    outputId,
    "arcgisChart",
    width,
    height,
    package = "arcgisviz"
  )
}

#' @param expr An expression that generates an `arcgis_chart`.
#' @param env The environment in which to evaluate `expr`.
#' @param quoted Is `expr` a quoted expression (with `quote()`)? This is
#'   useful if you want to save an expression in a variable.
#'
#' @rdname arcgisChartOutput
#' @export
renderArcgisChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, arcgisChartOutput, env, quoted = TRUE)
}
