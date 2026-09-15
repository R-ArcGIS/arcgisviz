# WebChartNeedle

The needle drawn over a gauge's fill. `set_gauge(needle = FALSE)` is the
friendly way to turn it off.

## Value

An object of class `WebChartNeedle`.

## Examples

``` r
WebChartNeedle(
  type = "chartGaugeNeedle",
  visible = TRUE,
  innerRadius = 20,
  displayPin = TRUE,
  symbol = ISimpleFillSymbol(color = Color(r = 51, g = 51, b = 51, a = 1))
)
#> <arcgisviz::WebChartNeedle>
#>  @ type       : chr "chartGaugeNeedle"
#>  @ visible    : logi TRUE
#>  @ symbol     : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 51
#>  .. .. @ g: num 51
#>  .. .. @ b: num 51
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
#>  @ startWidth : num NA
#>  @ endWidth   : num NA
#>  @ innerRadius: num 20
#>  @ displayPin : logi TRUE
```
