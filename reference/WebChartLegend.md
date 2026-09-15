# WebChartLegend

The key naming a chart's series.
[`set_legend()`](http://r.esri.com/arcgisviz/reference/set_legend.md)
builds one for you, and knows which charts the client will actually draw
a legend on.

## Usage

``` r
WebChartLegend(
  type = NA_character_,
  visible = NA,
  title = NULL,
  body = NULL,
  position = WebChartLegendPositions(),
  maxHeight = NA_real_,
  roundMarkers = NA
)
```

## Arguments

- type:

  String.

- visible:

  Bool.

- title:

  `NULL` or a `WebChartText` object.

- body:

  `NULL` or a `WebChartTextSymbol` object.

- position:

  A `WebChartLegendPositions` enum.

- maxHeight:

  Number.

- roundMarkers:

  Bool.

## Value

An object of class `WebChartLegend`.

## Examples

``` r
WebChartLegend(
  type = "chartLegend",
  visible = TRUE,
  position = WebChartLegendPositions("bottom")
)
#> <arcgisviz::WebChartLegend>
#>  @ type        : chr "chartLegend"
#>  @ visible     : logi TRUE
#>  @ title       : NULL
#>  @ body        : NULL
#>  @ position    : <arcgisviz::WebChartLegendPositions>
#>  .. @ value   : chr "bottom"
#>  .. @ variants: chr [1:4] "bottom" "left" "right" "top"
#>  .. @ allow_na: logi TRUE
#>  @ maxHeight   : num NA
#>  @ roundMarkers: logi NA
```
