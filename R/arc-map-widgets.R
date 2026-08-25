#' @include arc-map.R
NULL

# The Maps SDK ships ~176 widget components. These are the ones that make
# sense over a client side feature collection and take no live object to be
# useful. `props` is the subset of each component's accessors that can travel
# from R at all - the rest take Collections, Portals, or callbacks.
map_widget_map <- list(
  legend = list(
    component = "arcgis-legend",
    position = "bottom-left",
    props = c(
      "legendStyle",
      "cardStyleLayout",
      "basemapLegendVisible",
      "hideLayersNotInCurrentView",
      "ignoreLayerVisibility",
      "respectLayerDefinitionExpression",
      "headingLevel",
      "label",
      "icon"
    )
  ),
  `layer-list` = list(
    component = "arcgis-layer-list",
    position = "top-right",
    props = c(
      "collapsed",
      "closed",
      "dragEnabled",
      "filterPlaceholder",
      "filterText",
      "hideStatusIndicators",
      "minDragEnabledItems",
      "minFilterItems",
      "selectionMode",
      "showCloseButton",
      "showCollapseButton",
      "showErrors",
      "showFilter",
      "showHeading",
      "visibilityAppearance",
      "headingLevel",
      "label",
      "icon"
    )
  ),
  `basemap-gallery` = list(
    component = "arcgis-basemap-gallery",
    position = "top-right",
    props = c("disabled", "headingLevel", "label", "icon")
  ),
  `basemap-toggle` = list(
    component = "arcgis-basemap-toggle",
    position = "bottom-left",
    # nextBasemap autocasts from a basemap id, the same as arc_map()'s.
    props = c("nextBasemap", "showTitle", "label", "icon")
  ),
  search = list(
    component = "arcgis-search",
    position = "top-right",
    props = c(
      "allPlaceholder",
      "autoNavigateDisabled",
      "autoSelectDisabled",
      "disabled",
      "includeDefaultSourcesDisabled",
      "locationDisabled",
      "maxResults",
      "maxSuggestions",
      "minSuggestCharacters",
      "popupDisabled",
      "resultGraphicDisabled",
      "searchAllDisabled",
      "searchTerm",
      "suggestionsDisabled",
      "topLayerDisabled",
      "label",
      "icon"
    )
  ),
  bookmarks = list(
    component = "arcgis-bookmarks",
    position = "top-right",
    props = c(
      "closed",
      "disabled",
      "dragEnabled",
      "filterPlaceholder",
      "filterText",
      "hideThumbnail",
      "hideTime",
      "showAddBookmarkButton",
      "showCloseButton",
      "showCollapseButton",
      "showEditBookmarkButton",
      "showFilter",
      "showHeading",
      "timeDisabled",
      "headingLevel",
      "label",
      "icon"
    )
  ),
  zoom = list(
    component = "arcgis-zoom",
    position = "top-left",
    props = c("layout", "visualScale", "label", "icon")
  ),
  home = list(
    component = "arcgis-home",
    position = "top-left",
    props = c("visualScale", "label", "icon")
  ),
  compass = list(
    component = "arcgis-compass",
    position = "top-left",
    props = c("visualScale", "label", "icon")
  ),
  fullscreen = list(
    component = "arcgis-fullscreen",
    position = "top-left",
    props = c("visualScale", "label")
  ),
  locate = list(
    component = "arcgis-locate",
    position = "top-left",
    props = c(
      "goToLocationDisabled",
      "popupDisabled",
      "scale",
      "visualScale",
      "label",
      "icon"
    )
  ),
  track = list(
    component = "arcgis-track",
    position = "top-left",
    props = c(
      "goToLocationDisabled",
      "rotationDisabled",
      "scale",
      "visualScale",
      "label",
      "icon"
    )
  ),
  sketch = list(
    component = "arcgis-sketch",
    position = "top-right",
    # What is drawn comes back as input$sketch, an Esri feature set that
    # arc_sf() turns into an sf object.
    props = c(
      "availableCreateTools",
      "creationMode",
      "layout",
      "toolbarKind",
      "scale",
      "visualScale",
      "updateOnGraphicClickDisabled",
      "showCreateToolsFreehandPolygon",
      "showCreateToolsFreehandPolyline",
      "showCreateToolsText",
      "hideCreateToolsCircle",
      "hideCreateToolsMultipoint",
      "hideCreateToolsPoint",
      "hideCreateToolsPolygon",
      "hideCreateToolsPolyline",
      "hideCreateToolsRectangle",
      "hideDeleteButton",
      "hideDuplicateButton",
      "hideSelectionToolsLassoSelection",
      "hideSelectionToolsRectangleSelection",
      "hideSettingsMenu",
      "hideSnappingControls",
      "hideUndoRedoMenu",
      "label"
    ),
    arrays = "availableCreateTools"
  ),
  editor = list(
    component = "arcgis-editor",
    position = "top-right",
    # Edits are applied in the browser and reported as input$edits;
    # nothing is written back to the data frame the layer came from.
    props = c(
      "hideCreateFeaturesSection",
      "hideEditFeaturesSection",
      "hideLabelsToggle",
      "hideMergeButton",
      "hideSelectionToolbar",
      "hideSettingsMenu",
      "hideSketch",
      "hideSplitButton",
      "hideUndoRedoButtons",
      "hideZoomToButton",
      "syncViewSelection",
      "headingLevel",
      "label"
    )
  ),
  `area-measurement` = list(
    component = "arcgis-area-measurement-2d",
    position = "top-right",
    props = c(
      "unit",
      "unitOptions",
      "hideStartButton",
      "hideUnitSelect",
      "hideVisualization",
      "label",
      "icon"
    ),
    arrays = "unitOptions"
  ),
  `distance-measurement` = list(
    component = "arcgis-distance-measurement-2d",
    position = "top-right",
    props = c(
      "unit",
      "unitOptions",
      "hideStartButton",
      "hideUnitSelect",
      "hideVisualization",
      "label",
      "icon"
    ),
    arrays = "unitOptions"
  ),
  `scale-bar` = list(
    component = "arcgis-scale-bar",
    position = "bottom-left",
    props = c("barStyle", "unit", "label", "icon")
  ),
  `coordinate-conversion` = list(
    component = "arcgis-coordinate-conversion",
    position = "bottom-left",
    props = c(
      "expanded",
      "hideCaptureButton",
      "hideExpandButton",
      "hideInputButton",
      "hideSettingsButton",
      "mode",
      "multipleConversionsDisabled",
      "orientation",
      "removeLeadingZeros",
      "storageDisabled",
      "headingLevel",
      "label",
      "icon"
    )
  )
)

# The map element's own slot names (arcgis-map/customElement.d.ts:120).
map_positions <- c(
  "top-left",
  "top-right",
  "bottom-left",
  "bottom-right",
  "top-start",
  "top-end",
  "bottom-start",
  "bottom-end"
)

#' A widget on a map
#'
#' One `<arcgis-*>` component and the properties set on it. Built by
#' [add_widget()], not called directly.
#'
#' @name MapWidget
#' @export
MapWidget := new_class(
  properties = list(
    widget = s7x::class_string,
    position = s7x::class_string,
    expand = s7x::class_boolean,
    props = S7::class_list
  )
)

#' Add a widget to a map
#'
#' Puts one of the Maps SDK's own components on the map - a legend, a layer
#' list, a search box, a basemap gallery. Each is a real web component that
#' finds the map itself, so nothing has to be wired up.
#'
#' Adding a widget that is already on the map replaces it, which is what makes
#' `add_widget()` idempotent across [arc_update()] flushes. [remove_widget()]
#' takes one off again.
#'
#' @param map Defines which map or [arc_map_proxy()] to modify.
#' @param widget Defines which component to add. See [map_widgets()] for the
#'   full set.
#' @param position default `NULL`. Defines which corner it sits in, one of
#'   `"top-left"`, `"top-right"`, `"bottom-left"`, `"bottom-right"`, or the
#'   direction-aware `"top-start"`, `"top-end"`, `"bottom-start"`,
#'   `"bottom-end"`. Each widget has its own default.
#' @param expand default `FALSE`. Defines whether the widget is collapsed
#'   behind a button rather than drawn open. Worth it for the panels - the
#'   legend, layer list, basemap gallery - which otherwise cover the map.
#'   Collapsed widgets sharing a corner close each other when opened.
#' @param ... Named properties of the component itself, written either
#'   `snake_case` or `camelCase`. [map_widgets()] lists what each one takes.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |>
#'   add_widget("legend") |>
#'   add_widget("layer-list", position = "top-right", show_filter = TRUE)
#' @export
add_widget <- function(map, widget, position = NULL, expand = FALSE, ...) {
  check_map(map)
  call <- rlang::caller_env()

  if (!rlang::is_bool(expand)) {
    cli::cli_abort(
      c(
        "{.arg expand} must be {.code TRUE} or {.code FALSE}.",
        "x" = "You supplied {.obj_type_friendly {expand}}."
      ),
      call = call
    )
  }

  widget <- rlang::arg_match0(widget, names(map_widget_map), arg_nm = "widget")
  spec <- map_widget_map[[widget]]

  if (rlang::is_null(position)) {
    position <- spec$position
  } else {
    position <- rlang::arg_match0(position, map_positions, arg_nm = "position")
  }

  map@widgets <- c(
    map@widgets[!vapply(map@widgets, is_widget, logical(1), widget)],
    list(MapWidget(
      widget = widget,
      position = position,
      expand = expand,
      props = widget_props(rlang::list2(...), spec, widget, call)
    ))
  )
  map
}

#' @param widget default `NULL`. Defines which widget to take off, by the name
#'   it was added with. `NULL` removes every widget.
#' @rdname add_widget
#' @export
remove_widget <- function(map, widget = NULL) {
  check_map_proxy(map)
  components <- if (rlang::is_null(widget)) {
    NULL
  } else {
    lapply(widget, function(name) {
      map_widget_map[[
        rlang::arg_match0(name, names(map_widget_map), arg_nm = "widget")
      ]]$component
    })
  }

  map_send(map, "removeWidget", list(components = components))
}

#' Every widget a map can carry
#'
#' One row per component [add_widget()] accepts, with the corner it defaults
#' to and the properties it takes.
#'
#' @return A data frame of `widget`, `component`, `position`, and
#'   `properties`.
#' @examples
#' map_widgets()
#' @export
map_widgets <- function() {
  out <- data.frame(
    widget = names(map_widget_map),
    component = vapply(map_widget_map, function(x) x$component, character(1)),
    position = vapply(map_widget_map, function(x) x$position, character(1)),
    row.names = NULL
  )
  out$properties <- unname(lapply(map_widget_map, function(x) x$props))
  arcgisutils::data_frame(out)
}

is_widget <- function(x, widget) {
  identical(x@widget, widget)
}

# Component accessors are camelCase; R users write snake_case. A name with no
# underscore survives unchanged, so both spellings work.
camel_case <- function(x) {
  parts <- strsplit(x, "_", fixed = TRUE)
  vapply(
    parts,
    function(part) {
      rest <- part[-1]
      substr(rest, 1, 1) <- toupper(substr(rest, 1, 1))
      paste0(c(part[[1]], rest), collapse = "")
    },
    character(1)
  )
}

widget_props <- function(props, spec, widget, call) {
  if (rlang::is_empty(props)) {
    return(list())
  }

  names <- names(props)
  if (rlang::is_null(names) || !all(nzchar(names))) {
    cli::cli_abort(
      c(
        "Every property passed to {.fn add_widget} must be named.",
        "i" = "Write {.code show_filter = TRUE}, not {.code TRUE}."
      ),
      call = call
    )
  }

  names(props) <- camel_case(names)
  unknown <- setdiff(names(props), spec$props)
  if (!rlang::is_empty(unknown)) {
    cli::cli_abort(
      c(
        "{.val {widget}} has no propert{?y/ies} {.field {unknown}}.",
        "i" = "It takes: {.field {spec$props}}."
      ),
      call = call
    )
  }

  # A property the component declares as an array has to stay one: auto_unbox
  # would send a single tool name as a bare string.
  for (name in intersect(names(props), spec$arrays)) {
    props[[name]] <- as.list(props[[name]])
  }

  props
}

# The client keys widgets by element name, so that is what crosses the wire.
map_widget_specs <- function(widgets) {
  lapply(widgets, function(widget) {
    spec <- list(
      component = map_widget_map[[widget@widget]]$component,
      position = widget@position,
      props = widget@props
    )
    if (isTRUE(widget@expand)) {
      spec$expand <- TRUE
    }
    spec
  })
}
