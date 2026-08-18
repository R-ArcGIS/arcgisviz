# Map a column to a chart's x or y field

Binds a column to one of the chart's positional fields. Both take a bare
column name.

## Usage

``` r
set_x(chart, x)

set_y(chart, y)
```

## Arguments

- chart:

  Defines which chart to modify.

- x, y:

  Defines which column supplies the field.

## Value

`chart`, with the field mapping set.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_chart(df) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(mass)
```
