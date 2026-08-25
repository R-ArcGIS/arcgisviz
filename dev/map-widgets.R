# The Maps SDK ships its map furniture as web components - a legend, a layer
# list, a search box, a basemap gallery. add_widget() slots one into the map,
# which is all the wiring they need: a component inside <arcgis-map> finds the
# map itself.
devtools::load_all()
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

# Every widget add_widget() takes, the corner it defaults to, and the
# properties it accepts. `properties` is a list column.
map_widgets()

# A legend goes bottom-left, a layer list top-right, and neither is told
# anything about the map.
arc_map() |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Births, 1974") |>
  add_widget("legend") |>
  add_widget("layer-list")

# Positions are the map element's own slots. Two widgets in one corner stack
# in the order they were added.
arc_map() |>
  add_layer(nc, color = SID74, palette = "Reds", name = "Deaths, 1974") |>
  add_widget("legend", position = "top-left") |>
  add_widget("scale-bar", position = "bottom-right") |>
  add_widget("zoom", position = "bottom-left")

# Component properties are written in snake_case and sent as the camelCase
# the component declares. A wrong one names the ones that exist.
arc_map() |>
  add_layer(nc, color = BIR74, name = "Counties") |>
  add_widget("layer-list", show_filter = TRUE, filter_placeholder = "Find") |>
  add_widget("scale-bar", unit = "dual", bar_style = "ruler")

# A basemap gallery and a search box turn a static map into one the reader
# can navigate. Search needs no configuration for place names.
arc_map("gray-vector") |>
  add_layer(nc, palette = "grey30", name = "Counties") |>
  add_widget("basemap-gallery") |>
  add_widget("search") |>
  add_widget("home")

# Adding the same widget twice replaces it, so a pipeline can override an
# earlier choice - and so re-running one through a proxy is idempotent.
arc_map() |>
  add_layer(nc, name = "Counties") |>
  add_widget("legend", position = "top-left") |>
  add_widget("legend", position = "bottom-right")

# On a rendered map the same call goes through the proxy, and
# remove_widget() takes one back off:
#
#   arc_map_proxy("map") |>
#     add_widget("legend") |>
#     arc_update()
#
#   arc_map_proxy("map") |>
#     remove_widget("legend")
