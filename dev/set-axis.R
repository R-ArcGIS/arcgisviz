# set_axis() and set_flipped() gallery. Render one chart at a time in the
# Viewer. Anything you leave out keeps whatever the chart would draw anyway.
devtools::load_all()

# --- limits ----------------------------------------------------------------
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", limits = c(30, 60)) |>
  set_axis("y", limits = c(12, 22))

# --- one open bound --------------------------------------------------------
# NA leaves that end for the chart to work out from the data.
arc_col(aggregate(body_mass ~ species, penguins, mean), species, body_mass) |>
  set_axis("y", limits = c(0, NA))

# --- a logarithmic axis ----------------------------------------------------
arc_scatter(penguins, bill_len, body_mass) |>
  set_axis("y", log = TRUE)

# --- whole numbers only, with a line at zero -------------------------------
arc_bar(penguins, island) |>
  set_axis("y", integer_only = TRUE, zero_line = TRUE)

# --- widen the gap between ticks -------------------------------------------
arc_scatter(penguins, bill_len, bill_dep) |>
  set_axis("x", tick_spacing = 120)

# --- hide an axis ----------------------------------------------------------
arc_bar(penguins, species) |>
  set_axis("y", visible = FALSE)

# --- horizontal bars -------------------------------------------------------
arc_bar(penguins, species) |>
  set_flipped()

# --- composed with everything else -----------------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, palette = "Blue 3") |>
  set_axis("y", limits = c(0, 5000), integer_only = TRUE) |>
  set_flipped() |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    x = "Species",
    y = "Mean body mass (g)"
  )
