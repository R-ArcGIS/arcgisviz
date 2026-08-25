# Add a widget to a map

Puts one of the Maps SDK's own components on the map - a legend, a layer
list, a search box, a basemap gallery. Each is a real web component that
finds the map itself, so nothing has to be wired up.

## Usage

``` r
add_widget(map, widget, position = NULL, expand = FALSE, ...)

remove_widget(map, widget = NULL)
```

## Arguments

- map:

  Defines which map or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to modify.

- widget:

  default `NULL`. Defines which widget to take off, by the name it was
  added with. `NULL` removes every widget.

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

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Details

Adding a widget that is already on the map replaces it, which is what
makes `add_widget()` idempotent across
[`arc_update()`](http://r.esri.com/arcgisviz/reference/arc_update.md)
flushes. `remove_widget()` takes one off again.

## Examples

``` r
arc_map() |>
  add_widget("legend") |>
  add_widget("layer-list", position = "top-right", show_filter = TRUE)
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
