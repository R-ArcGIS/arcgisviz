# Bar chart

Counts rows per `x`, the way `ggplot2::geom_bar()` does. Use
[`arc_col()`](http://r.esri.com/arcgisviz/reference/arc_col.md) to plot
values you have already summarised, or
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) for
any other aggregation.

## Usage

``` r
arc_bar(.data, x)
```

## Arguments

- .data:

  A data frame (or similar) the chart's fields will come from.

- x:

  A bare column name from `.data` (tidy eval).

## Value

An `ArcChart`.
