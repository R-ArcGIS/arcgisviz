# Start a map

Creates an empty map to pipe
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md) and
the `set_*()` functions into. Printing it renders the widget.

## Usage

``` r
arc_map(basemap = "topo-vector")
```

## Arguments

- basemap:

  default `"topo-vector"`. Defines the basemap the layers draw over. See
  [Basemaps](http://r.esri.com/arcgisviz/reference/Basemaps.md) for the
  full set.

## Value

An [ArcMap](http://r.esri.com/arcgisviz/reference/ArcMap.md).

## Examples

``` r
arc_map("gray-vector")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
