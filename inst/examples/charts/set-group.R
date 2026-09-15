# Grouped bars and lines. Colouring by a column *other than* `x` splits the
# chart into one series per level, which is the only shape the ArcGIS client
# will dodge or stack. Colouring by `x` itself is a scale, and nothing splits.
#
# Splitting and stacking are two different capabilities on two different sets
# of chart types. Bar, line and box plot split; only bar and line stack. The
# end of this file shows what each refuses.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- dodged bars -----------------------------------------------------------
# One bar per species per island, side by side. This is the default for a
# split chart, the same as ggplot2's position = "dodge".
arc_bar(penguins, species) |>
  set_color(island)

# --- stacked bars ----------------------------------------------------------
arc_bar(penguins, species, position = "stack") |>
  set_color(island)

# --- filled bars -----------------------------------------------------------
# Every bar the same height, so the groups read as proportions of their
# category rather than as counts.
arc_bar(penguins, species, position = "fill") |>
  set_color(island) |>
  set_labs(title = "Where each species lives", y = "Share of penguins")

# --- the position can come later -------------------------------------------
# Same three names ggplot2 uses: dodge, stack, fill.
arc_bar(penguins, species) |>
  set_color(island) |>
  set_position("stack")

# --- groups take a palette too ---------------------------------------------
arc_bar(penguins, species) |>
  set_color(island, palette = "Purple 1")

arc_bar(penguins, species) |>
  set_color(island, palette = c("#4e79a7", "#f28e2b", "#59a14f"))

# --- grouping an aggregate -------------------------------------------------
# Mean body mass per species, split by island. Each series gets its own
# statistic, so the bars are genuinely separate means, not a subdivided one.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(island) |>
  set_legend(position = "bottom", title = "Island") |>
  set_labs(title = "Mean body mass", y = "Body mass (g)")

# --- grouped lines ---------------------------------------------------------
arc_line(penguins, flipper_len, body_mass) |>
  set_color(species)

by_year_sex <- aggregate(body_mass ~ year + sex, penguins, mean)

arc_line(by_year_sex, year, body_mass) |>
  set_color(sex) |>
  set_axis("y", limits = c(0, NA)) |>
  set_labs(title = "Mean body mass by year", y = "Body mass (g)")

# --- stacked lines ---------------------------------------------------------
# Lines stack exactly as bars do, which is what makes an area-style read.
arc_line(by_year_sex, year, body_mass, position = "stack") |>
  set_color(sex)

# --- grouped box plots -----------------------------------------------------
# Box plots split the same way bars do. They always sit side by side, so
# there is no position to set - see the errors at the end.
arc_boxplot(penguins, species, body_mass) |>
  set_color(sex) |>
  set_legend(position = "bottom", title = "Sex") |>
  set_labs(title = "Body mass by species and sex", y = "Body mass (g)")

# --- grouped radar ---------------------------------------------------------
# A radar is a line chart on a circular axis, so it splits like one.
arc_chart(penguins) |>
  set_type("radar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(sex) |>
  set_axis("y", limits = c(0, NA)) |>
  set_legend(title = "Sex")


# --- colouring by x colours, it does not group -----------------------------
# There is only one group per bar, so this is a scale and nothing splits.
# The chart stays one series, which is also why it draws no legend.
arc_bar(penguins, species) |>
  set_color(species)

# --- a continuous column is a scale, never a group -------------------------
# Same rule as ggplot2: numeric goes to a gradient.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass)


# --- the types that do not split -------------------------------------------
# Scatter, histogram and heat colour per item through a renderer instead, so
# set_color() on them is always a scale.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species)

arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3")

# --- the types that do not stack -------------------------------------------
# Histogram, heat and box plot have no stacking code in the ArcGIS client at
# all, so set_position() errors rather than silently doing nothing.
try(arc_histogram(penguins, body_mass) |> set_position("stack"))
try(arc_heat(penguins, species, island) |> set_position("fill"))
try(
  arc_boxplot(penguins, species, body_mass) |>
    set_color(sex) |>
    set_position("stack")
)
