# Add a bookmark list

Saves and returns to named views of the map.

## Usage

``` r
add_bookmarks(
  map,
  position = NULL,
  expand = FALSE,
  show_add_bookmark_button = NULL,
  show_edit_bookmark_button = NULL,
  hide_thumbnail = NULL,
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

- show_add_bookmark_button:

  default `NULL`. Defines whether the reader can add bookmarks.

- show_edit_bookmark_button:

  default `NULL`. Defines whether existing bookmarks can be renamed.

- hide_thumbnail:

  default `NULL`. Defines whether each bookmark's preview image is
  hidden.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_bookmarks(show_add_bookmark_button = TRUE)
```
