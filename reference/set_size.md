# Map a column to marker size

Scales each marker by the value of a numeric column, turning a
scatterplot into a bubble chart. Only scatterplots draw markers, so this
does not apply to the other chart types.

## Usage

``` r
set_size(chart, size, range = NULL, scale = "linear")
```

## Arguments

- chart:

  Defines which chart to modify.

- size:

  Defines which numeric column the marker sizes are drawn from.

- range:

  default `NULL`. Defines the smallest and largest marker size as a
  length-2 numeric vector. `NULL` keeps the SDK's own 5 to 30.

- scale:

  default `"linear"`. Defines how values map onto that range, either
  `"linear"` or `"log"`.

## Value

`chart`, with its marker sizes set.

## Examples

``` r
df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6), mass = c(10, 40, 25))

arc_scatter(df, len, dep) |>
  set_size(mass, range = c(4, 20))
```
