# Set an axis

Overrides how one axis is scaled and drawn. Omitted arguments leave that
part of the axis as the chart would draw it.

## Usage

``` r
set_axis(
  chart,
  axis,
  ...,
  limits = NULL,
  log = NULL,
  zero_line = NULL,
  integer_only = NULL,
  tick_spacing = NULL,
  buffer = NULL,
  visible = NULL
)
```

## Arguments

- chart:

  Defines which chart to modify.

- axis:

  Defines which axis to change, either `"x"` or `"y"`.

- ...:

  These dots are for future extensions and must be empty.

- limits:

  default `NULL`. Defines the two values the axis spans, where `NA`
  leaves that bound to the chart.

- log:

  default `NULL`. Defines whether the axis is logarithmic.

- zero_line:

  default `NULL`. Defines whether a line is drawn at zero.

- integer_only:

  default `NULL`. Defines whether only whole numbers are labelled.

- tick_spacing:

  default `NULL`. Defines the smallest gap between ticks, which the
  chart may still widen to fit.

- buffer:

  default `NULL`. Defines whether space is added around the series.

- visible:

  default `NULL`. Defines whether the axis is drawn at all.

## Value

`chart`, with that axis set.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass) |>
  set_axis("y", limits = c(0, 10), zero_line = TRUE)
```
