# The Maps SDK ships its map furniture as web components - a legend, a layer
# list, a search box, a basemap gallery. There is one function per widget, and
# each is a slotted child of the map, which is all the wiring they need: a
# component inside <arcgis-map> finds the map itself.
devtools::load_all()
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

# A legend reads the layer's own renderer, so a coloured map explains itself.
arc_map() |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Births, 1974") |>
  add_legend() |>
  add_layer_list()

# Every widget takes `position`, one of the map element's own slots. Two in
# one corner stack in the order they were added.
arc_map() |>
  add_layer(nc, color = SID74, palette = "Red 5", name = "Deaths, 1974") |>
  add_legend(position = "top-left") |>
  add_scale_bar(position = "bottom-right") |>
  add_zoom(position = "bottom-left", layout = "horizontal")

# Each function documents the properties that widget actually takes, written
# in snake_case. A name it does not take names the ones it does.
arc_map() |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_layer_list(show_filter = TRUE, filter_placeholder = "Find a layer") |>
  add_scale_bar(unit = "dual", bar_style = "ruler")

# A panel widget covers the map it explains. `expand` collapses it behind a
# button instead, and two collapsed widgets in one corner close each other,
# so the map is never hidden by both at once.
arc_map() |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Births, 1974") |>
  add_legend(position = "top-right", expand = TRUE) |>
  add_basemap_gallery(position = "top-right", expand = TRUE) |>
  add_layer_list(position = "top-right", expand = TRUE)

# A gallery and a search box turn a static map into one the reader navigates.
# Search needs no configuration for place names.
arc_map("gray-vector") |>
  add_layer(nc, palette = "grey30", name = "Counties") |>
  add_basemap_gallery(expand = TRUE) |>
  add_search() |>
  add_home()

# The tools report back to Shiny - what was drawn, what was edited, what was
# measured. See dev/map-tools.R for the whole round trip.
arc_map() |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_sketch(tools = c("polygon", "rectangle")) |>
  add_measurement("area", unit = "square-kilometers") |>
  add_measurement("distance")

# add_widget() is what all of those call, and it reaches any component in the
# registry - including ones without a shortcut of their own.
map_widgets()

arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_widget("track", position = "top-left")

# Adding the same widget twice replaces it, so a pipeline can override an
# earlier choice - and re-running one through a proxy is idempotent.
arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_legend(position = "top-left") |>
  add_legend(position = "bottom-right")

# On a rendered map the same calls go through the proxy, and remove_widget()
# takes one back off:
#
#   arc_map_proxy("map") |>
#     add_legend(expand = TRUE) |>
#     arc_update()
#
#   arc_map_proxy("map") |>
#     remove_widget("legend")
