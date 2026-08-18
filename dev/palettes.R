# Finding a colour ramp. `esri_palettes()` lists every name `set_color()`
# accepts, with the tags the ArcGIS SDK ships alongside them.
devtools::load_all()


# --- everything ------------------------------------------------------------
esri_palettes()

# --- by type ---------------------------------------------------------------
# Sequential for an ordered quantity, diverging for a mid-point, categorical
# for unordered groups.
esri_palettes(type = "diverging")

# --- by background ---------------------------------------------------------
# Ramps are built for a light or a dark page, never both.
esri_palettes(type = "sequential", color_mode = "dark")

# --- by colour family ------------------------------------------------------
# `hue` keeps a ramp drawing on any of the families named.
esri_palettes(hue = c("blues", "greens"))

# --- by any other tag ------------------------------------------------------
# `tag` keeps only ramps carrying all of them. These are the ramps built for
# heat charts.
esri_palettes(tag = "heatmap")

palette_tags()

# --- the columns are plain, so subset() works too --------------------------
subset(
  esri_palettes(type = "sequential"),
  colorblind_friendly & n_stops > 5
)

# --- and then pass the name straight through -------------------------------
arc_bar(penguins, island) |>
  set_color(sex, palette = "Purple 1")

arc_heat(penguins, species, island) |>
  set_color(palette = esri_palettes(tag = "heatmap")$palette[[3]])
