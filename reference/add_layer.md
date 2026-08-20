# Add a layer to a map

Draws a data frame or `sf` object as a client side feature layer. Colour
takes a bare column name, the same as
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) does
on a chart.

## Usage

``` r
add_layer(
  map,
  .data,
  color = NULL,
  palette = NULL,
  size = NULL,
  opacity = NULL,
  name = NULL
)
```

## Arguments

- map:

  Defines which map to modify.

- .data:

  Defines which `sf` object supplies the features.

- color:

  default `NULL`. Defines which column drives the symbol colour. A
  numeric column becomes a gradient, anything else one colour per value.

- palette:

  default `NULL`. Defines the colour ramp, either an Esri ramp name from
  [`esri_palettes()`](http://r.esri.com/arcgisviz/reference/esri_palettes.md)
  or a vector of R colours.

- size:

  default `NULL`. Defines the marker size or line width in points.

- opacity:

  default `NULL`. Defines the layer opacity, from `0` to `1`.

- name:

  default `NULL`. Defines the layer name shown in a legend.

## Value

`map`, with the layer appended.

## Examples

``` r
set_basemap(arc_map(), "gray-vector")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
