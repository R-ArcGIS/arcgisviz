# Set a chart's statistical transformation

How `y` is derived from the data, in the sense ggplot2's `stat` argument
means it. `"identity"` plots `y` verbatim, one mark per row
(`geom_col()`); every other value aggregates `y` grouped by `x`
(`geom_bar()`, or `stat_summary()`). `"count"` needs no `y` - it counts
rows per `x`.

## Usage

``` r
set_stat(chart, stat)
```

## Arguments

- chart:

  An `ArcChart`, from
  [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md)
  with [`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md)
  already called.

- stat:

  One of `"identity"`, `"count"`, `"sum"`, `"mean"`, `"min"`, `"max"`,
  `"sd"`, `"var"`.

## Value

`chart`, with its stat set.

## Details

Bar and line charts only; scatterplots ignore it.
