# set_color() gallery. Render one chart at a time in the Viewer. A numeric
# column becomes a continuous gradient; a factor or character column gets one
# colour per distinct value.
devtools::load_all()


# --- continuous: a numeric column -----------------------------------------
# Defaults to "Blue 3", the ramp the ArcGIS SDK itself uses for gradients.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Prairie Summer")

# --- continuous: a named Esri ramp ----------------------------------------
# Any of the 521 smart-mapping ramp names works.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Watermelon Sugar")

# --- continuous: your own colours -----------------------------------------
# A vector of R colours becomes the ramp; the client interpolates between them.
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = c("white", "#f52424", "navy"))

# --- discrete: a factor column --------------------------------------------
# Defaults to the SDK's own series palette, cycled.
arc_scatter(penguins, bill_len, flipper_len) |>
  set_color(species, palette = "Watercolor Surprise")

# --- discrete: colours pulled from a ramp ---------------------------------
arc_bar(penguins, island) |>
  set_color(island, palette = "Purple 1") |>
  set_flipped()

# --- colour composes with everything else ---------------------------------
library(arcgisviz)

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species, palette = "Watercolor Surprise") |>
  set_labs(
    title = "Palmer penguins",
    subtitle = "Mean body mass by species",
    x = "Species",
    y = "Mean body mass (g)"
  )

# --- hover to see the colour's value --------------------------------------
# A scatterplot tooltip names x and y. The coloured-by column joins them, so
# a mapping you can see is a value you can read.
arc_scatter(penguins, bill_len, bill_dep) |>
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

# --- alpha on a heat chart -------------------------------------------------
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
