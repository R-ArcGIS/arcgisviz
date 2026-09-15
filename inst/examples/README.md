# arcgisviz examples

Worked examples for every user-facing feature in the package. The scripts
under `charts/` and `maps/` are read top to bottom and run a chart at a time
into the RStudio Viewer; the four under `shiny/` are complete apps.

Find them on a machine with the package installed:

```r
system.file("examples", package = "arcgisviz")

file.edit(system.file("examples/charts/set-color.R", package = "arcgisviz"))
```

## Charts

| File | What it covers |
|---|---|
| [`charts/bar-line-scatter.R`](charts/bar-line-scatter.R) | The core pipeline - `arc_chart()`, `set_type()`, `set_x()`, `set_y()`, `set_stat()` - and the `arc_bar()`/`arc_col()`/`arc_line()`/`arc_scatter()` shortcuts |
| [`charts/chart-types.R`](charts/chart-types.R) | Histogram, box plot, heat chart, and their `set_histogram()`/`set_boxplot()` options |
| [`charts/pie-gauge-radar.R`](charts/pie-gauge-radar.R) | The three round types, and why a gauge is not a pie |
| [`charts/set-labs.R`](charts/set-labs.R) | Title, subtitle, caption, axis titles, and the difference between omitting a label and passing `NULL` |
| [`charts/set-axis.R`](charts/set-axis.R) | Limits, log scales, ticks, hiding an axis, and `set_flipped()` |
| [`charts/set-color.R`](charts/set-color.R) | Continuous and discrete colour, palettes, and `alpha` |
| [`charts/palettes.R`](charts/palettes.R) | Finding a ramp with `esri_palettes()` and `palette_tags()` |
| [`charts/set-group.R`](charts/set-group.R) | Grouped bars and lines, `set_position()`, and which types split and stack |
| [`charts/set-size.R`](charts/set-size.R) | Bubble charts with `set_size()` |
| [`charts/set-tooltip.R`](charts/set-tooltip.R) | Extra hover fields, labelling them, and the one type that cannot have them |
| [`charts/set-legend.R`](charts/set-legend.R) | Moving, titling and hiding a legend, and why `visible = TRUE` can be an error |

## Maps

| File | What it covers |
|---|---|
| [`maps/arc-map.R`](maps/arc-map.R) | `arc_map()` and `add_layer()`, basemaps, colour, size, tooltips, and hand-built renderers |
| [`maps/map-widgets.R`](maps/map-widgets.R) | The SDK's own components - legend, layer list, search, basemap gallery, sketch, measurement |
| [`maps/remote-layer.R`](maps/remote-layer.R) | Drawing a hosted feature service read with arcgislayers |

## Shiny

Each is a directory with an `app.R`, so it runs directly:

```r
shiny::runApp(system.file("examples/shiny/chart-proxy", package = "arcgisviz"))
```

| App | What it covers |
|---|---|
| [`shiny/chart-proxy`](shiny/chart-proxy/app.R) | `arc_proxy()`, every `set_*()` over the wire, `set_filter()`, exports, and all seven chart events |
| [`shiny/map-proxy`](shiny/map-proxy/app.R) | `arc_map_proxy()`, basemap and layer updates, `arc_goto()`, `arc_screenshot()`, hover/click/view events |
| [`shiny/map-selection`](shiny/map-selection/app.R) | The three routes into a map selection - a click, `arc_draw_selection()`, and `set_selection()` - plus `set_highlight()` |
| [`shiny/map-tools`](shiny/map-tools/app.R) | Sketch, editor and measurement, and reading a drawn shape back with `arc_sf()` |

## What they need

Everything uses `datasets::penguins` (charts) or the `nc.shp` that ships with
**sf** (maps), so no data has to be downloaded.

- `charts/` needs only **arcgisviz**.
- `maps/` needs **sf**. `remote-layer.R` needs **arcgislayers** and a network
  connection.
- `shiny/` needs **shiny**, and the three map apps use
  [**calcite**](https://r.esri.com/calcite/) for their layout. Nothing in the
  arcgisviz code depends on calcite - swap it for `shiny::fluidPage()` if you
  would rather not install it.
