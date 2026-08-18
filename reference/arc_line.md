# Line chart

Joins one point per row in `x` order. Use
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) to
aggregate `y` first.

## Usage

``` r
arc_line(.data, x, y, position = NULL)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x, y:

  Defines which columns supply the bar positions and heights.

- position:

  default `NULL`. Defines how
  [`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
  groups are placed, one of `"dodge"`, `"stack"`, or `"fill"`. See
  [`set_position()`](http://r.esri.com/arcgisviz/reference/set_position.md).

## Value

An `ArcChart`.

## Examples

``` r
df <- data.frame(year = c(2020, 2021, 2022), mass = c(1, 5, 3))

arc_line(df, year, mass)
```
