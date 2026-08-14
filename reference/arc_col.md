# Column chart

Plots `y` verbatim, one bar per row, the way `ggplot2::geom_col()` does.

## Usage

``` r
arc_col(.data, x, y)
```

## Arguments

- .data:

  A data frame (or similar) the chart's fields will come from.

- x, y:

  Bare column names from `.data` (tidy eval).

## Value

An `ArcChart`.
