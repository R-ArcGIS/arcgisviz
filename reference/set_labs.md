# Set a chart's labels

Overrides the text a chart labels itself with. Omitting an argument
leaves that label alone, a string sets it, and `NULL` removes it.

## Usage

``` r
set_labs(
  chart,
  ...,
  title = lab_keep,
  subtitle = lab_keep,
  caption = lab_keep,
  x = lab_keep,
  y = lab_keep
)
```

## Arguments

- chart:

  Defines which chart to modify.

- ...:

  These dots are for future extensions and must be empty.

- title, subtitle, caption:

  Defines the chart-level text. Absent unless set, and `caption` renders
  as the chart's footer.

- x, y:

  Defines the axis titles, which also label tooltip values. Defaults to
  the mapped column names.

## Value

`chart`, with its labels set.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass) |>
  set_labs(title = "Mass by species", x = "Species", y = "Mass (g)")
```
