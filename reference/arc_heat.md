# Heat chart

Draws a grid of cells, one per pair of `x` and `y` values, shaded by how
many rows fall into each.

## Usage

``` r
arc_heat(.data, x, y)
```

## Arguments

- .data:

  Defines which data frame the chart draws its fields from.

- x, y:

  Defines which columns form the grid.

## Value

An `ArcChart`.

## Examples

``` r
df <- data.frame(species = c("a", "a", "b"), island = c("x", "y", "x"))

arc_heat(df, species, island)
```
