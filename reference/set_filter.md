# Filter a rendered chart in the browser

Applies a SQL `where` clause, or a set of object ids, to a chart that is
already on screen. The chart requeries the layer it already holds, so no
data is resent and no model is rebuilt.

## Usage

``` r
set_filter(proxy, where = NULL, object_ids = NULL)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) to
  filter.

- where:

  default `NULL`. Defines a SQL where clause, such as
  `"species = 'Adelie'"`. `NULL`, `NA`, or `""` clear it.

- object_ids:

  default `NULL`. Defines which rows to keep, by object id. `NULL` or an
  empty vector clears them.

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
