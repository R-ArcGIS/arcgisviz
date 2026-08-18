# Column chart

Plots `y` verbatim, one bar per row. Use
[`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md) to count
rows instead.

## Usage

``` r
arc_col(.data, x, y)
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
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass)
```
