# Render an ArcGIS map

Wraps the `<arcgis-map>` web component directly. Most users want
[`arc_map()`](http://r.esri.com/arcgisviz/reference/arc_map.md) and
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md),
which build the arguments for you.

## Usage

``` r
arcgis_map(
  layers = list(),
  basemap = "topo-vector",
  center = NULL,
  zoom = NULL,
  extent = NULL,
  selectable = NULL,
  highlight = NULL,
  widgets = list(),
  width = NULL,
  height = NULL,
  element_id = NULL
)
```

## Arguments

- layers:

  Defines the feature collection layers to draw, each as built by
  [`as_feature_layer()`](http://r.esri.com/arcgisviz/reference/as_feature_layer.md).

- basemap:

  default `"topo-vector"`. Defines the basemap the layers draw over, as
  a basemap id.

- center:

  default `NULL`. Defines the initial centre as `c(lon, lat)`. When
  unset the map frames the layers.

- zoom:

  default `NULL`. Defines the initial zoom level.

- extent:

  default `NULL`. Defines the initial extent, overriding `center` and
  `zoom`.

- selectable:

  default `NULL`. Defines which layers a click selects in, by layer id.

- highlight:

  default `NULL`. Defines the selection highlight styles, as a list of
  named `HighlightOptions`. See
  [`set_highlight()`](http://r.esri.com/arcgisviz/reference/set_highlight.md).

- widgets:

  default [`list()`](https://rdrr.io/r/base/list.html). Defines the SDK
  components drawn over the map, each a list of `component`, `position`,
  and `props`. See
  [`add_widget()`](http://r.esri.com/arcgisviz/reference/add_widget.md).

- width, height:

  default `NULL`. Defines the widget size, passed to
  [`htmlwidgets::createWidget()`](https://rdrr.io/pkg/htmlwidgets/man/createWidget.html).

- element_id:

  default `NULL`. Defines the DOM element id to render into.

## Value

An htmlwidget.

## Examples

``` r
arcgis_map(basemap = "gray-vector", center = c(-98.3, 38.2), zoom = 4)

{"x":{"basemap":"gray-vector","center":[-98.3,38.2],"zoom":4.0},"evals":[],"jsHooks":[]}
```
