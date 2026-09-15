# WebChartBoxPlotSeries

The box plot's series. `y` is a character *vector* here, not a single
string - a box summarises its column into five numbers.

## Value

An object of class `WebChartBoxPlotSeries`.

## Examples

``` r
WebChartBoxPlotSeries(
  type = "boxPlotSeries",
  id = "series0",
  name = "body_mass",
  x = "species",
  y = "body_mass",
  fillSymbol = ISimpleFillSymbol(
    color = Color(r = 78, g = 121, b = 167, a = 1)
  )
)
#> <arcgisviz::WebChartBoxPlotSeries>
#>  @ type                    : chr "boxPlotSeries"
#>  @ id                      : chr "series0"
#>  @ visible                 : logi NA
#>  @ dataTooltipVisible      : logi NA
#>  @ dataTooltipReverseColor : logi NA
#>  @ dataTooltipValueFormat  : NULL
#>  @ dataTooltipPercentFormat: NULL
#>  @ dataTooltipDateFormat   : NULL
#>  @ dataTooltipFontSize     : num NA
#>  @ name                    : chr "body_mass"
#>  @ query                   : NULL
#>  @ x                       : chr "species"
#>  @ dataLabels              : NULL
#>  @ assignToSecondValueAxis : logi NA
#>  @ y                       : chr "body_mass"
#>  @ fillSymbol              : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 78
#>  .. .. @ g: num 121
#>  .. .. @ b: num 167
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
```
