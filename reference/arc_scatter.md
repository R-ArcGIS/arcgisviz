# Scatterplot

Plots one marker per row. Scatterplots ignore
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md).

## Usage

``` r
arc_scatter(.data, x, y)
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
df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6))

arc_scatter(df, len, dep)
```
