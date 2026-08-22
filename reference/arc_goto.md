# Move a rendered map's view

`arc_goto()` animates the view, unlike
[`set_view()`](http://r.esri.com/arcgisviz/reference/set_view.md) on a
proxy, which jumps to the new position. `arc_screenshot()` captures the
view as a PNG data URL and sends it back as
`input$<output_id>_screenshot`.

## Usage

``` r
arc_goto(proxy, center = NULL, zoom = NULL, extent = NULL, duration = NULL)

arc_screenshot(proxy, format = "png")
```

## Arguments

- proxy:

  Defines which
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to act on.

- center:

  default `NULL`. Defines the target centre as `c(lon, lat)`.

- zoom:

  default `NULL`. Defines the target zoom level.

- extent:

  default `NULL`. Defines the target extent, overriding `center` and
  `zoom`.

- duration:

  default `NULL`. Defines the animation length in milliseconds.

- format:

  default `"png"`. Defines the screenshot format, `"png"` or `"jpg"`.

## Value

`proxy`, invisibly.

## Examples

``` r
if (interactive()) {
  arc_map_proxy("map") |>
    arc_goto(center = c(-79, 35.5), zoom = 8)
}
```
