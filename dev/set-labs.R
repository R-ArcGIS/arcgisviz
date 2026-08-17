# set_labs() gallery. Not run by testthat - render one chart at a time in the
# Viewer. Omit a label to leave it as it is, pass a string to set it, pass
# NULL to remove it.
devtools::load_all()

penguins <- datasets::penguins

# --- every label at once --------------------------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    caption = "Data: Horst, Hill and Gorman (2020)",
    x = "Species",
    y = "Mean body mass (g)"
  )

# --- omitted labels keep their defaults -----------------------------------
# Axis titles default to the mapped columns, so this renames only the y axis
# and leaves the chart untitled.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_labs(y = "Bill depth (mm)")

# --- NULL removes a label -------------------------------------------------
# Blanks both axis titles; the tooltip falls back to the field names.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_labs(title = "Bill dimensions", x = NULL, y = NULL)

# --- calls accumulate -----------------------------------------------------
arc_bar(penguins, island) |>
  set_labs(x = "Island") |>
  set_labs(y = "Penguins counted", title = "Penguins per island")

# --- a title is absent unless set -----------------------------------------
# Without set_labs() the client would title this "Chart"; we send an explicit
# null to delete that default.
arc_bar(penguins, species)
