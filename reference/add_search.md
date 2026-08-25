# Add a search box

Finds places by name and moves the map to them, using Esri's geocoding
service. Nothing needs configuring for place search.

## Usage

``` r
add_search(
  map,
  position = NULL,
  expand = FALSE,
  search_term = NULL,
  all_placeholder = NULL,
  max_results = NULL,
  popup_disabled = NULL,
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

- search_term:

  default `NULL`. Defines the text the box starts with.

- all_placeholder:

  default `NULL`. Defines the placeholder text.

- max_results:

  default `NULL`. Defines how many results a search returns.

- popup_disabled:

  default `NULL`. Defines whether choosing a result opens a popup.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_search(all_placeholder = "Find a county")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
