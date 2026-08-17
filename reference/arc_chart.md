# Start a chart

Creates an empty chart bound to a data frame. Pipe it into
[`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) before
mapping any columns.

## Usage

``` r
arc_chart(.data)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

## Value

An `ArcChart`.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_chart(df) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(mass)
#> Error in loadNamespace(x): there is no package called ‘arcgisutils’
```
