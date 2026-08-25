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
    size = s7x::class_float,
    opacity = s7x::class_float,
    visible = s7x::class_boolean,
    selectable = s7x::class_boolean,
    tooltip = S7::class_character
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
    zoom = s7x::class_float,
    extent = S7::class_list,
    highlight = S7::class_list
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

#' Style the selection highlight
#'
#' Changes how selected features are drawn. Works on an [arc_map()] before it
#' is rendered and on an [arc_map_proxy()] after, and applies to every
#' selection - the ones [set_selection()] makes, the ones a click on a
#' `selectable` layer makes, and the ones [arc_select()] draws.
#'
#' @param map Defines which map or proxy to modify.
#' @param color default `NULL`. Defines the highlight colour, as a name or hex
#'   string.
#' @param halo_opacity default `NULL`. Defines the opacity of the outline drawn
#'   around a selected feature, from `0` to `1`.
#' @param fill_opacity default `NULL`. Defines the opacity of the fill drawn
#'   over a selected feature, from `0` to `1`.
#' @param shadow_color default `NULL`. Defines the colour of the shadow cast
#'   over everything that is *not* selected.
#' @param shadow_opacity default `NULL`. Defines that shadow's opacity, from
#'   `0` to `1`.
#' @param shadow_difference default `NULL`. Defines how much the shadow dims
#'   the unselected features, from `0` to `1`.
#' @return `map`, with the highlight style set.
#' @examples
#' arc_map() |>
#'   set_highlight(color = "orange", fill_opacity = 0.4)
#' @export
set_highlight <- function(
  map,
  color = NULL,
  halo_opacity = NULL,
  fill_opacity = NULL,
  shadow_color = NULL,
  shadow_opacity = NULL,
  shadow_difference = NULL
) {
  check_map(map)
  call <- rlang::caller_env()

  options <- drop_null(list(
    color = if (!rlang::is_null(color)) hex_color(color, "color", call),
    haloOpacity = halo_opacity,
    fillOpacity = fill_opacity,
    shadowColor = if (!rlang::is_null(shadow_color)) {
      hex_color(shadow_color, "shadow_color", call)
    },
    shadowOpacity = shadow_opacity,
    shadowDifference = shadow_difference
  ))

  # The view keeps a named collection of highlight styles and reads "default"
  # for any highlight that does not ask for another one.
  map@highlight <- list(c(list(name = "default"), options))
  map
}

# Only the ids, since the client already has the layers themselves. A list so
# that one selectable layer still serializes as an array.
selectable_ids <- function(layers) {
  ids <- lapply(seq_along(layers), function(i) {
    if (isTRUE(layers[[i]]@selectable)) map_layer_id(layers[[i]], i) else NULL
  })
  ids[!vapply(ids, rlang::is_null, logical(1))]
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
#' @param name default `NULL`. Defines the layer name, which is also the handle
#'   [remove_layer()] and [set_layer()] take. On an [arc_map_proxy()] it is
#'   required, because that is what tells the browser which layer is meant.
#' @param tooltip default `NULL`. Defines which columns are shown when a
#'   feature is hovered, as bare column names wrapped in `c()`. Name one to
#'   label it, as in `c(County = NAME)`.
#' @param selectable default `NULL`. Defines whether clicking a feature adds it
#'   to the selection, which arrives in Shiny as `input$<id>_selection`. See
#'   [set_selection()].
#' @param visible default `NULL`. Defines whether the layer starts drawn.
#'   Only when `.data` is an [IFeatureLayer].
#' @param ... Passed between methods. Must be empty when `.data` is an
#'   [IFeatureLayer], whose own properties already answer `color`, `palette`,
#'   `size` and `tooltip`.
#' @return `map`, with the layer appended.
#' @details
#' `.data` is either a data frame to build a layer from, or an
#' [IFeatureLayer] you built yourself. The second form is the escape hatch:
#' anything this function does not expose is done by constructing the layer
#' and modifying it, usually with [add_renderer()].
#'
#' ```r
#' nc |>
#'   as_feature_layer() |>
#'   add_renderer(ISimpleRenderer(symbol = my_symbol)) |>
#'   (\(lyr) add_layer(arc_map(), lyr))()
#' ```
#' @examples
#' set_basemap(arc_map(), "gray-vector")
#' @export
add_layer <- S7::new_generic(
  "add_layer",
  c("map", ".data"),
  function(map, .data, ...) S7::S7_dispatch()
)

S7::method(add_layer, list(ArcMap, S7::class_any)) <- function(
  map,
  .data,
  color = NULL,
  palette = NULL,
  size = NULL,
  opacity = NULL,
  name = NULL,
  tooltip = NULL,
  selectable = NULL,
  ...
) {
  call <- rlang::caller_env()
  check_proxy_layer_name(map, name, call)

  layer <- MapLayer(
    data = .data,
    name = if (rlang::is_null(name)) NA_character_ else name,
    size = if (rlang::is_null(size)) NA_real_ else as.double(size),
    opacity = if (rlang::is_null(opacity)) NA_real_ else as.double(opacity),
    visible = TRUE,
    selectable = isTRUE(selectable),
    tooltip = tooltip_columns(rlang::enquo(tooltip), .data, call)
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

# A layer the caller built already carries its own renderer, fields and
# popupInfo, so only the map-level properties are still open.
S7::method(add_layer, list(ArcMap, IFeatureLayer)) <- function(
  map,
  .data,
  ...,
  name = NULL,
  opacity = NULL,
  visible = NULL,
  selectable = NULL
) {
  call <- rlang::caller_env()
  rlang::check_dots_empty(call = call)
  check_proxy_layer_name(map, name, call)

  layer <- MapLayer(
    data = .data,
    name = if (rlang::is_null(name)) NA_character_ else name,
    size = NA_real_,
    opacity = if (rlang::is_null(opacity)) NA_real_ else as.double(opacity),
    visible = if (rlang::is_null(visible)) TRUE else visible,
    selectable = isTRUE(selectable),
    color = list(),
    tooltip = character()
  )

  map@layers <- c(map@layers, list(layer))
  map
}

S7::method(add_layer, list(S7::class_any, S7::class_any)) <- function(
  map,
  .data,
  ...
) {
  check_map(map)
}

# `c(County = NAME, Births = BIR74)`, matching how set_tooltip() reads a
# chart's: a bare column labels itself, a named one takes the name.
tooltip_columns <- function(quo, .data, call) {
  expr <- rlang::quo_get_expr(quo)
  if (rlang::is_null(expr)) {
    return(character())
  }

  wrapped <- rlang::is_call(expr, "c")
  args <- if (wrapped) rlang::call_args(expr) else list(expr)
  labels <- if (wrapped) rlang::call_args_names(expr) else ""

  cols <- vapply(
    args,
    function(arg) {
      if (!rlang::is_symbol(arg) && !rlang::is_string(arg)) {
        cli::cli_abort(
          c(
            "{.arg tooltip} must be bare column names.",
            "i" = "Wrap several in {.code c()}, as in
                   {.code tooltip = c(name, value)}."
          ),
          call = call
        )
      }
      rlang::as_string(arg)
    },
    character(1)
  )

  missing <- setdiff(cols, names(.data))
  if (!rlang::is_empty(missing)) {
    cli::cli_abort(
      c(
        "{.arg tooltip} must name columns in {.arg .data}.",
        "x" = "Column{?s} {.field {missing}} not found."
      ),
      call = call
    )
  }

  labels[labels == ""] <- cols[labels == ""]
  rlang::set_names(cols, labels)
}

# The web map spec already names "these fields, with these labels": popupInfo
# on the feature collection layer. The browser reads it for hover and popups.
map_popup_info <- function(fields, title) {
  if (rlang::is_empty(fields)) {
    return(NULL)
  }

  list(
    title = title,
    fieldInfos = lapply(seq_along(fields), function(i) {
      list(
        fieldName = unname(fields[[i]]),
        label = names(fields)[[i]],
        visible = TRUE
      )
    })
  )
}

# A named layer is identified by its name so that a proxy can replace, remove,
# or filter it later; an unnamed one only ever needs to be positionally unique.
map_layer_id <- function(layer, i) {
  if (is.na(layer@name)) paste0("arcgisviz-layer-", i) else layer@name
}

#' Set a layer's renderer
#'
#' Attaches a renderer to a layer built by [as_feature_layer()], so that a
#' symbology this package does not expose can still be handed to [add_layer()].
#'
#' @param layer Defines which [IFeatureLayer] to modify.
#' @param renderer Defines the renderer, an [ISimpleRenderer] or an
#'   [IUniqueValueRenderer].
#' @return `layer`, with the renderer set on its `layerDefinition`.
#' @examples
#' df <- data.frame(species = c("a", "b"), mass = c(1, 5))
#'
#' as_feature_layer(df) |>
#'   add_renderer(ISimpleRenderer(symbol = ISimpleMarkerSymbol(size = 8)))
#' @export
add_renderer <- function(layer, renderer) {
  call <- rlang::caller_env()
  if (!S7::S7_inherits(layer, IFeatureLayer)) {
    cli::cli_abort(
      c(
        "{.arg layer} must be an {.cls IFeatureLayer}.",
        "i" = "Build one with {.fn as_feature_layer}."
      ),
      call = call
    )
  }
  if (!is_renderer(renderer)) {
    cli::cli_abort(
      c(
        "{.arg renderer} must be an {.cls ISimpleRenderer} or an
         {.cls IUniqueValueRenderer}.",
        "x" = "You supplied {.obj_type_friendly {renderer}}."
      ),
      call = call
    )
  }

  # Narrow rewrite of a layer arcgisutils built, the same move
  # tooltip_aliased() makes - not a hand-assembled layer shape.
  collection <- layer@featureCollection
  collection$layers[[1]]$layerDefinition$drawingInfo$renderer <- renderer
  layer@featureCollection <- collection
  layer
}

is_renderer <- function(x) {
  S7::S7_inherits(x, ISimpleRenderer) ||
    S7::S7_inherits(x, IUniqueValueRenderer)
}

# The caller's own id survives; only an unset or still-default one is filled
# in, since two prebuilt layers would otherwise share as_feature_layer()'s.
prebuilt_layer <- function(layer, i) {
  built <- layer@data
  if (!is.na(layer@name)) {
    built@id <- layer@name
    built@title <- layer@name
  } else if (is.na(built@id) || identical(built@id, "arcgisviz-layer")) {
    built@id <- paste0("arcgisviz-layer-", i)
  }
  if (!is.na(layer@opacity)) {
    built@opacity <- layer@opacity
  }
  if (!isTRUE(layer@visible)) {
    built@visibility <- layer@visible
  }
  built
}

map_feature_layer <- function(layer, i, call) {
  if (S7::S7_inherits(layer@data, IFeatureLayer)) {
    return(prebuilt_layer(layer, i))
  }
  geometry <- sf_geometry_type(layer@data, call)
  name <- if (is.na(layer@name)) paste0("layer_", i) else layer@name

  as_feature_layer(
    layer@data,
    name = name,
    id = map_layer_id(layer, i),
    drawing_info = list(
      renderer = map_renderer(layer, geometry_symbol_map[[geometry]], call)
    ),
    opacity = if (is.na(layer@opacity)) NULL else layer@opacity,
    visibility = layer@visible,
    popup_info = map_popup_info(layer@tooltip, name)
  )
}

# On a proxy the name is the layer's only handle: the browser has to be told
# which layer to replace, and set_layer()/remove_layer() take the same name.
check_proxy_layer_name <- function(map, name, call) {
  if (!S7::S7_inherits(map, ArcMapProxy) || !rlang::is_null(name)) {
    return(invisible(NULL))
  }
  cli::cli_abort(
    c(
      "{.arg name} is required when adding a layer to an {.cls ArcMapProxy}.",
      "i" = "It is what {.fn set_layer} and {.fn remove_layer} refer to."
    ),
    call = call
  )
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
    map_feature_layer(x@layers[[i]], i, call)
  })

  arcgis_map(
    layers = layers,
    basemap = x@basemap,
    center = x@center,
    zoom = if (is.na(x@zoom)) NULL else x@zoom,
    extent = if (rlang::is_empty(x@extent)) NULL else x@extent,
    selectable = selectable_ids(x@layers),
    highlight = if (rlang::is_empty(x@highlight)) NULL else x@highlight,
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
