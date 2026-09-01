# Add a coordinate readout

Reports the coordinates under the pointer, in the formats the reader
picks.

## Usage

``` r
add_coordinate_conversion(
  map,
  position = NULL,
  expand = FALSE,
  mode = NULL,
  orientation = NULL,
  expanded = NULL,
  ...
)
```

## Arguments

- map:

  Defines which map or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to modify.

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

- mode:

  default `NULL`. Defines whether it reads the pointer or a captured
  point, `"live"` or `"capture"`.

- orientation:

  default `NULL`. Defines which way the list opens, `"auto"`,
  `"expand-up"`, or `"expand-down"`.

- expanded:

  default `NULL`. Defines whether the format list starts open. Unrelated
  to `expand`, which collapses the whole widget behind a button.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_coordinate_conversion(mode = "capture")
```
