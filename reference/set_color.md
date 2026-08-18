# Map a column to colour

Colours each mark by the value of a column. A numeric column becomes a
continuous gradient and a character or factor column gets one colour per
distinct value.

## Usage

``` r
set_color(chart, color, palette = NULL)
```

## Arguments

- chart:

  Defines which chart to modify.

- color:

  Defines which column the colours are drawn from. Omitted for heat
  charts.

- palette:

  default `NULL`. Defines which colours to use, either the name of an
  Esri ramp such as `"Blue 3"` or a vector of R colours. `NULL` uses the
  ramp the ArcGIS SDK itself defaults to.

## Value

`chart`, with its colour set.

## Details

Heat charts shade cells by how many rows fall into each, so there is no
column to map. Give them `palette` on its own.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass) |>
  set_color(mass, palette = "Red 1")
```
