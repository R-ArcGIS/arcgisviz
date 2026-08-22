# Show, hide, or fade a layer that is already drawn

Changes one layer's appearance without resending it. `remove_layer()`
takes it off the map instead.

## Usage

``` r
set_layer(proxy, layer, visible = NULL, opacity = NULL)

remove_layer(proxy, layer = NULL)
```

## Arguments

- proxy:

  Defines which
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to modify.

- layer:

  Defines which layer, by the `name` it was added with. `remove_layer()`
  accepts `NULL` to remove every layer.

- visible:

  default `NULL`. Defines whether the layer is drawn.

- opacity:

  default `NULL`. Defines the layer opacity, from `0` to `1`.

## Value

`proxy`, invisibly.

## Examples

``` r
if (interactive()) {
  arc_map_proxy("map") |>
    set_layer("Counties", visible = FALSE)
}
```
