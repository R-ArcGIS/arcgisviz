# set_labs() overrides the text a chart labels itself with: its title,
# subtitle, caption, and the two axis titles.
#
# Three states, and the difference matters. Omit an argument and whatever is
# there stays. Pass a string and it is set. Pass NULL and the label is
# removed, which is not the same as leaving it alone.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- every label at once ---------------------------------------------------
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

# --- omitted labels keep their defaults ------------------------------------
# Axis titles default to the mapped columns, so this renames the y axis and
# leaves x and the title exactly as they were.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_labs(y = "Bill depth (mm)")

# --- NULL removes a label --------------------------------------------------
# Blanks both axis titles. The tooltip still names the fields, so nothing is
# lost - the chart is just quieter.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species) |>
  set_labs(title = "Bill dimensions", x = NULL, y = NULL)

# --- a title is absent unless you set one ----------------------------------
# The ArcGIS client titles an untitled chart "Chart". This package sends an
# explicit null to delete that default, so no title means no title.
arc_bar(penguins, island)

# --- calls accumulate ------------------------------------------------------
# Same rule as set_legend() and the set_<type>() options: a later call layers
# over an earlier one rather than resetting it.
arc_bar(penguins, island) |>
  set_labs(x = "Island") |>
  set_labs(y = "Penguins counted") |>
  set_labs(title = "Penguins per island")

# --- and a later call can undo an earlier one ------------------------------
arc_bar(penguins, island) |>
  set_labs(title = "Penguins per island", subtitle = "Counted 2007-2009") |>
  set_labs(subtitle = NULL)

# --- under aggregation the y default names the statistic -------------------
# The default is "mean(body_mass)", not "body_mass", because that is what the
# axis actually shows. Override it when the units matter more than the maths.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean")

# --- labels on every chart type --------------------------------------------
# set_labs() is type-agnostic. A pie has no axes, so x and y have nowhere to
# go and are ignored rather than being an error.
arc_pie(penguins, species) |>
  set_labs(title = "Penguins by species", caption = "n = 344")

arc_histogram(penguins, flipper_len, bins = 20) |>
  set_labs(title = "Flipper length", x = "Flipper length (mm)", y = "Penguins")

arc_heat(penguins, species, island) |>
  set_labs(title = "Where each species lives", x = "Species", y = "Island")

# --- a radar's axis titles are blank by default ----------------------------
# The client would centre them in the middle of the plot, so this package
# blanks them. set_labs() still wins if you want one back.
arc_radar(penguins, species, body_mass) |>
  set_stat("mean") |>
  set_axis("y", limits = c(0, NA)) |>
  set_labs(title = "Mean body mass by species")

# --- labels compose with everything else -----------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(sex, palette = "Watermelon Sugar") |>
  set_position("dodge") |>
  set_flipped() |>
  set_legend(position = "bottom", title = "Sex") |>
  set_labs(
    title = "Penguins by sex and island",
    subtitle = "Mean body mass, grams",
    x = NULL,
    y = NULL
  )
