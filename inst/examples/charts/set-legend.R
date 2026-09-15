# set_legend() moves, titles, and hides a chart's legend.
#
# The one rule to know: the ArcGIS client decides whether a chart *has* a
# legend at all, and the config cannot argue. Heat charts and pies always do.
# Bar, line, radar and box plots only once there is more than one series -
# which means once set_color() has grouped them. Asking for a legend on a
# chart that cannot draw one is an error, not a silent no-op.
#
# Run one chart at a time - each prints into the Viewer.
library(arcgisviz)

penguins <- datasets::penguins

mass_by_species <- function() {
  arc_chart(penguins) |>
    set_type("bar") |>
    set_x(species) |>
    set_y(body_mass) |>
    set_stat("mean")
}


# --- one series, no legend -------------------------------------------------
# Nothing to key, so nothing is drawn. Compare with the next one.
mass_by_species()

# --- grouping makes one ----------------------------------------------------
# Each group is a series, and a series names itself in the legend.
mass_by_species() |>
  set_color(island)

# --- move it ---------------------------------------------------------------
# "right", "left", "top", "bottom". The client's own default is right.
mass_by_species() |> set_color(island) |> set_legend(position = "bottom")
mass_by_species() |> set_color(island) |> set_legend(position = "left")
mass_by_species() |> set_color(island) |> set_legend(position = "top")

# --- title it --------------------------------------------------------------
# The client's default title is empty but visible, so a title here fills a
# space that was already reserved.
mass_by_species() |>
  set_color(island) |>
  set_legend(position = "bottom", title = "Island")

# --- repeated calls layer --------------------------------------------------
# Same rule as set_labs(): an omitted argument leaves what is already set.
mass_by_species() |>
  set_color(island) |>
  set_legend(title = "Island") |>
  set_legend(position = "top")

# --- take it away ----------------------------------------------------------
# Every default config ships a *visible* legend, so hiding one that would
# otherwise render takes an explicit FALSE.
mass_by_species() |>
  set_color(island) |>
  set_legend(visible = FALSE)

# --- a series names itself after what it plots -----------------------------
# Unsplit, the one series is called "mean(body_mass)" rather than "series1",
# so a legend entry reads as the thing it keys.
mass_by_species() |>
  set_color(island) |>
  set_legend(title = "Island", position = "right")


# --- a pie always has one --------------------------------------------------
# It is the only key to the slices, so no grouping is needed.
arc_pie(penguins, species) |>
  set_legend(position = "left", title = "Species")

# --- a heat chart's legend is its colour ramp ------------------------------
# It shades cells by count rather than by a column, so the legend is the
# gradient itself and is drawn without any grouping.
arc_heat(penguins, species, island) |>
  set_color(palette = "Heatmap 3") |>
  set_legend(position = "right", title = "Penguins")

# --- a grouped box plot ----------------------------------------------------
arc_boxplot(penguins, species, body_mass) |>
  set_color(sex) |>
  set_legend(position = "bottom", title = "Sex")

# --- a grouped line --------------------------------------------------------
arc_line(penguins, flipper_len, body_mass) |>
  set_color(species) |>
  set_legend(position = "right", title = "Species")


# --- asking for one that cannot exist is an error --------------------------
# The client draws a legend only where the chart has entries for it, so
# visible = TRUE on a single-series bar chart would be read and then ignored.
try(mass_by_species() |> set_legend(visible = TRUE) |> as_widget())

# A scatterplot colours per marker rather than splitting into series, so it
# has no entries to key either - set_color() does not change that.
try(
  arc_scatter(penguins, bill_len, bill_dep) |>
    set_color(species) |>
    set_legend(visible = TRUE) |>
    as_widget()
)

# The check fires when the chart is built, not when the setter is called,
# because whether the chart is grouped depends on a set_color() that may
# come after. So this one is fine.
mass_by_species() |>
  set_legend(visible = TRUE) |>
  set_color(island)

# --- and position is the spec's own vocabulary -----------------------------
try(mass_by_species() |> set_color(island) |> set_legend(position = "leading"))
