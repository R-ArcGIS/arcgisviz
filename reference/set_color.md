# Map a column to colour

Colours each mark by the value of a column. A numeric column becomes a
continuous gradient; a character or factor column gets one colour per
distinct value.

## Usage

``` r
set_color(chart, color, palette = NULL)
```

## Arguments

- chart:

  An `ArcChart`, from
  [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md)
  with [`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md)
  already called.

- color:

  A bare column name from `chart`'s data (tidy eval).

- palette:

  The name of an Esri colour ramp (e.g. `"Blue 3"`, `"Flower Field"`),
  or a vector of R colours to build one from. Defaults to the ramp the
  ArcGIS SDK itself uses for gradients, and to its own series palette
  for discrete colours.

## Value

`chart`, with its colour mapping set.
