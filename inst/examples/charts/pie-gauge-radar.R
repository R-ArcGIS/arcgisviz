# The three round chart types, and why they are three and not one.
#
# A pie is a bar chart bent into a circle: same `x`, same statistics, no axes.
# A radar is a line chart on a circular axis: same `x`/`y`, same grouping. A
# gauge is neither - it draws a single number, so `x` names the column that
# number is reduced from and there is no `y` at all.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- pie: one slice per category -------------------------------------------
# Counts rows, exactly as arc_bar() does.
arc_pie(penguins, species)

# --- pie: values you already have ------------------------------------------
# Give it a `y` and each slice is that value, unaggregated.
arc_pie(data.frame(part = c("a", "b", "c"), n = c(5, 3, 2)), part, n)

# --- pie: any other statistic ----------------------------------------------
# set_pie() reaches the same options the shortcut takes as arguments.
arc_chart(penguins) |>
  set_type("pie") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_pie(labels = c("category", "value"))

# --- pie: what each slice says ---------------------------------------------
# `labels` takes any of "category", "value", "percent". Naming one part turns
# the others off, so this is a choice and not an addition.
arc_pie(penguins, species, labels = "percent")
arc_pie(penguins, species, labels = c("category", "percent"))
arc_pie(penguins, species, labels = c("category", "value", "percent"))

# --- pie: a doughnut -------------------------------------------------------
# `hole` is the inner radius as a percentage of the outer one.
arc_pie(penguins, species, hole = 55, labels = c("category", "percent")) |>
  set_labs(title = "Penguins by species")

# --- pie: labels outside the slices ----------------------------------------
arc_pie(penguins, island, hole = 40, labels = "category", inside = FALSE)

# --- pie: colour and a legend ----------------------------------------------
# A pie always draws a legend - it is the only key to the slices - so
# set_legend() never has to argue with the client about whether one exists.
arc_pie(penguins, island) |>
  set_color(island, palette = "Purple 1") |>
  set_legend(position = "left", title = "Island")


# --- radar: a line chart, closed -------------------------------------------
arc_radar(penguins, species, body_mass) |>
  set_stat("mean")

# --- radar: give it a baseline ---------------------------------------------
# The radial axis auto-scales to the data, so values clustered near the
# minimum collapse onto the centre. A radar compares shapes, and a shape only
# means something measured from zero out.
arc_radar(penguins, species, body_mass) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA))

# --- radar: grouped like a line chart --------------------------------------
# set_color() on a second column splits it into one series per level. Every
# series wants a value on every spoke - group by something that covers them
# all, or the lines come out full of holes. (`island` does not: Torgersen has
# only Adelie, so its series would be a single point.)
arc_chart(penguins) |>
  set_type("radar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(sex) |>
  set_axis("y", limits = c(0, NA)) |>
  set_legend(title = "Sex")

# --- radar: axis titles are blank on purpose -------------------------------
# The client centres an axis title inside its own axis, which on a circular
# one is the middle of the plot. set_labs() still wins if you want it back.
arc_radar(penguins, island, flipper_len) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA)) |>
  set_labs(title = "Mean flipper length by island")


# --- gauge: one statistic --------------------------------------------------
# `x` is the column and `stat` reduces it. That is the whole mapping.
arc_gauge(penguins, body_mass, stat = "mean")

arc_gauge(penguins, flipper_len, stat = "max")
arc_gauge(penguins, bill_len, stat = "min")

# --- gauge: a scale you choose ---------------------------------------------
# The dial has exactly one axis, and set_axis("x") is it. Left alone, the
# needle has no context - the reading fills the dial whatever it is.
arc_gauge(penguins, flipper_len, stat = "max") |>
  set_axis("x", limits = c(0, 250)) |>
  set_labs(title = "Longest flipper")

# --- gauge: one row, verbatim ----------------------------------------------
# `feature` reads a row by position instead of aggregating, so `stat` no
# longer applies. R counts from one here, as R does everywhere.
arc_gauge(penguins, body_mass, feature = 1)
arc_gauge(penguins, body_mass, feature = 344)

# --- gauge: shape the dial -------------------------------------------------
# `angles` is the sweep in degrees, `hole` the inner radius, `needle` whether
# a needle is drawn over the fill.
arc_gauge(penguins, bill_len, stat = "mean") |>
  set_gauge(hole = 70, angles = c(-180, 0), needle = FALSE)

arc_gauge(penguins, body_mass, stat = "mean") |>
  set_gauge(angles = c(-210, 30), hole = 40) |>
  set_axis("x", limits = c(2000, 7000)) |>
  set_labs(title = "Mean body mass (g)")

# --- gauge: no colour scale ------------------------------------------------
# One reading has no marks for a scale to vary across, so this errors rather
# than building a renderer nothing would resolve.
try(arc_gauge(penguins, body_mass, stat = "mean") |> set_color(species))
