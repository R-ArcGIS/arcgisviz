#' @include enums-widget.R
NULL

# htmlwidgets binding for <arcgis-chart>. See srcjs/README.md and
# dev-docs/js-widget-architecture.md. Payload construction lives in
# R/arc-data.R.

#' Render an ArcGIS chart
#'
#' Wraps the `<arcgis-chart>` web component directly. Most users want
#' [arc_bar()], [arc_scatter()], or [arc_line()], which build the arguments
#' for you.
#'
#' @param i_layer Defines the layer the chart reads, as built by
#'   [as_feature_layer()].
#' @param chart_type Defines which default model the config merges over, such
#'   as `"barChart"`. See [ModelTypes].
#' @param config Defines the chart configuration in the `WebChart` shape. May
#'   be sparse because the browser merges it over the defaults.
#' @param tooltip default `NULL`. Defines extra tooltip rows as `labels` plus
#'   a `lookup` keyed by series and mark, as built by [set_tooltip()].
#' @param width,height default `NULL`. Defines the widget size, passed to
#'   [htmlwidgets::createWidget()].
#' @param element_id default `NULL`. Defines the DOM element id to render into.
#' @return An htmlwidget.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arcgis_chart(
#'   i_layer = as_feature_layer(df),
#'   chart_type = "barChart",
#'   config = arc_col(df, species, mass)@webchart
#' )
#' @export
arcgis_chart <- function(
  i_layer,
  chart_type,
  config,
  tooltip = NULL,
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  x <- list(
    iLayer = i_layer,
    chartType = as.character(ModelTypes(chart_type)),
    config = config,
    tooltip = tooltip
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
#' Place `arcgisChartOutput()` in a Shiny UI and `renderArcgisChart()` in the
#' server.
#'
#' @param outputId Defines which output variable the chart is read from.
#' @param width,height default `"100%"` and `"400px"`. Defines the output size,
#'   passed to [htmlwidgets::shinyWidgetOutput()].
#' @return A Shiny output or render function.
#' @examples
#' arcgisChartOutput("chart")
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

#' @param expr Defines the expression that generates the chart.
#' @param env default `parent.frame()`. Defines where `expr` is evaluated.
#' @param quoted default `FALSE`. Defines whether `expr` is already quoted.
#' @rdname arcgisChartOutput
#' @export
renderArcgisChart <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, arcgisChartOutput, env, quoted = TRUE)
}
