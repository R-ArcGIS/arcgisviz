# The three round chart types. Render one at a time in the Viewer.
#
# A pie is a bar chart bent into a circle: same `x`, same stats. A radar is a
# line chart on a circular axis: same `x`/`y`, same grouping. A gauge is
# neither - it draws a single number, so `x` names the column that number
# comes from.
devtools::load_all()


# --- pie: one slice per category ------------------------------------------
# Counts rows, exactly as arc_bar() does.
arc_pie(penguins, species)

# --- pie: values you already have -----------------------------------------
# Give it a `y` and each slice is that value, unaggregated.
arc_pie(data.frame(part = c("a", "b", "c"), n = c(5, 3, 2)), part, n)

# --- pie: any other statistic ---------------------------------------------
# set_pie() reaches the same options the shortcut takes as arguments.
arc_chart(penguins) |>
  set_type("pie") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_pie(labels = c("category", "value"))

# --- pie: a doughnut, labelled ---------------------------------------------
# `labels` picks what each slice says. Naming one part turns the others off.
arc_pie(penguins, species, hole = 55, labels = c("category", "percent")) |>
  set_labs(title = "Penguins by species")

# --- pie: colour and a legend ---------------------------------------------
# A pie always draws a legend - it is the only key to the slices.
arc_pie(penguins, island) |>
  set_color(island, palette = "Purple 1") |>
  set_legend(position = "left", title = "Island")


# --- radar: a line chart, closed ------------------------------------------
arc_radar(penguins, species, body_mass) |>
  set_stat("mean")

# --- radar: give it a baseline --------------------------------------------
# The radial axis auto-scales to the data, so values clustered near the
# minimum collapse onto the centre. A radar compares shapes, and a shape only
# means something from zero out.
arc_radar(penguins, species, body_mass) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA))

# --- radar: grouped like a line chart -------------------------------------
# set_color() on a second column splits it into one series per level. Every
# series wants a value on every spoke - group by something that covers them
# all, or the lines come out full of holes. (`island` does not: Torgersen has
# only Adelie, so its series is a single point.)
arc_chart(penguins) |>
  set_type("radar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(sex) |>
  set_axis("y", limits = c(0, NA)) |>
  set_legend(title = "Sex")


# --- gauge: one statistic -------------------------------------------------
# `x` is the column, `stat` reduces it. This is the whole mapping.
arc_gauge(penguins, body_mass, stat = "mean")

# --- gauge: a scale you choose --------------------------------------------
# The dial has one axis, and set_axis("x") is it.
arc_gauge(penguins, flipper_len, stat = "max") |>
  set_axis("x", limits = c(0, 250)) |>
  set_labs(title = "Longest flipper")

# --- gauge: one row, verbatim ---------------------------------------------
# `feature` reads a row by position instead of aggregating.
arc_gauge(penguins, body_mass, feature = 1)

# --- gauge: shape the dial ------------------------------------------------
arc_gauge(penguins, bill_len, stat = "mean") |>
  set_gauge(hole = 70, angles = c(-180, 0), needle = FALSE)
