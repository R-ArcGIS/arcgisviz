# Set a chart's labels

Overrides the text a chart labels itself with. Omitting an argument
leaves that label as it is; passing a string sets it, and passing `NULL`
removes it. `x` and `y` default to the mapped column names.

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

  An `ArcChart`, from
  [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md).

- ...:

  These dots are for future extensions and must be empty.

- title, subtitle, caption:

  Chart-level text. `caption` is rendered as the chart's footer. All
  three are absent unless set.

- x, y:

  Axis titles. These also label the values in a tooltip.

## Value

`chart`, with its labels set.
