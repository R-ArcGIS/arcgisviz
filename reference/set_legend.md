# Position or hide a chart's legend

Moves, titles, or removes the key naming a chart's groups. A legend
needs something to name, so a chart only has one once
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) has
grouped it, and it is drawn by default from then on. A heat chart is the
exception: its legend is the colour gradient, so it always has one.

## Usage

``` r
set_legend(chart, visible = NULL, position = NULL, title = NULL)
```

## Arguments

- chart:

  Defines which chart to modify.

- visible:

  default `NULL`. Defines whether the legend is drawn.

- position:

  default `NULL`. Defines where it sits, one of `"right"`, `"left"`,
  `"top"`, or `"bottom"`.

- title:

  default `NULL`. Defines the text above the legend.

## Value

`chart`, with its legend set.

## Details

Asking for a legend on a chart that cannot show one is an error rather
than a silent no-op - `visible = TRUE` cannot conjure a key out of a
single series.

## Examples

``` r
df <- data.frame(
  species = c("a", "a", "b"),
  island = c("x", "y", "x")
)

arc_bar(df, species) |>
  set_color(island) |>
  set_legend(position = "bottom", title = "Island")
```
