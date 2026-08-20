#' @include arcgis-map-widget.R
NULL

library(S7)

# Maps are built from client side feature collections, not live services:
# the same `layerDefinition` + `featureSet` pair charts already send, handed
# to a FeatureLayer's `source` in the browser.

# Which symbol a renderer draws is the geometry's call, not the map's, so
# this is the map's answer to chart_type_map's symbol_* entries.
geometry_symbol_map <- list(
  esriGeometryPoint = list(
    symbol_class = ISimpleMarkerSymbol,
    symbol_type = "esriSMS",
    symbol_style = SimpleMarkerSymbolStyle("esriSMSCircle")
  ),
  esriGeometryMultipoint = list(
    symbol_class = ISimpleMarkerSymbol,
    symbol_type = "esriSMS",
    symbol_style = SimpleMarkerSymbolStyle("esriSMSCircle")
  ),
  esriGeometryPolyline = list(
    symbol_class = ISimpleLineSymbol,
    symbol_type = "esriSLS",
    symbol_style = SimpleLineSymbolStyle("esriSLSSolid")
  ),
  esriGeometryPolygon = list(
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  )
)

#' A layer on a map
#'
#' One feature collection layer and the aesthetics mapped onto it. Built by
#' [add_layer()], not called directly.
#'
#' @name MapLayer
#' @export
MapLayer := new_class(
  properties = list(
    data = S7::class_any,
    name = s7x::class_string,
    color = S7::class_list,
    size = s7x::class_double,
    opacity = s7x::class_double,
    visible = s7x::class_boolean
  )
)

#' A map
#'
#' The object [arc_map()] returns and every `set_*()` and [add_layer()] call
#' takes and returns.
#'
#' @name ArcMap
#' @export
ArcMap := new_class(
  properties = list(
    layers = S7::class_list,
    basemap = s7x::class_string,
    center = S7::class_numeric,
    zoom = s7x::class_double,
    extent = S7::class_list
  )
)

#' Start a map
#'
#' Creates an empty map to pipe [add_layer()] and the `set_*()` functions
#' into. Printing it renders the widget.
#'
#' @param basemap default `"topo-vector"`. Defines the basemap the layers draw
#'   over. See [Basemaps] for the full set.
#' @return An [ArcMap].
#' @examples
#' arc_map("gray-vector")
#' @export
arc_map <- function(basemap = "topo-vector") {
  ArcMap(basemap = as.character(Basemaps(basemap)))
}

#' Set the basemap
#'
#' Replaces the imagery the layers draw over.
#'
#' @param map Defines which map to modify.
#' @param basemap Defines the basemap id. See [Basemaps].
#' @return `map`, with the basemap set.
#' @examples
#' set_basemap(arc_map(), "satellite")
#' @export
set_basemap <- function(map, basemap) {
  check_map(map)
  map@basemap <- as.character(Basemaps(basemap))
  map
}

#' Set the initial view
#'
#' Positions the map. Leave everything unset and the map frames its layers
#' instead.
#'
#' @param map Defines which map to modify.
#' @param center default `NULL`. Defines the centre as `c(longitude, latitude)`.
#' @param zoom default `NULL`. Defines the zoom level, from `0` (the world) to
#'   about `23`.
#' @param extent default `NULL`. Defines the visible extent as a named list of
#'   `xmin`, `ymin`, `xmax`, `ymax`, and `spatialReference`. Overrides `center`
#'   and `zoom`.
#' @return `map`, with the view set.
#' @examples
#' set_view(arc_map(), center = c(-98.3, 38.2), zoom = 4)
#' @export
set_view <- function(map, center = NULL, zoom = NULL, extent = NULL) {
  check_map(map)

  if (!rlang::is_null(center)) {
    if (!is.numeric(center) || length(center) != 2L) {
      cli::cli_abort(
        "{.arg center} must be two numbers, {.code c(longitude, latitude)}.",
        call = rlang::caller_env()
      )
    }
    map@center <- as.double(center)
  }

  if (!rlang::is_null(zoom)) {
    map@zoom <- as.double(zoom)
  }

  if (!rlang::is_null(extent)) {
    map@extent <- as.list(extent)
  }

  map
}

#' Add a layer to a map
#'
#' Draws a data frame or `sf` object as a client side feature layer. Colour
#' takes a bare column name, the same as [set_color()] does on a chart.
#'
#' @param map Defines which map to modify.
#' @param .data Defines which `sf` object supplies the features.
#' @param color default `NULL`. Defines which column drives the symbol colour.
#'   A numeric column becomes a gradient, anything else one colour per value.
#' @param palette default `NULL`. Defines the colour ramp, either an Esri ramp
#'   name from [esri_palettes()] or a vector of R colours.
#' @param size default `NULL`. Defines the marker size or line width in points.
#' @param opacity default `NULL`. Defines the layer opacity, from `0` to `1`.
#' @param name default `NULL`. Defines the layer name shown in a legend.
#' @return `map`, with the layer appended.
#' @examples
#' set_basemap(arc_map(), "gray-vector")
#' @export
add_layer <- function(
  map,
  .data,
  color = NULL,
  palette = NULL,
  size = NULL,
  opacity = NULL,
  name = NULL
) {
  check_map(map)
  call <- rlang::caller_env()

  layer <- MapLayer(
    data = .data,
    name = if (rlang::is_null(name)) NA_character_ else name,
    size = if (rlang::is_null(size)) NA_real_ else as.double(size),
    opacity = if (rlang::is_null(opacity)) NA_real_ else as.double(opacity),
    visible = TRUE
  )

  # Resolved here, not at render, so a bad palette blames this call.
  stops <- if (rlang::is_null(palette)) {
    NULL
  } else {
    palette_stops(palette, call = call)
  }
  layer@color <- list(stops = stops)

  if (!rlang::quo_is_null(rlang::enquo(color))) {
    col <- rlang::as_string(rlang::ensym(color))
    if (!col %in% names(.data)) {
      cli::cli_abort(
        c(
          "{.arg color} must be a column in {.arg .data}.",
          "x" = "Column {.field {col}} not found.",
          "i" = "A fixed colour goes in {.arg palette} instead."
        ),
        call = call
      )
    }
    layer@color$field <- col
  }

  map@layers <- c(map@layers, list(layer))
  map
}

check_map <- function(map, call = rlang::caller_env()) {
  if (!S7::S7_inherits(map, ArcMap)) {
    cli::cli_abort(
      "{.arg map} must be an {.cls ArcMap}, not {.obj_type_friendly {map}}.",
      call = call
    )
  }
  invisible(map)
}

# A map renderer resolves per feature against the layer, so the uniqueValue
# branch that charts can only use while aggregating is always available here.
map_renderer <- function(layer, spec, call) {
  color <- layer@color
  size <- if (is.na(layer@size)) NULL else layer@size

  if (rlang::is_null(color$field)) {
    return(ISimpleRenderer(
      type = "simple",
      symbol = renderer_symbol(spec, discrete_colors(color$stops, 1)[[1]], size)
    ))
  }

  values <- layer@data[[color$field]]
  if (is.numeric(values)) {
    return(continuous_renderer(
      color$field,
      values,
      color$stops,
      spec,
      call,
      size
    ))
  }

  levels <- color_levels(values)
  if (rlang::is_empty(levels)) {
    cli::cli_abort(
      c(
        "{.arg color} must map a column with at least one non-missing value.",
        "x" = "{.field {color$field}} has none."
      ),
      call = call
    )
  }

  unique_value_renderer(
    color$field,
    levels,
    discrete_colors(color$stops, length(levels)),
    spec,
    size
  )
}

S7::method(as_widget, ArcMap) <- function(
  x,
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  if (rlang::is_empty(x@layers)) {
    cli::cli_abort("{.arg x} has no layers to render.")
  }

  call <- rlang::caller_env()
  layers <- lapply(seq_along(x@layers), function(i) {
    layer <- x@layers[[i]]
    geometry <- sf_geometry_type(layer@data, call)
    name <- if (is.na(layer@name)) paste0("layer_", i) else layer@name

    as_feature_layer(
      layer@data,
      name = name,
      id = paste0("arcgisviz-layer-", i),
      drawing_info = list(
        renderer = map_renderer(layer, geometry_symbol_map[[geometry]], call)
      ),
      opacity = if (is.na(layer@opacity)) NULL else layer@opacity,
      visibility = layer@visible
    )
  })

  arcgis_map(
    layers = layers,
    basemap = x@basemap,
    center = x@center,
    zoom = if (is.na(x@zoom)) NULL else x@zoom,
    extent = if (rlang::is_empty(x@extent)) NULL else x@extent,
    width = width,
    height = height,
    element_id = element_id
  )
}

# The renderer has to be picked before as_map_layer() runs, so the geometry
# type is read here rather than off the converted layer.
sf_geometry_type <- function(.data, call) {
  rlang::check_installed("sf")
  # cli reads a braced `.data` as one of its own inline classes.
  given <- .data
  if (!inherits(given, "sf")) {
    cli::cli_abort(
      c(
        "{.arg .data} must have geometry to be drawn on a map.",
        "x" = "Got {.obj_type_friendly {given}}.",
        "i" = "Convert it with {.fn sf::st_as_sf} first."
      ),
      call = call
    )
  }

  type <- as.character(unique(sf::st_geometry_type(.data)))
  esri <- unique(paste0(
    "esriGeometry",
    c(
      POINT = "Point",
      MULTIPOINT = "Multipoint",
      LINESTRING = "Polyline",
      MULTILINESTRING = "Polyline",
      POLYGON = "Polygon",
      MULTIPOLYGON = "Polygon"
    )[type]
  ))

  if (length(esri) != 1L || is.na(esri)) {
    cli::cli_abort(
      c(
        "{.arg .data} must hold one supported geometry type.",
        "x" = "Found {.val {type}}."
      ),
      call = call
    )
  }
  esri
}

S7::method(print, ArcMap) <- function(x, ...) {
  print(as_widget(x), ...)
  invisible(x)
}
