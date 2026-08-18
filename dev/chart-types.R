# Histogram, box plot, and heat chart. Render one at a time in the Viewer.
devtools::load_all()

# --- histogram -------------------------------------------------------------
# One numeric column, binned. There is no y to map because the frequency
# axis is derived.
arc_histogram(penguins, body_mass)

# --- histogram: a fixed bin count ------------------------------------------
arc_histogram(penguins, body_mass, bins = 15)

# --- histogram: a log transform before binning ------------------------------
arc_histogram(penguins, body_mass, bins = 12, transform = "log")

# --- histogram: the same options from the core pipe ------------------------
arc_chart(penguins) |>
  set_type("histogram") |>
  set_x(flipper_len) |>
  set_histogram(bins = 20) |>
  set_labs(title = "Flipper length", x = "Flipper length (mm)")

# --- box plot --------------------------------------------------------------
# x groups the boxes, y is summarised.
arc_boxplot(penguins, species, body_mass)

# --- box plot: hide the outliers -------------------------------------------
arc_boxplot(penguins, species, body_mass, outliers = FALSE) |>
  set_labs(title = "Body mass by species", y = "Body mass (g)")

# --- box plot: comparable scales -------------------------------------------
# z scores instead of raw values, so boxes with different units line up.
arc_boxplot(penguins, species, body_mass) |>
  set_boxplot(standardize = TRUE)

# --- box plot: sideways ----------------------------------------------------
arc_boxplot(penguins, species, bill_len) |>
  set_flipped()

# --- heat chart ------------------------------------------------------------
# A grid of cells, shaded by how many rows fall into each pair.
arc_heat(penguins, species, island)

# --- heat chart: an Esri heatmap ramp --------------------------------------
# There is no column to map because the value is the cell count, so palette
# travels on its own. Ramps tagged "heatmap" suit these best.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3")

# --- heat chart: your own two colours --------------------------------------
arc_heat(penguins, species, island) |>
  set_color(palette = c("white", "navy"))

# --- heat chart: labelled --------------------------------------------------
arc_heat(penguins, species, island) |>
  set_labs(
    title = "Penguins by species and island",
    x = "Species",
    y = "Island"
  )

# --- everything else still composes ----------------------------------------
arc_histogram(penguins, body_mass, bins = 12) |>
  set_color(body_mass, palette = "Blue 3") |>
  set_axis("x", limits = c(2500, 6500), ) |>
  set_labs(title = "Body mass", x = "Body mass (g)")
