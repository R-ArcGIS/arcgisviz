# WebChartPieChartLegend

A pie's legend, which can also carry each slice's value and percentage.
A pie always draws a legend - it is the only key to the slices.

## Value

An object of class `WebChartPieChartLegend`.

## Examples

``` r
WebChartPieChartLegend(
  type = "chartLegend",
  displayCategory = TRUE,
  displayPercentage = TRUE
)
#> <arcgisviz::WebChartPieChartLegend>
#>  @ type               : chr "chartLegend"
#>  @ visible            : logi NA
#>  @ title              : NULL
#>  @ body               : NULL
#>  @ position           : <arcgisviz::WebChartLegendPositions>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "bottom" "left" "right" "top"
#>  .. @ allow_na: logi TRUE
#>  @ maxHeight          : num NA
#>  @ roundMarkers       : logi NA
#>  @ displayCategory    : logi TRUE
#>  @ displayNumericValue: logi NA
#>  @ displayPercentage  : logi TRUE
#>  @ labelMaxWidth      : num NA
#>  @ valueLabelMaxWidth : num NA
```
