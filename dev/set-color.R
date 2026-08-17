# set_color() gallery. Render one chart at a time in the Viewer. A numeric
# column becomes a continuous gradient; a factor or character column gets one
# colour per distinct value.
devtools::load_all()


# --- continuous: a numeric column -----------------------------------------
# Defaults to "Blue 3", the ramp the ArcGIS SDK itself uses for gradients.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Candy Shop")

# --- continuous: a named Esri ramp ----------------------------------------
# Any of the 521 smart-mapping ramp names works.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Candy Shop")

# --- continuous: your own colours -----------------------------------------
# A vector of R colours becomes the ramp; the client interpolates between them.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = c("white", "#4682B4", "navy"))

# --- discrete: a factor column --------------------------------------------
# Defaults to the SDK's own series palette, cycled.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species, palette = "Candy Shop")

# --- discrete: colours pulled from a ramp ---------------------------------
arc_bar(penguins, island) |>
  set_color(island, palette = "Purple 1")

# --- colour composes with everything else ---------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, palette = "Watercolor Surprise") |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    x = "Species",
    y = "Mean body mass (g)"
  )
