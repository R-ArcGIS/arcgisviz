#' @include arc-map-widgets.R
NULL

# One function per widget, each one add_widget() with the properties it
# documents. Arguments are the snake_case of the component's own property
# names, so there is a single vocabulary to learn and nothing to keep in sync
# beyond map_widget_map. An unset argument is dropped rather than sent as null.

#' Add a legend
#'
#' Draws one entry per layer, reading each layer's renderer - so a map with
#' `add_layer(color = )` explains its own colours.
#'
#' @inheritParams add_widget
#' @param legend_style default `NULL`. Defines the layout, `"classic"` or
#'   `"card"`.
#' @param card_style_layout default `NULL`. Defines how cards are arranged
#'   when `legend_style` is `"card"`, `"auto"`, `"side-by-side"`, or
#'   `"stack"`.
#' @param basemap_legend_visible default `NULL`. Defines whether the basemap's
#'   own layers get legend entries.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_legend(expand = TRUE)
#' @export
add_legend <- function(
  map,
  position = NULL,
  expand = FALSE,
  legend_style = NULL,
  card_style_layout = NULL,
  basemap_legend_visible = NULL,
  ...
) {
  props <- drop_null(list(
    legend_style = legend_style,
    card_style_layout = card_style_layout,
    basemap_legend_visible = basemap_legend_visible
  ))
  rlang::inject(add_widget(
    map,
    "legend",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a layer list
#'
#' Lists the map's layers, with a checkbox each. Every layer [add_layer()]
#' drew appears under the `name` it was given.
#'
#' @inheritParams add_widget
#' @param show_filter default `NULL`. Defines whether a filter box is drawn
#'   above the list.
#' @param filter_placeholder default `NULL`. Defines that box's placeholder
#'   text.
#' @param drag_enabled default `NULL`. Defines whether layers can be reordered
#'   by dragging.
#' @param selection_mode default `NULL`. Defines how items are selected, one
#'   of `"none"`, `"single"`, `"multiple"`, or `"single-persist"`.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_layer_list(show_filter = TRUE)
#' @export
add_layer_list <- function(
  map,
  position = NULL,
  expand = FALSE,
  show_filter = NULL,
  filter_placeholder = NULL,
  drag_enabled = NULL,
  selection_mode = NULL,
  ...
) {
  props <- drop_null(list(
    show_filter = show_filter,
    filter_placeholder = filter_placeholder,
    drag_enabled = drag_enabled,
    selection_mode = selection_mode
  ))
  rlang::inject(add_widget(
    map,
    "layer-list",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a basemap gallery
#'
#' Lets the reader swap the basemap for any in the gallery. `add_basemap_
#' toggle()` is the two-basemap version, a single button.
#'
#' @inheritParams add_widget
#' @param disabled default `NULL`. Defines whether the gallery is greyed out.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_basemap_gallery(expand = TRUE)
#' @export
add_basemap_gallery <- function(
  map,
  position = NULL,
  expand = FALSE,
  disabled = NULL,
  ...
) {
  props <- drop_null(list(disabled = disabled))
  rlang::inject(add_widget(
    map,
    "basemap-gallery",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' @param next_basemap default `NULL`. Defines the basemap to toggle to, as an
#'   id from [Basemaps].
#' @param show_title default `NULL`. Defines whether the basemap's name is
#'   drawn under the button.
#' @rdname add_basemap_gallery
#' @examples
#' arc_map() |> add_basemap_toggle(next_basemap = "satellite")
#' @export
add_basemap_toggle <- function(
  map,
  position = NULL,
  expand = FALSE,
  next_basemap = NULL,
  show_title = NULL,
  ...
) {
  props <- drop_null(list(
    next_basemap = next_basemap,
    show_title = show_title
  ))
  rlang::inject(add_widget(
    map,
    "basemap-toggle",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a search box
#'
#' Finds places by name and moves the map to them, using Esri's geocoding
#' service. Nothing needs configuring for place search.
#'
#' @inheritParams add_widget
#' @param search_term default `NULL`. Defines the text the box starts with.
#' @param all_placeholder default `NULL`. Defines the placeholder text.
#' @param max_results default `NULL`. Defines how many results a search
#'   returns.
#' @param popup_disabled default `NULL`. Defines whether choosing a result
#'   opens a popup.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_search(all_placeholder = "Find a county")
#' @export
add_search <- function(
  map,
  position = NULL,
  expand = FALSE,
  search_term = NULL,
  all_placeholder = NULL,
  max_results = NULL,
  popup_disabled = NULL,
  ...
) {
  props <- drop_null(list(
    search_term = search_term,
    all_placeholder = all_placeholder,
    max_results = max_results,
    popup_disabled = popup_disabled
  ))
  rlang::inject(add_widget(
    map,
    "search",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a bookmark list
#'
#' Saves and returns to named views of the map.
#'
#' @inheritParams add_widget
#' @param show_add_bookmark_button default `NULL`. Defines whether the reader
#'   can add bookmarks.
#' @param show_edit_bookmark_button default `NULL`. Defines whether existing
#'   bookmarks can be renamed.
#' @param hide_thumbnail default `NULL`. Defines whether each bookmark's
#'   preview image is hidden.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_bookmarks(show_add_bookmark_button = TRUE)
#' @export
add_bookmarks <- function(
  map,
  position = NULL,
  expand = FALSE,
  show_add_bookmark_button = NULL,
  show_edit_bookmark_button = NULL,
  hide_thumbnail = NULL,
  ...
) {
  props <- drop_null(list(
    show_add_bookmark_button = show_add_bookmark_button,
    show_edit_bookmark_button = show_edit_bookmark_button,
    hide_thumbnail = hide_thumbnail
  ))
  rlang::inject(add_widget(
    map,
    "bookmarks",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a scale bar
#'
#' Shows the map's scale, and rescales itself as the reader zooms.
#'
#' @inheritParams add_widget
#' @param unit default `NULL`. Defines the units shown, one of `"metric"`,
#'   `"imperial"`, or `"dual"`.
#' @param bar_style default `NULL`. Defines how it is drawn, `"line"` or
#'   `"ruler"`.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_scale_bar(unit = "dual")
#' @export
add_scale_bar <- function(
  map,
  position = NULL,
  unit = NULL,
  bar_style = NULL,
  ...
) {
  props <- drop_null(list(unit = unit, bar_style = bar_style))
  rlang::inject(add_widget(
    map,
    "scale-bar",
    position = position,
    !!!props,
    ...
  ))
}

#' Add a coordinate readout
#'
#' Reports the coordinates under the pointer, in the formats the reader picks.
#'
#' @inheritParams add_widget
#' @param mode default `NULL`. Defines whether it reads the pointer or a
#'   captured point, `"live"` or `"capture"`.
#' @param orientation default `NULL`. Defines which way the list opens,
#'   `"auto"`, `"expand-up"`, or `"expand-down"`.
#' @param expanded default `NULL`. Defines whether the format list starts
#'   open. Unrelated to `expand`, which collapses the whole widget behind a
#'   button.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_coordinate_conversion(mode = "capture")
#' @export
add_coordinate_conversion <- function(
  map,
  position = NULL,
  expand = FALSE,
  mode = NULL,
  orientation = NULL,
  expanded = NULL,
  ...
) {
  props <- drop_null(list(
    mode = mode,
    orientation = orientation,
    expanded = expanded
  ))
  rlang::inject(add_widget(
    map,
    "coordinate-conversion",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a navigation control
#'
#' The map's buttons: zoom in and out, return to the starting view, reorient
#' north, fill the screen, and find the reader. They take no arguments beyond
#' where they sit.
#'
#' `add_locate()` moves the map to the reader's position once;
#' `add_track()` follows it as it changes. Both ask the browser for
#' permission, and both need a secure context - `https://` or `localhost`.
#'
#' @inheritParams add_widget
#' @param visual_scale default `NULL`. Defines the button's size relative to
#'   its default, as a multiplier.
#' @param layout default `NULL`. Defines whether the two zoom buttons stack,
#'   `"vertical"` or `"horizontal"`.
#' @param scale default `NULL`. Defines the scale the map zooms to when the
#'   reader is found.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |>
#'   add_zoom(layout = "horizontal") |>
#'   add_home() |>
#'   add_compass()
#' @export
add_zoom <- function(
  map,
  position = NULL,
  layout = NULL,
  visual_scale = NULL,
  ...
) {
  props <- drop_null(list(layout = layout, visual_scale = visual_scale))
  rlang::inject(add_widget(map, "zoom", position = position, !!!props, ...))
}

#' @rdname add_zoom
#' @export
add_home <- function(map, position = NULL, visual_scale = NULL, ...) {
  props <- drop_null(list(visual_scale = visual_scale))
  rlang::inject(add_widget(map, "home", position = position, !!!props, ...))
}

#' @rdname add_zoom
#' @export
add_compass <- function(map, position = NULL, visual_scale = NULL, ...) {
  props <- drop_null(list(visual_scale = visual_scale))
  rlang::inject(add_widget(map, "compass", position = position, !!!props, ...))
}

#' @rdname add_zoom
#' @export
add_fullscreen <- function(map, position = NULL, visual_scale = NULL, ...) {
  props <- drop_null(list(visual_scale = visual_scale))
  rlang::inject(add_widget(
    map,
    "fullscreen",
    position = position,
    !!!props,
    ...
  ))
}

#' @rdname add_zoom
#' @export
add_locate <- function(
  map,
  position = NULL,
  scale = NULL,
  visual_scale = NULL,
  ...
) {
  props <- drop_null(list(scale = scale, visual_scale = visual_scale))
  rlang::inject(add_widget(map, "locate", position = position, !!!props, ...))
}

#' @rdname add_zoom
#' @export
add_track <- function(
  map,
  position = NULL,
  scale = NULL,
  visual_scale = NULL,
  ...
) {
  props <- drop_null(list(scale = scale, visual_scale = visual_scale))
  rlang::inject(add_widget(map, "track", position = position, !!!props, ...))
}

#' Add a drawing tool
#'
#' Hands the reader tools to draw with. What they draw arrives in Shiny as
#' `input$<output_id>$sketch`, which [arc_sf()] turns into an `sf` object.
#'
#' @inheritParams add_widget
#' @param tools default `NULL`. Defines which tools are offered, any of
#'   `"point"`, `"polyline"`, `"polygon"`, `"rectangle"`, `"circle"`,
#'   `"multipoint"`, `"freehandPolyline"`, and `"freehandPolygon"`.
#' @param creation_mode default `NULL`. Defines what happens after a shape is
#'   finished, one of `"single"`, `"continuous"`, or `"update"`.
#' @param layout default `NULL`. Defines the toolbar direction, `"vertical"`
#'   or `"horizontal"`.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_sketch(tools = c("polygon", "rectangle"))
#' @export
add_sketch <- function(
  map,
  position = NULL,
  expand = FALSE,
  tools = NULL,
  creation_mode = NULL,
  layout = NULL,
  ...
) {
  # `tools` reads better than the component's own availableCreateTools, and
  # it is the only argument in this file that renames a property.
  props <- drop_null(list(
    available_create_tools = tools,
    creation_mode = creation_mode,
    layout = layout
  ))
  rlang::inject(add_widget(
    map,
    "sketch",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add an editor
#'
#' Lets the reader change the features on the map - move them, retype their
#' attributes, add and delete. Edits happen in the browser and arrive in Shiny
#' as `input$<output_id>$edits`; nothing is written back to the data frame the
#' layer came from unless R does it.
#'
#' @inheritParams add_widget
#' @param hide_create_features_section default `NULL`. Defines whether the
#'   "add a feature" half of the panel is hidden, leaving editing only.
#' @param sync_view_selection default `NULL`. Defines whether the editor and
#'   the map share one selection.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |> add_editor(position = "top-right")
#' @export
add_editor <- function(
  map,
  position = NULL,
  expand = FALSE,
  hide_create_features_section = NULL,
  sync_view_selection = NULL,
  ...
) {
  props <- drop_null(list(
    hide_create_features_section = hide_create_features_section,
    sync_view_selection = sync_view_selection
  ))
  rlang::inject(add_widget(
    map,
    "editor",
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}

#' Add a measurement tool
#'
#' Measures distance along a drawn line, or the area and perimeter of a drawn
#' shape. The result arrives in Shiny as `input$<output_id>$measurement`, a
#' value and its unit.
#'
#' @inheritParams add_widget
#' @param type default `"area"`. Defines what is measured, `"area"` or
#'   `"distance"`. Add one of each to offer both.
#' @param unit default `NULL`. Defines the unit the result is shown in, such
#'   as `"square-kilometers"` or `"miles"`.
#' @param unit_options default `NULL`. Defines which units the reader can pick
#'   from.
#' @return `map`, with the widget added.
#' @examples
#' arc_map() |>
#'   add_measurement("area", unit = "square-kilometers") |>
#'   add_measurement("distance")
#' @export
add_measurement <- function(
  map,
  type = "area",
  position = NULL,
  expand = FALSE,
  unit = NULL,
  unit_options = NULL,
  ...
) {
  type <- rlang::arg_match0(type, c("area", "distance"), arg_nm = "type")
  props <- drop_null(list(unit = unit, unit_options = unit_options))

  rlang::inject(add_widget(
    map,
    paste0(type, "-measurement"),
    position = position,
    expand = expand,
    !!!props,
    ...
  ))
}
