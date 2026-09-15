# set_size() scales each marker by a numeric column, which turns a
# scatterplot into a bubble chart. It is scatter-only: `sizePolicy` is
# declared on the scatterplot series alone, so no other chart type takes it.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- a bubble chart --------------------------------------------------------
# Marker area now carries a third variable.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass)

# --- a size range ----------------------------------------------------------
# `range` is the smallest and largest marker, exactly as ggplot2's
# scale_size() takes it. Left out, the SDK's own 5 to 30 stands.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, range = c(4, 18))

arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, range = c(2, 40))

# --- a log scale -----------------------------------------------------------
# For a column whose values span orders of magnitude, where a linear scale
# would collapse everything but the largest few into a dot.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, scale = "log")

# "linear" and "log" are the two scales there are.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, scale = "log", range = c(4, 22))

# --- size and colour on the same column ------------------------------------
# Redundant encoding: the same variable read twice, which makes the gradient
# far easier to rank by eye.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass) |>
  set_color(body_mass, palette = "Blue 3")

# --- size and colour on different columns ----------------------------------
# Four variables on one chart, and the coloured-by column shows on hover.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_size(body_mass, range = c(4, 18)) |>
  set_color(species) |>
  set_legend(visible = FALSE) |>
  set_labs(
    title = "Bill shape, mass, and species",
    x = "Bill length (mm)",
    y = "Bill depth (mm)"
  )

# --- with the rest of the pipeline -----------------------------------------
library(arcgisviz)

arc_scatter(penguins, flipper_len, body_mass) |>
  set_size(bill_len, range = c(3, 20)) |>
  set_color(species, alpha = 0.7) |>
  set_axis("x", limits = c(160, 240)) |>
  set_axis("y", limits = c(2000, 7000)) |>
  set_tooltip(Island = island, `Bill length (mm)` = bill_len) |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Flipper length against body mass, sized by bill length",
    x = "Flipper length (mm)",
    y = "Body mass (g)"
  )

# --- every other type refuses ----------------------------------------------
# Only a scatterplot draws one marker per row, so only a scatterplot has
# something to size.
try(arc_bar(penguins, species) |> set_size(body_mass))
try(arc_line(penguins, flipper_len, body_mass) |> set_size(bill_len))
try(arc_histogram(penguins, body_mass) |> set_size(bill_len))

# --- range is two increasing numbers ---------------------------------------
try(
  arc_scatter(penguins, bill_len, bill_dep) |> set_size(body_mass, range = 10)
)
