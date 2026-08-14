# htmlwidgets binding for <arcgis-chart>. See srcjs/README.md and
# dev-docs/js-widget-architecture.md. Payload construction lives in
# R/arc-data.R.

#' Render an ArcGIS chart
#'
#' Creates an htmlwidget wrapping the `<arcgis-chart>` web component. The
#' chart's model and layer are created client-side (in the browser) from
#' `i_layer` and `config` via the JS `createModel()` function - no live
#' ArcGIS Server feature service is required when `i_layer` is a
#' self-contained feature collection (see [as_chart_layer()]).
#'
#' Most users want [arc_bar()]/[arc_scatter()]/[arc_line()] instead, which
#' build both arguments for you.
#'
#' @param i_layer A list giving the JSON layer definition (`IFeatureLayer`),
#'   e.g. built with [as_chart_layer()].
#' @param chart_type A `ModelTypes` string, e.g. `"barChart"`. Used to build
#'   the default model that `config` is merged over.
#' @param config A list giving the chart config (`ChartConfig`, i.e. the
#'   `WebChart` shape). May be sparse - it is merged over the defaults
#'   client-side.
#' @param width,height Widget sizing, passed to [htmlwidgets::createWidget()].
#' @param element_id Optional DOM element ID for the widget.
#'
#' @export
arcgis_chart <- function(
  i_layer,
  chart_type,
  config,
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  x <- list(
    iLayer = i_layer,
    chartType = as.character(ModelTypes(chart_type)),
    config = config
  )

  attr(x, "TOJSON_FUNC") <- widget_json

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
