# WebChartHistogramSeries

The histogram's series. Bins are computed in the browser, which is why
there is no `y` to map and why
[`set_tooltip()`](http://r.esri.com/arcgisviz/reference/set_tooltip.md)
cannot key onto one.

## Value

An object of class `WebChartHistogramSeries`.

## Examples

``` r
WebChartHistogramSeries(
  type = "histogramSeries",
  id = "series0",
  x = "body_mass",
  binCount = 15,
  dataTransformationType = WebChartDataTransformations("logarithmic")
)
#> <arcgisviz::WebChartHistogramSeries>
#>  @ type                    : chr "histogramSeries"
#>  @ id                      : chr "series0"
#>  @ visible                 : logi NA
#>  @ dataTooltipVisible      : logi NA
#>  @ dataTooltipReverseColor : logi NA
#>  @ dataTooltipValueFormat  : NULL
#>  @ dataTooltipPercentFormat: NULL
#>  @ dataTooltipDateFormat   : NULL
#>  @ dataTooltipFontSize     : num NA
#>  @ name                    : chr NA
#>  @ query                   : NULL
#>  @ x                       : chr "body_mass"
#>  @ dataLabels              : NULL
#>  @ assignToSecondValueAxis : logi NA
#>  @ binCount                : num 15
#>  @ overlays                : NULL
#>  @ dataTransformationType  : <arcgisviz::WebChartDataTransformations>
#>  .. @ value   : chr "logarithmic"
#>  .. @ variants: chr [1:3] "none" "logarithmic" "squareRoot"
#>  .. @ allow_na: logi TRUE
#>  @ fillSymbol              : NULL
```
