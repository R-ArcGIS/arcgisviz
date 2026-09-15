# set_tooltip() names extra columns to show when a mark is hovered, alongside
# x and y. Name an argument and the name becomes the label; pass a bare column
# and it labels itself.
#
# Every mark covers a group of rows - a bar covers every row with that x, a
# heat cell every row in that pair of categories - so an extra field is only
# sendable when it takes one value across that group. set_tooltip() checks
# that and errors rather than picking one arbitrarily.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- one extra field -------------------------------------------------------
# The scatterplot tooltip normally names bill_len and bill_dep and nothing
# else. Hover a point and the island now shows alongside them.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(island)

# --- several at once -------------------------------------------------------
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(island, species, body_mass)

# --- labelling -------------------------------------------------------------
# The argument name becomes the label. It rides over as the field's alias,
# so it also titles the axis if that column is mapped to one - which is a
# feature: one name for a column, used everywhere the column appears.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(Island = island, `Body mass (g)` = body_mass)

# --- an alias titles the axis too ------------------------------------------
# bill_len is on the x axis, so naming it here renames the axis as well.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(`Bill length (mm)` = bill_len, `Bill depth (mm)` = bill_dep)

# --- alongside a colour mapping --------------------------------------------
# set_color() adds its own column for you, so species is on the tooltip
# without being named here.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species) |>
  set_tooltip(Island = island) |>
  set_labs(
    title = "Bill shape by species",
    x = "Bill length (mm)",
    y = "Bill depth (mm)"
  )

# --- passing nothing clears it ---------------------------------------------
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(Island = island) |>
  set_tooltip()


# --- on a bar chart --------------------------------------------------------
# Bar, line, box and heat charts have no tooltip field of their own in the
# spec, so the widget installs its own formatter and R ships the values with
# the config. Each bar covers many rows, so the column must be constant.
sites <- data.frame(
  city = c("Portland", "Portland", "Bend", "Bend", "Salem"),
  state = c("OR", "OR", "OR", "OR", "OR"),
  region = c("West", "West", "Central", "Central", "West"),
  sales = c(10, 14, 7, 9, 12)
)

arc_col(sites, city, sales) |>
  set_tooltip(Region = region)

# --- and on an aggregated one ----------------------------------------------
# region is constant within each city, so it survives the group-by.
arc_chart(sites) |>
  set_type("bar") |>
  set_x(city) |>
  set_y(sales) |>
  set_stat("sum") |>
  set_tooltip(Region = region, State = state) |>
  set_labs(title = "Sales by city", y = "Sales")

# --- on a line chart -------------------------------------------------------
arc_line(sites, city, sales) |>
  set_tooltip(Region = region)

# --- on a heat chart -------------------------------------------------------
# A cell is keyed by both axes, so a column constant within a cell works.
arc_heat(penguins, species, island) |>
  set_tooltip(Sex = sex)


# --- a field that varies within a mark -------------------------------------
# island takes three values inside the Adelie bar, so there is no single one
# to show. This errors rather than picking one.
try(
  arc_bar(penguins, species) |>
    set_tooltip(Island = island) |>
    as_widget()
)

# --- the one type it cannot do ---------------------------------------------
# Histogram bins are computed in the browser, so there is no stable key to
# join the values onto.
try(arc_histogram(penguins, bill_len) |> set_tooltip(island))

# --- a date-typed x is refused ---------------------------------------------
# R and JavaScript stringify dates differently, so the lookup key would never
# match. Format the column first if you need it.
dated <- data.frame(
  day = as.Date("2024-01-01") + 0:4,
  value = c(3, 5, 2, 8, 6),
  note = c("a", "b", "c", "d", "e")
)

try(arc_col(dated, day, value) |> set_tooltip(Note = note) |> as_widget())
