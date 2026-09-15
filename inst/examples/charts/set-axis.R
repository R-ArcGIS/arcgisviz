# set_axis() shapes one scale, set_flipped() swaps which one is horizontal.
# Both take only what you name - anything left out keeps whatever the chart
# would have drawn anyway.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- limits ----------------------------------------------------------------
# c(min, max), the same shape as ggplot2's xlim()/ylim().
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", limits = c(30, 60)) |>
  set_axis("y", limits = c(12, 22))

# --- one open bound --------------------------------------------------------
# NA leaves that end for the chart to work out from the data. This is the
# common case: a bar chart that does not start at zero misleads.
by_species <- aggregate(body_mass ~ species, penguins, mean)

arc_col(by_species, species, body_mass) |>
  set_axis("y", limits = c(0, NA))

# --- a logarithmic axis ----------------------------------------------------
arc_scatter(penguins, bill_len, body_mass) |>
  set_axis("y", log = TRUE)

# --- whole numbers only ----------------------------------------------------
# A count axis labelled 2.5 penguins is wrong. `zero_line` draws the baseline
# so the reader can see where the bars start.
arc_bar(penguins, island) |>
  set_axis("y", integer_only = TRUE, zero_line = TRUE)

# --- tick spacing ----------------------------------------------------------
# Minimum pixels between ticks, so a larger number means fewer labels.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", tick_spacing = 120)

arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", tick_spacing = 40)

# --- buffer ----------------------------------------------------------------
# A flag, not a number: whether the chart pads the ends of the scale so that
# markers do not sit on the frame.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", buffer = TRUE) |>
  set_axis("y", buffer = TRUE)

# --- hide an axis ----------------------------------------------------------
# Worth doing when the labels on the marks already say it.
arc_bar(penguins, species) |>
  set_axis("y", visible = FALSE)

# --- repeated calls layer --------------------------------------------------
# Each call adds to the same axis rather than replacing what is on it.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("y", limits = c(12, 22)) |>
  set_axis("y", zero_line = TRUE) |>
  set_axis("y", tick_spacing = 60)


# --- horizontal bars -------------------------------------------------------
# set_flipped() rotates the chart, which is what long category names need.
arc_bar(penguins, species) |>
  set_flipped()

# --- and back again --------------------------------------------------------
# It takes a value, so it can be driven by an input rather than by its
# presence in the pipeline.
arc_bar(penguins, species) |> set_flipped(TRUE)
arc_bar(penguins, species) |> set_flipped(FALSE)

# --- limits still name the data axis, not the screen axis ------------------
# "y" is the measured variable whether or not the chart is flipped.
arc_col(by_species, species, body_mass) |>
  set_axis("y", limits = c(0, 5000)) |>
  set_flipped()


# --- a gauge has exactly one axis ------------------------------------------
# The dial's scale is "x", because a gauge's value rides x. There is no "y"
# to set.
arc_gauge(penguins, flipper_len, stat = "max") |>
  set_axis("x", limits = c(0, 250))

# --- a radar's radial axis is "y" ------------------------------------------
arc_radar(penguins, species, body_mass) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA))


# --- composed with everything else -----------------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, palette = "Blue 3") |>
  set_axis("y", limits = c(0, 5000), integer_only = TRUE, zero_line = TRUE) |>
  set_flipped() |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    x = "Species",
    y = "Mean body mass (g)"
  )

# --- limits must be two numbers --------------------------------------------
# Both ends can be NA, but the shape is always c(min, max).
try(arc_bar(penguins, species) |> set_axis("y", limits = 5000))
try(arc_bar(penguins, species) |> set_axis("z", limits = c(0, 1)))
