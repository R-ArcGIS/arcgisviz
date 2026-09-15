# The Maps SDK ships its map furniture as web components - a legend, a layer
# list, a search box, a basemap gallery. There is one add_*() function per
# widget, and each is a slotted child of the map, which is all the wiring they
# need: a component inside <arcgis-map> finds the map itself.
#
# Run one map at a time - each prints into the Viewer.
library(arcgisviz)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)


# --- a legend reads the layer's own renderer -------------------------------
# So a coloured map explains itself with no configuration at all.
arc_map() |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Births, 1974") |>
  add_legend() |>
  add_layer_list()

# --- every widget takes `position` -----------------------------------------
# These are the map element's own slot names, not an invented vocabulary.
# Two widgets in one corner stack in the order they were added.
arc_map() |>
  add_layer(nc, color = SID74, palette = "Red 5", name = "Deaths, 1974") |>
  add_legend(position = "top-left") |>
  add_scale_bar(position = "bottom-right") |>
  add_zoom(position = "bottom-left", layout = "horizontal")

# --- each function documents the properties that widget takes --------------
# Arguments are the snake_case of the component's own property names, so
# there is one vocabulary and no second mapping table to learn.
arc_map() |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_layer_list(show_filter = TRUE, filter_placeholder = "Find a layer") |>
  add_scale_bar(unit = "dual", bar_style = "ruler")

# --- and a name it does not take names the ones it does --------------------
try(arc_map() |> add_legend(nope = TRUE))


# --- navigation ------------------------------------------------------------
arc_map("streets-navigation-vector") |>
  add_layer(nc, palette = "grey30", opacity = 0.5, name = "Counties") |>
  add_zoom() |>
  add_home() |>
  add_compass() |>
  add_fullscreen()

# --- where the reader is ---------------------------------------------------
arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_locate(position = "top-left") |>
  add_track(position = "top-left")

# --- searching -------------------------------------------------------------
# Search needs no configuration for place names.
arc_map("gray-vector") |>
  add_layer(nc, palette = "grey30", name = "Counties") |>
  add_search() |>
  add_basemap_gallery(expand = TRUE) |>
  add_home()

arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_search(all_placeholder = "Find a place", max_results = 5)

# --- swapping the basemap --------------------------------------------------
arc_map("topo-vector") |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_basemap_toggle(position = "bottom-right")

# --- reading coordinates off the map ---------------------------------------
arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_coordinate_conversion(position = "bottom-left")


# --- `expand` keeps a panel widget out of the way --------------------------
# A panel widget covers the map it explains. `expand` collapses it behind a
# button instead, and two collapsed widgets in one corner close each other,
# so the map is never hidden by both at once.
arc_map() |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Births, 1974") |>
  add_legend(position = "top-right", expand = TRUE) |>
  add_basemap_gallery(position = "top-right", expand = TRUE) |>
  add_layer_list(position = "top-right", expand = TRUE)


# --- the tools report back to Shiny ----------------------------------------
# Drawn, edited and measured results all arrive as fields on the map's own
# Shiny input. See inst/examples/shiny/map-tools for the whole round trip.
arc_map() |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_sketch(tools = c("polygon", "rectangle")) |>
  add_measurement("area", unit = "square-kilometers") |>
  add_measurement("distance") |>
  add_editor(position = "bottom-right")


# --- add_widget() is what all of those call --------------------------------
# It reaches any component in the registry, including ones with no shortcut
# of their own.
map_widgets()

arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_widget("track", position = "top-left")

# --- adding the same widget twice replaces it ------------------------------
# Widgets are keyed by component, so a pipeline can override an earlier
# choice - and re-running one through a proxy is idempotent.
arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_legend(position = "top-left") |>
  add_legend(position = "bottom-right")

# --- on a rendered map the same calls go through the proxy -----------------
# add_widget() and every add_*() shortcut work on an arc_map_proxy(), because
# ArcMapProxy subclasses ArcMap. remove_widget() takes one back off.
#
#   arc_map_proxy("map") |>
#     add_legend(expand = TRUE) |>
#     arc_update()
#
#   arc_map_proxy("map") |>
#     remove_widget("legend")
