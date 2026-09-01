# Radar chart

Draws a line chart on a circular axis, so the first and last `x` values
meet. Aggregates and groups exactly as
[`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md) does.

## Usage

``` r
arc_radar(.data, x, y)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x, y:

  Defines which columns supply the bar positions and heights.

## Value

An `ArcChart`.

## Examples

``` r
df <- data.frame(month = c("jan", "feb", "mar"), rain = c(1, 5, 3))

arc_radar(df, month, rain)
```
