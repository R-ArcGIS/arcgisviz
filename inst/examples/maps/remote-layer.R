# Drawing a hosted feature service, read with arcgislayers. Nothing about the
# map changes - an sf object is an sf object.
#
# Run one map at a time - each prints into the Viewer.
library(arcgisviz)
library(arcgislayers)

# `fields` and `where` are the service's own query, so only what the map draws
# crosses the network.
cities <- arc_open("9df5e769bfe8412b8de36a2e618c7672") |>
  get_layer(0) |>
  arc_select(
    fields = c("NAME", "STATE_ABBR", "POPULATION", "POP_SQMI"),
    where = "POPULATION >= 100000"
  )


# --- proportional symbols --------------------------------------------------
# `size` takes a bare column, the same as `color`. The value rides the
# marker's area, so one 8-million-person city does not flatten the rest.
arc_map("gray-vector") |>
  set_view(center = c(-96, 38.5), zoom = 4) |>
  add_layer(
    cities,
    size = POPULATION,
    size_range = c(4, 34),
    palette = "#3182BD",
    name = "Population",
    tooltip = c(
      City = NAME,
      State = STATE_ABBR,
      Population = POPULATION
    )
  ) |>
  add_legend(position = "bottom-left")


# --- colour and size are separate mappings ---------------------------------
# Both ride one renderer, so a marker can carry two variables at once: how
# many people, and how densely they live.
arc_map("gray-vector") |>
  set_view(center = c(-96, 38.5), zoom = 4) |>
  add_layer(
    cities,
    color = POP_SQMI,
    palette = "Purple 4",
    size = POPULATION,
    name = "US cities",
    tooltip = c(
      City = NAME,
      State = STATE_ABBR,
      Population = POPULATION,
      `People per sq. mile` = POP_SQMI
    )
  ) |>
  add_legend(position = "bottom-left")


# --- a skewed count wants classes, not a ramp ------------------------------
# A colour ramp spreads evenly across range(column), so New York at 8.8M
# leaves every other city in the palest stop. Class the column first.
cities$size_class <- cut(
  cities$POPULATION,
  c(1e5, 2.5e5, 5e5, 1e6, Inf),
  c("100k - 250k", "250k - 500k", "500k - 1M", "1M and up"),
  right = FALSE
)

arc_map("gray-vector") |>
  set_view(center = c(-96, 38.5), zoom = 4) |>
  add_layer(
    cities,
    color = size_class,
    palette = "Blue 3",
    size = 9,
    name = "Population",
    tooltip = c(City = NAME, Population = POPULATION)
  ) |>
  add_legend(position = "bottom-left") |>
  add_home()
