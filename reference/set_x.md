# Map a column to a chart's x/y field

Map a column to a chart's x/y field

## Usage

``` r
set_x(chart, x)

set_y(chart, y)
```

## Arguments

- chart:

  An `ArcChart`, from
  [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md)
  with [`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md)
  already called.

- x, y:

  A bare column name from `chart`'s data (tidy eval).

## Value

`chart`, with the field mapping set.
