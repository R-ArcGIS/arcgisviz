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
