# Grouped bars and lines. Colouring by a column other than `x` splits the
# chart into one series per level, which is the only shape the ArcGIS client
# will dodge or stack. Render one chart at a time in the Viewer.
devtools::load_all()


# --- dodged bars ----------------------------------------------------------
# One bar per species per island, side by side. This is the default.
arc_bar(penguins, species) |>
  set_color(island)

# --- stacked bars ---------------------------------------------------------
arc_bar(penguins, species, position = "stack") |>
  set_color(island)

# --- filled bars ----------------------------------------------------------
# Every bar the same height, so the groups read as proportions.
arc_bar(penguins, species, position = "fill") |>
  set_color(island) |>
  set_labs(title = "Where each species lives", y = "Share of penguins")

# --- the position can come later ------------------------------------------
arc_bar(penguins, species) |>
  set_color(island) |>
  set_position("stack")

# --- groups take a palette too --------------------------------------------
arc_bar(penguins, species) |>
  set_color(island, palette = "Purple 1")

# --- grouping an aggregate ------------------------------------------------
# Mean body mass per species, split by island.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(island) |>
  set_labs(title = "Mean body mass", y = "Body mass (g)")

# --- grouped lines --------------------------------------------------------
arc_line(penguins, flipper_len, body_mass) |>
  set_color(species)

# --- colouring by x still colours, it does not group ----------------------
# There is only one group per bar, so this is a scale and nothing splits.
arc_bar(penguins, species) |>
  set_color(species)

# --- a continuous column is a scale, never a group ------------------------
# Same rule as ggplot2: numeric goes to a gradient.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass)
