# Finding a colour ramp. esri_palettes() lists every name set_color() and
# add_layer(palette = ) accept, with the tags the ArcGIS SDK ships alongside
# them. 521 ramps, one row each.
library(arcgisviz)

penguins <- datasets::penguins


# --- everything ------------------------------------------------------------
esri_palettes()

nrow(esri_palettes())
names(esri_palettes())

# --- by type ---------------------------------------------------------------
# Sequential for an ordered quantity, diverging for a mid-point, categorical
# for unordered groups.
esri_palettes(type = "sequential")
esri_palettes(type = "diverging")
esri_palettes(type = "categorical")

# --- by background ---------------------------------------------------------
# A ramp is built for a light page or a dark one, never both. Every one of
# the 521 carries exactly one of these tags, which is why it is a plain
# column rather than a list.
esri_palettes(type = "sequential", color_mode = "dark")
esri_palettes(type = "sequential", color_mode = "light")

# --- by colour family ------------------------------------------------------
# `hue` keeps a ramp drawing on any of the families named.
esri_palettes(hue = "blues")
esri_palettes(hue = c("blues", "greens"))

# --- by any other tag ------------------------------------------------------
# `tag` keeps only the ramps carrying all of them. These are the ones built
# for heat charts.
esri_palettes(tag = "heatmap")
esri_palettes(tag = c("heatmap", "dark"))

# --- the whole tag vocabulary ----------------------------------------------
# 118 ramps carry no type tag at all - the centered-on, extremes, and
# heatmap families - so `type` will not find them. `tag` will.
palette_tags()

# --- filters combine -------------------------------------------------------
esri_palettes(type = "diverging", color_mode = "light", hue = "reds")

# --- the columns are plain, so base R subsetting works ---------------------
subset(
  esri_palettes(type = "sequential"),
  colorblind_friendly & n_stops > 5
)

subset(esri_palettes(), grepl("^Blue", palette))

# --- and then pass the name straight through -------------------------------
arc_bar(penguins, island) |>
  set_color(sex, palette = "Purple 1")

arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Prairie Summer")

# --- or pick one out of the frame ------------------------------------------
heat_ramps <- esri_palettes(tag = "heatmap")$palette

arc_heat(penguins, species, island) |>
  set_color(palette = heat_ramps[[3]])

# --- the same names work on a map ------------------------------------------
# One catalogue for both widgets.
if (requireNamespace("sf", quietly = TRUE)) {
  nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

  arc_map("gray-vector") |>
    add_layer(nc, color = BIR74, palette = "Orange 5")
}

# --- a palette does not have to come from the catalogue --------------------
# Any vector of R colours is parsed by grDevices::col2rgb(), so names, hex,
# and hex-with-alpha all work.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species, palette = c("steelblue", "#e15759", "grey40"))
