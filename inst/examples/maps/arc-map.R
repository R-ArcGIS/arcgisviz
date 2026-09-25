# A map is a basemap plus one or more client side feature layers. The data
# never touches a feature service - an sf object travels as a feature
# collection and the browser builds a FeatureLayer out of it.
#
# arc_map() is the second widget in this package. It shares set_color()'s
# palettes and renderer code with the charts and almost nothing else.
#
# Run one map at a time - each prints into the Viewer.
library(arcgisviz)
library(sf)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
nc$region <- ifelse(st_coordinates(st_centroid(nc))[, 1] > -80, "East", "West")


# --- the simplest map there is ---------------------------------------------
# With no view set, it frames its own layers.
arc_map() |>
  add_layer(nc)

# --- basemaps --------------------------------------------------------------
# The id goes to arc_map(), or to set_basemap() further down the pipeline.
# Basemaps lists every one <arcgis-map> accepts.
Basemaps

arc_map("gray-vector") |> add_layer(nc)
arc_map("dark-gray-vector") |> add_layer(nc)
arc_map("satellite") |> add_layer(nc)

arc_map() |>
  add_layer(nc, color = AREA) |>
  set_basemap("oceans")


# --- a numeric column becomes a gradient -----------------------------------
# The same rule set_color() follows on a chart. Any ramp from
# esri_palettes() works by name.
arc_map("gray-vector") |>
  add_layer(nc, color = BIR74, palette = "Orange 5")

arc_map("gray-vector") |>
  add_layer(nc, color = SID74, palette = c("white", "#b82828"))

# --- a character or factor column gets one colour per value ----------------
# On a map a uniqueValue renderer resolves natively against the layer, so the
# levels come out exact - none of the code-column workaround a chart needs.
arc_map("dark-gray-vector") |>
  add_layer(nc, color = region, palette = "Metro Movement", opacity = 0.8)

# --- with no column to map, `palette` is the layer's own colour ------------
# A map layer has one symbol either way, so a fixed colour needs no mapping.
arc_map("satellite") |>
  add_layer(nc, palette = "grey20", opacity = 0.4, name = "Counties")


# --- points take a size in points, lines take it as a width ----------------
arc_map("topo-vector") |>
  add_layer(st_centroid(nc), color = SID74, size = 10)

# --- several layers --------------------------------------------------------
# They draw in the order added, so the polygons go down first.
arc_map("satellite") |>
  add_layer(nc, palette = "grey20", opacity = 0.4, name = "Counties") |>
  add_layer(st_centroid(nc), color = BIR74, size = 8, name = "County seats")


# --- set a view and the map opens there ------------------------------------
# center is c(longitude, latitude). Without one, the map frames the data.
arc_map("streets-navigation-vector") |>
  add_layer(st_centroid(nc)) |>
  set_view(center = c(-79.0, 35.5), zoom = 7)

# --- or give it an extent --------------------------------------------------
# An Esri extent, which is what <arcgis-map> autocasts. st_bbox() already
# uses these four names, so it only needs a spatial reference adding.
bbox <- st_bbox(nc)

arc_map() |>
  add_layer(nc) |>
  set_view(
    extent = c(as.list(bbox), list(spatialReference = list(wkid = 4326)))
  )


# --- hover tooltips --------------------------------------------------------
# A bare column labels itself; name one and the name becomes the label. The
# labels ride as popupInfo, the web map spec's own labelled field list.
arc_map("gray-vector") |>
  add_layer(nc, color = BIR74, tooltip = c(County = NAME, Births = BIR74))

arc_map() |>
  add_layer(
    st_centroid(nc),
    color = SID74,
    size = 9,
    tooltip = c(County = NAME, `Deaths, 1974` = SID74, `Births, 1974` = BIR74)
  )

# --- dates in a tooltip ----------------------------------------------------
# Date columns arrive in the browser as milliseconds from the epoch. The
# tooltip reads the field's type and formats them back into dates rather
# than printing a thirteen-digit number.
nc$surveyed <- as.Date("2024-01-01") + seq_len(nrow(nc))

arc_map("topo-vector") |>
  add_layer(nc, color = AREA, tooltip = c(County = NAME, Surveyed = surveyed))


# --- symbology this package does not expose --------------------------------
# Everything above builds the layer for you. When you want something else,
# build the layer yourself and hand it over - add_layer() dispatches on what
# it is given.
counties <- nc |>
  as_feature_layer(name = "Counties") |>
  add_renderer(
    new_renderer(
      "simple",
      symbol = new_symbol(
        "fill",
        color = "#b82828a0",
        outline = new_symbol("line", color = "white", width = 0.5)
      )
    )
  )

arc_map("topo-vector") |> add_layer(counties)

# --- the constructors are friendly all the way down ------------------------
# No S7 class name, no esri-prefixed enum, no `type =` at a call site.
# Colours are written the way they are everywhere else in this package, and
# `style` defaults per family - "solid" for a fill, "circle" for a marker.
new_symbol("marker", color = "steelblue", size = 8)
new_symbol("fill", style = "backward-diagonal", color = "grey40")
new_symbol("line", color = "#333333", width = 2, style = "dash")

# --- a unique value renderer, written out ----------------------------------
# `field1` is the spec's own name, and a class_list property still takes S7
# objects by hand - the one place the new_*() family does not yet reach.
regions <- nc |>
  as_feature_layer(name = "Regions") |>
  add_renderer(
    new_renderer(
      "unique-value",
      field1 = "region",
      uniqueValueInfos = list(
        IUniqueValueInfo(
          value = "East",
          symbol = new_symbol("fill", color = "#4e79a7")
        ),
        IUniqueValueInfo(
          value = "West",
          symbol = new_symbol("fill", color = "#f28e2b")
        )
      )
    )
  )

arc_map("gray-vector") |> add_layer(regions)


# --- what a map is, as an object -------------------------------------------
# Every set_*() and add_*() returns the map, so it is one object being filled
# in - the same design the charts have.
m <- arc_map("topo-vector") |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Counties")

m
class(m)
names(as_widget(m)$x)
