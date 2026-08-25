#' @include enums-widget.R
NULL

# htmlwidgets binding for <arcgis-map>. Unlike <arcgis-chart>, the element
# takes live @arcgis/core objects, so the browser builds a client side
# FeatureLayer from each layer's featureSet. See srcjs/widgets/arcgisMap.js.

#' Render an ArcGIS map
#'
#' Wraps the `<arcgis-map>` web component directly. Most users want [arc_map()]
#' and [add_layer()], which build the arguments for you.
#'
#' @param layers Defines the feature collection layers to draw, each as built
#'   by [as_feature_layer()].
#' @param basemap default `"topo-vector"`. Defines the basemap the layers draw
#'   over, as a basemap id.
#' @param center default `NULL`. Defines the initial centre as `c(lon, lat)`.
#'   When unset the map frames the layers.
#' @param zoom default `NULL`. Defines the initial zoom level.
#' @param extent default `NULL`. Defines the initial extent, overriding
#'   `center` and `zoom`.
#' @param selectable default `NULL`. Defines which layers a click selects in,
#'   by layer id.
#' @param highlight default `NULL`. Defines the selection highlight styles, as
#'   a list of named `HighlightOptions`. See [set_highlight()].
#' @param widgets default `list()`. Defines the SDK components drawn over the
#'   map, each a list of `component`, `position`, and `props`. See
#'   [add_widget()].
#' @param width,height default `NULL`. Defines the widget size, passed to
#'   [htmlwidgets::createWidget()].
#' @param element_id default `NULL`. Defines the DOM element id to render into.
#' @return An htmlwidget.
#' @examples
#' arcgis_map(basemap = "gray-vector", center = c(-98.3, 38.2), zoom = 4)
#' @export
arcgis_map <- function(
  layers = list(),
  basemap = "topo-vector",
  center = NULL,
  zoom = NULL,
  extent = NULL,
  selectable = NULL,
  highlight = NULL,
  widgets = list(),
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  # Shallow, unlike the chart config: a deep walk would visit every feature.
  x <- list(
    layers = unname(layers),
    basemap = basemap,
    center = as.list(center),
    zoom = zoom,
    extent = extent,
    selectable = as.list(selectable),
    highlight = highlight,
    widgets = unname(widgets)
  )
  x <- x[!vapply(x, is_unset, logical(1))]

  attr(x, "TOJSON_FUNC") <- widget_json

  htmlwidgets::createWidget(
    name = "arcgisMap",
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
      knitr.defaultHeight = "500px"
    )
  )
}

#' Shiny bindings for arcgis_map
#'
#' Place `arcgisMapOutput()` in a Shiny UI and `renderArcgisMap()` in the
#' server.
#'
#' @param outputId Defines which output variable the map is read from.
#' @param width,height default `"100%"` and `"500px"`. Defines the output size,
#'   passed to [htmlwidgets::shinyWidgetOutput()].
#' @return A Shiny output or render function.
#' @examples
#' arcgisMapOutput("map")
#' @export
arcgisMapOutput <- function(outputId, width = "100%", height = "500px") {
  htmlwidgets::shinyWidgetOutput(
    outputId,
    "arcgisMap",
    width,
    height,
    package = "arcgisviz"
  )
}

#' @param expr Defines the expression that generates the map.
#' @param env default `parent.frame()`. Defines where `expr` is evaluated.
#' @param quoted default `FALSE`. Defines whether `expr` is already quoted.
#' @rdname arcgisMapOutput
#' @export
renderArcgisMap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) {
    expr <- substitute(expr)
  }
  htmlwidgets::shinyRenderWidget(expr, arcgisMapOutput, env, quoted = TRUE)
}
