# Send a proxy's changes to the browser

Flushes everything the `set_*()` and
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md)
calls have changed on an
[`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
[`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
as one message, so a pipeline of them costs one re-render.

## Usage

``` r
arc_update(proxy, ...)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to flush.

- ...:

  Reserved for methods.

## Value

`proxy`, invisibly.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    set_flipped() |>
    arc_update()
}
```
