# Add a layer to a map

Draws a data frame or `sf` object as a client side feature layer. Colour
takes a bare column name, the same as
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) does
on a chart.

## Usage

``` r
add_layer(map, .data, ...)
```

## Arguments

- map:

  Defines which map to modify.

- .data:

  Defines which `sf` object supplies the features.

- ...:

  Passed to the
  [ArcMap](http://r.esri.com/arcgisviz/reference/ArcMap.md) or
  [IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md)
  method.

## Value

`map`, with the layer appended.

## Details

`.data` is either a data frame to build a layer from, or an
[IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md)
you built yourself. The second form is the escape hatch: anything this
function does not expose is done by constructing the layer and modifying
it, usually with
[`add_renderer()`](http://r.esri.com/arcgisviz/reference/add_renderer.md).

    nc |>
      as_feature_layer() |>
      add_renderer(ISimpleRenderer(symbol = my_symbol)) |>
      (\(lyr) add_layer(arc_map(), lyr))()

## Examples

``` r
nc <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

arc_map("gray-vector") |>
  add_layer(nc, color = BIR74, palette = "Orange 5", name = "Counties")

# A fixed colour needs no mapping, since a layer has one symbol either way.
arc_map() |>
  add_layer(nc, palette = "grey30", opacity = 0.6) |>
  add_layer(sf::st_centroid(nc), color = SID74, size = 8)
#> Warning: st_centroid assumes attributes are constant over geometries
```
