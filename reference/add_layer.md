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

  Passed between methods. Must be empty when `.data` is an
  [IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md),
  whose own properties already answer `color`, `palette`, `size` and
  `tooltip`.

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

  default `NULL`. Defines the layer name, which is also the handle
  [`remove_layer()`](http://r.esri.com/arcgisviz/reference/set_layer.md)
  and
  [`set_layer()`](http://r.esri.com/arcgisviz/reference/set_layer.md)
  take. On an
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  it is required, because that is what tells the browser which layer is
  meant.

- tooltip:

  default `NULL`. Defines which columns are shown when a feature is
  hovered, as bare column names wrapped in
  [`c()`](https://rdrr.io/r/base/c.html). Name one to label it, as in
  `c(County = NAME)`.

- selectable:

  default `NULL`. Defines whether clicking a feature adds it to the
  selection, which arrives in Shiny as `input$<output_id>$selection`.
  See
  [`set_selection()`](http://r.esri.com/arcgisviz/reference/set_selection.md).

- visible:

  default `NULL`. Defines whether the layer starts drawn. Only when
  `.data` is an
  [IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md).

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
set_basemap(arc_map(), "gray-vector")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
