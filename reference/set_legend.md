# Control a rendered chart's legend

Control a rendered chart's legend

## Usage

``` r
set_legend(proxy, visible = NULL, position = NULL, title = NULL)
```

## Arguments

- proxy:

  Defines which
  [`arc_proxy()`](http://r.esri.com/arcgisviz/reference/ArcProxy.md) to
  modify.

- visible:

  default `NULL`. Defines whether the legend is shown.

- position:

  default `NULL`. Defines where it sits, one of `"top"`, `"bottom"`,
  `"leading"`, or `"trailing"`.

- title:

  default `NULL`. Defines the legend title.

## Value

`proxy`, invisibly.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

if (interactive()) {
  arc_proxy("chart", arc_col(df, species, mass)) |>
    set_legend(visible = TRUE, position = "bottom")
}
```
