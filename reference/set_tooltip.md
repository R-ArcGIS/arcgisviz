# Add columns to a chart's tooltip

Names extra columns to show when a mark is hovered, alongside `x` and
`y`. Name an argument to label it, or pass a bare column name to label
it with the column name. A column mapped with
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) is
added for you.

## Usage

``` r
set_tooltip(chart, ...)
```

## Arguments

- chart:

  Defines which chart to modify.

- ...:

  Defines which columns to show, as bare column names. Name an argument
  to use that name as the label. Passing none clears whatever is already
  set.

## Value

`chart`, with its tooltip fields set.

## Details

Every mark on a chart covers a group of rows: a bar covers every row
with that `x`, a heat cell every row in that pair of categories. An
extra field can only be shown when it takes a single value across that
group, so `set_tooltip()` checks that and errors rather than pick one
arbitrarily. Histograms are the exception and take no tooltip fields at
all, because their bins are computed in the browser.

## Examples

``` r
df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6), id = c("a", "b", "c"))

arc_scatter(df, len, dep) |>
  set_tooltip(Identifier = id)
```
