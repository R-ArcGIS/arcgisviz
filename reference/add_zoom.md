# Add a navigation control

The map's buttons: zoom in and out, return to the starting view,
reorient north, fill the screen, and find the reader. They take no
arguments beyond where they sit.

## Usage

``` r
add_zoom(map, position = NULL, layout = NULL, visual_scale = NULL, ...)

add_home(map, position = NULL, visual_scale = NULL, ...)

add_compass(map, position = NULL, visual_scale = NULL, ...)

add_fullscreen(map, position = NULL, visual_scale = NULL, ...)

add_locate(map, position = NULL, scale = NULL, visual_scale = NULL, ...)

add_track(map, position = NULL, scale = NULL, visual_scale = NULL, ...)
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

- layout:

  default `NULL`. Defines whether the two zoom buttons stack,
  `"vertical"` or `"horizontal"`.

- visual_scale:

  default `NULL`. Defines the button's size relative to its default, as
  a multiplier.

- ...:

  Named properties of the component itself, written either `snake_case`
  or `camelCase`.
  [`map_widgets()`](http://r.esri.com/arcgisviz/reference/map_widgets.md)
  lists what each one takes.

- scale:

  default `NULL`. Defines the scale the map zooms to when the reader is
  found.

## Value

`map`, with the widget added.

## Details

`add_locate()` moves the map to the reader's position once;
`add_track()` follows it as it changes. Both ask the browser for
permission, and both need a secure context - `https://` or `localhost`.

## Examples

``` r
arc_map() |>
  add_zoom(layout = "horizontal") |>
  add_home() |>
  add_compass()
#> Error in `method(as_widget, arcgisviz::ArcMap)`(x = <object>, width = NULL,     height = NULL, element_id = NULL): `x` has no layers to render.
```
