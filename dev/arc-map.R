# A map is a basemap plus one or more client side feature layers. The data
# never touches a feature service - it travels as a feature collection and the
# browser builds a FeatureLayer from it.
devtools::load_all()
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

# The simplest map there is. With no view set, it frames its own layers.
arc_map() |>
  add_layer(nc)

# A numeric column becomes a gradient, the same rule set_color() follows on a
# chart. Any ramp from esri_palettes() works by name.
arc_map("gray-vector") |>
  add_layer(nc, color = BIR74, palette = "Orange 5")

# A character or factor column gets one colour per value instead. On a map a
# uniqueValue renderer resolves natively, so the levels come out exact.
nc$region <- ifelse(st_coordinates(st_centroid(nc))[, 1] > -80, "East", "West")

arc_map("dark-gray-vector") |>
  add_layer(nc, color = region, palette = "Metro Movement", opacity = 0.8)

# Points take a size in points, lines take it as a width.
arc_map("topo-vector") |>
  add_layer(st_centroid(nc), color = SID74, size = 10)

# With no column to map, `palette` is the layer's own colour.
arc_map("satellite") |>
  add_layer(nc, palette = "grey20", opacity = 0.4, name = "Counties") |>
  add_layer(st_centroid(nc), color = BIR74, size = 8, name = "County seats")

# Set a view and the map opens there instead of framing the data.
arc_map("streets-navigation-vector") |>
  add_layer(st_centroid(nc)) |>
  set_view(center = c(-79.0, 35.5), zoom = 7)

# Every set_*() returns the map, so the basemap can be swapped downstream.
arc_map() |>
  add_layer(nc, color = AREA) |>
  set_basemap("oceans")

# Everything above builds the layer for you. When you want symbology this
# package does not expose, build the layer yourself and hand it over -
# add_layer() dispatches on what it is given.
nc |>
  as_feature_layer(name = "Counties") |>
  add_renderer(
    new_renderer(
      "simple",
      symbol = ISimpleFillSymbol(
        style = SimpleFillSymbolStyle("esriSFSSolid"),
        color = Color(r = 180, g = 40, b = 40, a = 160),
        outline = ISimpleLineSymbol(
          style = SimpleLineSymbolStyle("esriSLSSolid"),
          color = Color(r = 255, g = 255, b = 255, a = 255),
          width = 0.5
        )
      )
    )
  ) |>
  (\(layer) add_layer(arc_map("gray-vector"), layer))()

# No `type =` anywhere above: it is fixed by the class and defaults, so the
# renderer serializes with the discriminator jsonUtils.fromJSON() needs.

# Hover a feature and `tooltip` decides what it says. A bare column labels
# itself; name one and the name becomes the label.
arc_map("gray-vector") |>
  add_layer(nc, color = BIR74, tooltip = c(County = NAME, Births = BIR74))

# The labels ride as popupInfo, the web map spec's own name for a labelled
# field list, so nothing here invents a JSON shape.
arc_map() |>
  add_layer(
    st_centroid(nc),
    color = SID74,
    size = 9,
    tooltip = c(County = NAME, `Deaths, 1974` = SID74, `Births, 1974` = BIR74)
  )

# Date columns arrive in the browser as milliseconds from the epoch
# (arcgisutils::date_to_ms()); the tooltip reads the field type and formats
# them back into dates rather than printing the number.
nc$surveyed <- as.Date("2024-01-01") + seq_len(nrow(nc))

arc_map("topo-vector") |>
  add_layer(nc, color = AREA, tooltip = c(County = NAME, Surveyed = surveyed))
