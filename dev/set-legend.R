# set_legend() gallery. Render one chart at a time in the Viewer. A legend
# needs entries, so a chart only has one once set_color() has grouped it -
# heat charts excepted, where the legend *is* the colour gradient.
devtools::load_all()

mass_by_species <- function() {
  arc_chart(penguins) |>
    set_type("bar") |>
    set_x(species) |>
    set_y(body_mass) |>
    set_stat("mean")
}


# --- one series, no legend ------------------------------------------------
# Nothing to key, so nothing is drawn. Compare with the next one.
mass_by_species()

# --- grouping makes one ---------------------------------------------------
# Each group is a series, and a series names itself in the legend.
mass_by_species() |>
  set_color(island)

# --- move it and title it -------------------------------------------------
mass_by_species() |>
  set_color(island) |>
  set_legend(position = "bottom", title = "Island")

# --- repeated calls layer -------------------------------------------------
# Same rule as set_labs(): an omitted argument leaves what is already set.
mass_by_species() |>
  set_color(island) |>
  set_legend(title = "Island") |>
  set_legend(position = "top")

# --- take it away ---------------------------------------------------------
mass_by_species() |>
  set_color(island) |>
  set_legend(visible = FALSE)

# --- asking for one that cannot exist is an error -------------------------
# The client draws a legend only where the chart has entries for it, so
# `visible = TRUE` on a single series would be read and then ignored.
try(mass_by_species() |> set_legend(visible = TRUE))

# --- a heat chart's legend is its colour ramp -----------------------------
# It shades cells by count rather than by a column, so the legend is the
# gradient itself and is drawn without any grouping.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3") |>
  set_legend(position = "right", title = "Penguins")
