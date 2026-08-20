# set_tooltip() names extra columns to show when a mark is hovered. Name an
# argument to label it. Render one at a time in the Viewer.
devtools::load_all()


# --- one extra field -------------------------------------------------------
# The tooltip normally names bill_len and bill_dep and nothing else. Hover a
# point and the island now shows alongside them.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(island)

# --- labelling ------------------------------------------------------------
# The argument name becomes the label. It rides over as the field's alias,
# so it also titles the axis if that column is mapped to one.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_tooltip(Island = island, `Body mass (g)` = body_mass)

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

# --- on a bar chart --------------------------------------------------------
# Bar, line, box, and heat charts have no tooltip field of their own, so the
# widget installs its own formatter and R ships the values with the config.
# Each bar covers many rows, so the column has to be constant within one.
sites <- data.frame(
  city = c("Portland", "Portland", "Bend", "Bend", "Salem"),
  state = c("OR", "OR", "OR", "OR", "OR"),
  region = c("West", "West", "Central", "Central", "West"),
  sales = c(10, 14, 7, 9, 12)
)

arc_col(sites, city, sales) |>
  set_tooltip(Region = region)

# --- a field that varies within a mark -------------------------------------
# island takes three values within the Adelie bar, so there is no single one
# to show and this errors rather than picking one.
try(
  arc_bar(penguins, spzecies) |>
    set_stat("count") |>
    set_tooltip(Island = island) |>
    as_widget()
)

# --- a heat chart ----------------------------------------------------------
# A cell is keyed by both axes, so a column constant within one cell works.
arc_heat(penguins, species, island) |>
  set_tooltip(Sex = sex)

# --- the one type it cannot do ---------------------------------------------
# Histogram bins are computed in the browser, so there is no group to key on.
try(arc_histogram(penguins, bill_len) |> set_tooltip(island))
