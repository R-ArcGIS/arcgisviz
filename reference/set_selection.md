# Select features on a rendered chart or map

Marks rows as selected by object id. A chart draws them as its own
selection; a map highlights them in the view's highlight colour, which
is what makes a chart and a map on the same data link up.

## Usage

``` r
set_selection(proxy, object_ids, ...)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) or
  [`arc_map_proxy()`](http://r.esri.com/arcgisviz/reference/ArcMapProxy.md)
  to select on.

- object_ids:

  Defines which rows to select, by object id. An empty vector clears the
  selection.

- ...:

  Reserved for methods.

- layer:

  default `NULL`. Defines which map layer to highlight in, by name.
  `NULL` highlights in every layer. Maps only.

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
