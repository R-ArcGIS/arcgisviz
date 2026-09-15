# Filter a rendered chart or map in the browser

Applies a SQL `where` clause, or a set of object ids, to a chart or map
that is already on screen. Nothing is resent and no model is rebuilt:
the chart requeries the layer it already holds, and a map layer
re-evaluates its own definition expression.

## Usage

``` r
set_filter(proxy, ...)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to filter.

- ...:

  Passed to the
  [ArcProxy](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
  [ArcMapProxy](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  method.

## Value

`proxy`, invisibly.

## Details

Each call defines the complete filter state, because the element
replaces `runtimeDataFilters` wholesale rather than merging into it.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    set_filter("mass > 2")
}
```
