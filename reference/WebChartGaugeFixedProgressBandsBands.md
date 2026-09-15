# WebChartGaugeFixedProgressBandsBands

The two symbols a gauge's progress bands are drawn with - the filled
portion and the track behind it.

## Value

An object of class `WebChartGaugeFixedProgressBandsBands`.

## Examples

``` r
WebChartGaugeFixedProgressBandsBands(
  target = ISimpleFillSymbol(color = Color(r = 78, g = 121, b = 167, a = 1)),
  base = ISimpleFillSymbol(color = Color(r = 230, g = 230, b = 230, a = 1))
)
#> <arcgisviz::WebChartGaugeFixedProgressBandsBands>
#>  @ target: <arcgisviz::ISimpleFillSymbol>
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
#>  @ base  : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 230
#>  .. .. @ g: num 230
#>  .. .. @ b: num 230
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
```
