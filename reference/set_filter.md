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

  Reserved for methods.

- where:

  default `NULL`. Defines a SQL where clause, such as
  `"species = 'Adelie'"`. `NULL`, `NA`, or `""` clear it.

- object_ids:

  default `NULL`. Defines which rows to keep, by object id. `NULL` or an
  empty vector clears them. Charts only.

- layer:

  default `NULL`. Defines which map layer to filter, by name. `NULL`
  filters every layer. Maps only.

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
