# Select marks on a rendered chart

Select marks on a rendered chart

## Usage

``` r
set_selection(proxy, object_ids)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) to
  select on.

- object_ids:

  Defines which rows to select, by object id. An empty vector clears the
  selection.

## Value

`proxy`, invisibly.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    set_selection(c(1, 2))
}
```
