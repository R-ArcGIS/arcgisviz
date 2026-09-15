# set_color() maps a column onto colour. It follows ggplot2's rule: a numeric
# column becomes a continuous gradient, a factor or character column gets one
# colour per distinct value.
#
# `palette` is either the name of one of the 521 Esri smart-mapping ramps (see
# esri_palettes(), and inst/examples/charts/palettes.R) or a vector of R
# colours. `alpha` sets opacity on either.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- continuous: a numeric column ------------------------------------------
# The default is "Blue 3", the ramp the ArcGIS SDK itself uses for gradients.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass)

# --- continuous: a named Esri ramp -----------------------------------------
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Prairie Summer")

arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Watermelon Sugar")

# --- continuous: your own colours ------------------------------------------
# A vector of R colours - names, hex, or both - becomes the ramp, and the
# browser interpolates between them.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = c("white", "#f52424", "navy"))

arc_scatter(penguins, flipper_len, body_mass) |>
  set_color(body_mass, palette = c("grey90", "steelblue"))


# --- discrete: a factor column ---------------------------------------------
# The default is the SDK's own series palette, cycled.
arc_scatter(penguins, bill_len, flipper_len) |>
  set_color(species)

# --- discrete: colours pulled from a ramp ----------------------------------
# A ramp used discretely is sampled at even intervals, one stop per level.
arc_scatter(penguins, bill_len, flipper_len) |>
  set_color(species, palette = "Watercolor Surprise")

arc_bar(penguins, island) |>
  set_color(island, palette = "Purple 1") |>
  set_flipped()

# --- discrete: exactly the colours you name --------------------------------
# Three levels, three colours, in level order.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species, palette = c("#e15759", "#4e79a7", "#59a14f"))


# --- colouring by x is a scale, not a group --------------------------------
# There is only one group per bar, so nothing splits. Compare with
# set-group.R, where colouring by a *different* column does split the chart.
arc_bar(penguins, species) |>
  set_color(species)


# --- alpha: seeing through an overplotted scatter --------------------------
# 344 penguins on two axes overlap heavily. At 0.4 the dense middle of each
# cloud reads darker than its edges, which is the whole point of alpha.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species, alpha = 0.4)

# The same chart at full opacity, for comparison. Overlapping points here
# just cover each other up.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(species)

# --- alpha works on a gradient too -----------------------------------------
arc_scatter(penguins, flipper_len, body_mass) |>
  set_color(body_mass, palette = "Prairie Summer", alpha = 0.35)

# --- alpha wins over the palette's own opacity -----------------------------
# "#f5242480" is already half transparent; alpha = 1 overrides it, so these
# come out solid.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = c("#ffffff80", "#f5242480"), alpha = 1)

# --- alpha on grouped bars -------------------------------------------------
# Grouped series carry their colour on their own symbol rather than through a
# renderer. Alpha reaches both paths, so the shading matches either way.
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(island) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, alpha = 0.6)


# --- heat charts take a palette and nothing else ---------------------------
# Cells are shaded by their own count, so there is no column to map and
# set_color() takes `palette` alone.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3")

# A vector palette carries alpha into the gradient.
arc_heat(penguins, species, island) |>
  set_color(palette = c("white", "navy"), alpha = 0.5)

# A *named* Esri ramp cannot: it travels to the browser by name and the
# client generates the class breaks itself, so no colour leaves R with an
# alpha channel to carry. This errors rather than quietly ignoring you.
try(
  arc_heat(penguins, species, island) |>
    set_color(palette = "Heatmap 3", alpha = 0.5)
)


# --- a gauge has nothing to colour -----------------------------------------
# One reading has no marks for a scale to vary across.
try(arc_gauge(penguins, body_mass, stat = "mean") |> set_color(species))

# --- a numeric column cannot group -----------------------------------------
# Under aggregation the query returns only the grouped columns plus the
# statistics, so a gradient has nothing to resolve against. It has to be a
# group, and a numeric column cannot be one.
try(
  arc_chart(penguins) |>
    set_type("bar") |>
    set_x(species) |>
    set_y(flipper_len) |>
    set_stat("mean") |>
    set_color(body_mass) |>
    as_widget()
)


# --- colour composes with everything else ----------------------------------
arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, palette = "Watercolor Surprise", alpha = 0.85) |>
  set_axis("y", limits = c(0, NA)) |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    x = "Species",
    y = "Mean body mass (g)"
  )

# --- and the colour is readable on hover -----------------------------------
# A scatterplot tooltip names x and y. The coloured-by column joins them, so
# a mapping you can see is also a value you can read.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Blue 3")
