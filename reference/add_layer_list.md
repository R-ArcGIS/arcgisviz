# Add a layer list

Lists the map's layers, with a checkbox each. Every layer
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md) drew
appears under the `name` it was given.

## Usage

``` r
add_layer_list(
  map,
  position = NULL,
  expand = FALSE,
  show_filter = NULL,
  filter_placeholder = NULL,
  drag_enabled = NULL,
  selection_mode = NULL,
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

- show_filter:

  default `NULL`. Defines whether a filter box is drawn above the list.

- filter_placeholder:

  default `NULL`. Defines that box's placeholder text.

- drag_enabled:

  default `NULL`. Defines whether layers can be reordered by dragging.

- selection_mode:

  default `NULL`. Defines how items are selected, one of `"none"`,
  `"single"`, `"multiple"`, or `"single-persist"`.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_layer_list(show_filter = TRUE)
```
