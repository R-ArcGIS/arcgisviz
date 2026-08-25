# Add a basemap gallery

Lets the reader swap the basemap for any in the gallery.
`add_basemap_ toggle()` is the two-basemap version, a single button.

## Usage

``` r
add_basemap_gallery(map, position = NULL, expand = FALSE, disabled = NULL, ...)

add_basemap_toggle(
  map,
  position = NULL,
  expand = FALSE,
  next_basemap = NULL,
  show_title = NULL,
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

- disabled:

  default `NULL`. Defines whether the gallery is greyed out.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

- next_basemap:

  default `NULL`. Defines the basemap to toggle to, as an id from
  [Basemaps](http://r.esri.com/arcgisviz/reference/Basemaps.md).

- show_title:

  default `NULL`. Defines whether the basemap's name is drawn under the
  button.

## Value

`map`, with the widget added.

## Examples

``` r
arc_map() |> add_basemap_gallery(expand = TRUE)
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
arc_map() |> add_basemap_toggle(next_basemap = "satellite")
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
