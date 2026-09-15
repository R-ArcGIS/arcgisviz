# The three chart types you reach for first, and the four verbs that build
# any of them: set_type(), set_x(), set_y(), set_stat(). Every arc_*()
# shortcut in this package is those four with a type already chosen.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- bar: count the rows in each category ----------------------------------
# There is no y to give. The height is how many rows fall into each x.
arc_bar(penguins, species)
arc_bar(penguins, island)

# --- col: plot y as it already is ------------------------------------------
# One bar per row, no aggregation - ggplot2's geom_col() to arc_bar()'s
# geom_bar().
by_species <- aggregate(body_mass ~ species, penguins, mean)
arc_col(by_species, species, body_mass)

# --- bar + stat: aggregate y within each x ---------------------------------
# The long form. `stat` is the same vocabulary ggplot2 uses.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean")

# --- the other statistics --------------------------------------------------
# count, sum, mean, min, max, sd, var - plus "identity", which is what
# arc_col() sets for you.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(flipper_len) |>
  set_stat("max")

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(flipper_len) |>
  set_stat("sd")

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(body_mass) |>
  set_stat("sum")

# --- bare column names, not strings ----------------------------------------
# Mappings are tidy-eval, so a column is written the way you would write it
# in dplyr. !! injects one held in a variable.
col <- rlang::sym("body_mass")

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(!!col) |>
  set_stat("mean")


# --- scatter: a marker per row ---------------------------------------------
arc_scatter(penguins, bill_len, bill_dep)

# A scatterplot never aggregates, so set_stat() has nothing to do here. Use
# set_color() and set_size() to carry a third and fourth variable.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species) |>
  set_size(body_mass)


# --- line ------------------------------------------------------------------
by_year <- aggregate(body_mass ~ year, penguins, mean)
arc_line(by_year, year, body_mass)

# A line aggregates exactly as a bar does, and is usually what you want:
# three rows per year is not a trend.
arc_chart(penguins) |>
  set_type("line") |>
  set_x(year) |>
  set_y(flipper_len) |>
  set_stat("mean") |>
  set_labs(title = "Mean flipper length by year", y = "Flipper length (mm)")


# --- the pipeline composes in any order ------------------------------------
# Each set_*() returns the chart, so this is one object being filled in, not
# a sequence of drawing commands.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(island) |>
  set_position("dodge") |>
  set_axis("y", limits = c(0, NA)) |>
  set_legend(position = "bottom", title = "Island") |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species and island",
    caption = "Horst, Hill and Gorman (2020)",
    x = "Species",
    y = "Body mass (g)"
  )


# --- looking at what actually travels --------------------------------------
# The chart is an S7 object; @webchart is computed from the mapping on
# demand, which is why set_stat() after set_y() still rewrites the query.
chart <- arc_bar(penguins, species)

str(s7x::as_vector(chart@webchart), max.level = 2)

# as_widget() is the htmlwidget, and $x is the payload the browser gets.
widget <- as_widget(chart)
names(widget$x)

# Any S7 config class in the package serializes on its own. Unset properties
# are dropped rather than sent as null, which is what lets a sparse config
# fall back to the browser's own defaults.
cat(s7x::to_json(chart@webchart, pretty = TRUE))
