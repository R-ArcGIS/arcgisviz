# Add a measurement tool

Measures distance along a drawn line, or the area and perimeter of a
drawn shape. The result arrives in Shiny as
`input$<output_id>$measurement`, a value and its unit.

## Usage

``` r
add_measurement(
  map,
  type = "area",
  position = NULL,
  expand = FALSE,
  unit = NULL,
  unit_options = NULL,
  ...
)
```

## Arguments

- map:

  Defines which map or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to modify.

- type:

  default `"area"`. Defines what is measured, `"area"` or `"distance"`.
  Add one of each to offer both.

- position:

  default `NULL`. Defines which corner it sits in, one of `"top-left"`,
  `"top-right"`, `"bottom-left"`, `"bottom-right"`, or the
  direction-aware `"top-start"`, `"top-end"`, `"bottom-start"`,
  `"bottom-end"`. Each widget has its own default.

- expand:

  default `FALSE`. Defines whether the widget is collapsed behind a
  button rather than drawn open. Worth it for the panels - the legend,
  layer list, basemap gallery - which otherwise cover the map. Collapsed
  widgets sharing a corner close each other when opened.

- unit:

  default `NULL`. Defines the unit the result is shown in, such as
  `"square-kilometers"` or `"miles"`.

- unit_options:

  default `NULL`. Defines which units the reader can pick from.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |>
  add_measurement("area", unit = "square-kilometers") |>
  add_measurement("distance")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
