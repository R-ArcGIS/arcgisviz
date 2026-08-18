# Set a chart's type

Chooses which kind of series the chart draws. Every other `set_*()`
function needs this to have run first.

## Usage

``` r
set_type(chart, type)
```

## Arguments

- chart:

  Defines which chart to modify.

- type:

  Defines which series the chart draws. One of `"bar"`, `"scatter"`,
  `"line"`, `"histogram"`, `"boxplot"`, or `"heat"`.

## Value

`chart`, with its series type set.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_chart(df) |>
  set_type("scatter") |>
  set_x(mass) |>
  set_y(mass)
```
