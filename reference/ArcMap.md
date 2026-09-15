# A map

The object
[`arc_map()`](http://r.esri.com/arcgisviz/reference/arc_map.md) returns
and every `set_*()` and
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md) call
takes and returns.

## Value

An object of class `ArcMap`.

## Examples

``` r
arc_map("gray-vector")

# Every set_*() and add_*() returns the map, so it is one object being
# filled in rather than a sequence of drawing commands.
arc_map() |>
  set_basemap("satellite") |>
  set_view(center = c(-79, 35.5), zoom = 7) |>
  add_legend(position = "bottom-left")
```
