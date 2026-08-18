# Set a chart's statistical transformation

Chooses how `y` is derived from the data. `"identity"` plots `y`
verbatim and every other value aggregates `y` grouped by `x`.

## Usage

``` r
set_stat(chart, stat)
```

## Arguments

- chart:

  Defines which chart to modify.

- stat:

  Defines how `y` is aggregated. One of `"identity"`, `"count"`,
  `"sum"`, `"mean"`, `"min"`, `"max"`, `"sd"`, or `"var"`.

## Value

`chart`, with its stat set.

## Examples

``` r
df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))

arc_chart(df) |>
  set_type("bar") |>
  set_x(species) |>
  set_y(mass) |>
  set_stat("mean")
```
