# Scratch gallery for eyeballing charts in the Viewer. Not run by testthat.
devtools::load_all()

penguins <- datasets::penguins

# --- bar: count rows per category (geom_bar) ------------------------------
arc_bar(penguins, species)
arc_bar(penguins, island)

# --- col: plot y as-is, one bar per row (geom_col) -------------------------
by_species <- aggregate(body_mass ~ species, penguins, mean)
arc_col(by_species, species, body_mass)

# --- bar + stat: aggregate y grouped by x ---------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean")

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(flipper_len) |>
  set_stat("max")

# --- scatter --------------------------------------------------------------
arc_scatter(penguins, bill_len, bill_dep)

# --- line -----------------------------------------------------------------
by_year <- aggregate(body_mass ~ year, penguins, mean)
arc_line(by_year, year, body_mass)

arc_chart(penguins) |>
  set_type("line") |>
  set_x(year) |>
  set_y(flipper_len) |>
  set_stat("mean")

# --- payload inspection ---------------------------------------------------
str(s7x::as_vector(arc_bar(penguins, species)@webchart), max.level = 3)
cat(widget_json(as_widget(arc_bar(penguins, species))$x$config))
