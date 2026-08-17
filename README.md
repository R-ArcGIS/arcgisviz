

<!-- README.md is generated from README.qmd. Please edit that file -->

# arcgisviz

`{arcgisviz}` builds interactive charts with the [ArcGIS Maps SDK for
JavaScript](https://developers.arcgis.com/javascript/latest/). Charts
render as htmlwidgets, so they work in the Viewer, in Quarto, and in
Shiny.

<!-- badges: start -->

<!-- badges: end -->

## Installation

``` r
pak::pak("R-ArcGIS/arcgisviz")
```

## Usage

Start with `arc_chart()` and pipe. Each `set_*()` function maps one
thing.

``` r
library(arcgisviz)

arc_chart(penguins) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(body_mass) |>
  set_stat("mean") |>
  set_color(species) |>
  set_labs(title = "Palmer penguins", y = "Mean body mass (g)")
```

`arc_bar()`, `arc_col()`, `arc_scatter()`, and `arc_line()` are
shorthand for the common pipelines.

``` r
arc_scatter(penguins, bill_len, bill_dep) |>
  set_color(body_mass, palette = "Blue 3")
```

A numeric column becomes a continuous gradient and a categorical one
gets a colour per value. `palette` takes any of the 521 Esri colour
ramps or a vector of R colours.

## Axes

`set_axis()` handles one axis at a time. `set_flipped()` draws bars
sideways.

``` r
arc_bar(penguins, island) |>
  set_axis("y", limits = c(0, NA), integer_only = TRUE) |>
  set_flipped()
```

## Configuration

Every chart is backed by S7 classes mirroring the SDK’s `WebChart` JSON.
Reach for them when you need something the `set_*()` functions do not
cover.

``` r
library(arcgisviz)

chart <- arc_bar(penguins, species)

class(chart@webchart)
#> [1] "arcgisviz::WebChart" "S7_object"
chart@webchart@series[[1]]@type
#> [1] "barSeries"
```
