# set_size() scales each marker by a numeric column, which turns a
# scatterplot into a bubble chart. Render one at a time in the Viewer.
devtools::load_all()


# --- a bubble chart --------------------------------------------------------
# Marker area now carries a third variable.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass) |>
  set_color(body_mass)

# --- a tighter size range --------------------------------------------------
# `range` is the smallest and largest marker, as ggplot2's scale_size() is.
# Left out, the SDK's own 5 to 30 stands.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, range = c(4, 18))

# --- a log scale -----------------------------------------------------------
# For a column whose values span orders of magnitude.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, scale = "log")

# --- size and colour together ----------------------------------------------
# Four variables on one chart, and the coloured-by column shows on hover.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, range = c(4, 18)) |>
  set_color(species) |>
  set_labs(
    title = "Bill shape, mass, and species",
    x = "Bill length (mm)",
    y = "Bill depth (mm)"
  )
