# Swap a chart's axes

Draws the chart on its side, turning vertical bars into horizontal ones.
The mapping is untouched, so `x` stays `x`.

## Usage

``` r
set_flipped(chart, flipped = TRUE)
```

## Arguments

- chart:

  Defines which chart to modify.

- flipped:

  default `TRUE`. Defines whether the axes are swapped.

## Value

`chart`, with its orientation set.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass) |>
  set_flipped()
#> Error in loadNamespace(x): there is no package called ‘arcgisutils’
```
