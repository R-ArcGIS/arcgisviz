# The three distribution charts: histogram, box plot, and heat chart. None of
# them plots y the way a bar chart does - a histogram derives its frequency
# axis, a box plot summarises y into five numbers, and a heat chart's value is
# the count of rows in each cell.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins


# --- histogram: one numeric column, binned ---------------------------------
# There is no y to map. The bin count is chosen by the browser.
arc_histogram(penguins, body_mass)

# --- histogram: a fixed bin count ------------------------------------------
arc_histogram(penguins, body_mass, bins = 15)

# The same knob at either end, so you can see what it costs.
arc_histogram(penguins, body_mass, bins = 5)
arc_histogram(penguins, body_mass, bins = 40)

# --- histogram: a transform before binning ---------------------------------
# "none", "log", or "sqrt". A log transform pulls a long right tail in so the
# bins carry comparable numbers of rows.
arc_histogram(penguins, body_mass, bins = 12, transform = "log")
arc_histogram(penguins, body_mass, bins = 12, transform = "sqrt")

# --- histogram: the same options from the long pipeline --------------------
# Every arc_<type>() argument is also an argument to set_<type>().
arc_chart(penguins) |>
  set_type("histogram") |>
  set_x(flipper_len) |>
  set_histogram(bins = 20) |>
  set_labs(title = "Flipper length", x = "Flipper length (mm)")

# --- histogram: composed with the rest of the API ---------------------------
arc_histogram(penguins, body_mass, bins = 12) |>
  set_color(body_mass, palette = "Blue 3") |>
  set_axis("x", limits = c(2500, 6500)) |>
  set_labs(title = "Body mass", x = "Body mass (g)", y = "Penguins")


# --- box plot: x groups the boxes, y is summarised -------------------------
arc_boxplot(penguins, species, body_mass)

# --- box plot: hide the outliers -------------------------------------------
arc_boxplot(penguins, species, body_mass, outliers = FALSE) |>
  set_labs(title = "Body mass by species", y = "Body mass (g)")

# --- box plot: comparable scales -------------------------------------------
# z scores instead of raw values, so boxes measured in different units line
# up against each other.
arc_boxplot(penguins, species, body_mass) |>
  set_boxplot(standardize = TRUE)

# --- box plot: sideways ----------------------------------------------------
# Long category names read better on the vertical axis.
arc_boxplot(penguins, species, bill_len) |>
  set_flipped()

# --- box plot: grouped -----------------------------------------------------
# set_color() on a second column splits it, the same way it splits a bar
# chart. Box plots always sit side by side, so there is no position to set.
arc_boxplot(penguins, species, body_mass) |>
  set_color(sex) |>
  set_legend(position = "bottom", title = "Sex") |>
  set_labs(title = "Body mass by species and sex", y = "Body mass (g)")


# --- heat chart: a grid of counts ------------------------------------------
# Two categorical columns. Each cell is shaded by how many rows fall into it.
arc_heat(penguins, species, island)

# --- heat chart: an Esri heatmap ramp --------------------------------------
# There is no column to map, because the value is the cell count. So palette
# travels on its own. Ramps tagged "heatmap" are built for this.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3")

esri_palettes(tag = "heatmap")$palette

# --- heat chart: your own two colours --------------------------------------
# Anything that is not a named Esri ramp collapses to the two-colour gradient
# the spec allows, so a longer vector is read at its ends.
arc_heat(penguins, species, island) |>
  set_color(palette = c("white", "navy"))

# --- heat chart: labelled, with its legend ---------------------------------
# A heat chart always draws a legend, and the legend is the gradient itself.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3") |>
  set_legend(position = "right", title = "Penguins") |>
  set_labs(
    title = "Penguins by species and island",
    x = "Species",
    y = "Island"
  )

# --- what these three cannot do --------------------------------------------
# set_position() is a bar and line capability. The ArcGIS client has no
# stacking code for a histogram or a heat chart, and a box plot arranges its
# own groups, so these error rather than quietly doing nothing.
try(arc_histogram(penguins, body_mass) |> set_position("stack"))
try(arc_heat(penguins, species, island) |> set_position("stack"))
try(arc_boxplot(penguins, species, body_mass) |> set_position("stack"))
