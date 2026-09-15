# WebChartPieChartTick

The leader line joining a slice to its label when the label sits outside
the pie.

## Value

An object of class `WebChartPieChartTick`.

## Examples

``` r
WebChartPieChartTick(
  type = "chartPieChartTick",
  visible = TRUE,
  lineSymbol = ISimpleLineSymbol(width = 0.5)
)
#> <arcgisviz::WebChartPieChartTick>
#>  @ type      : chr "chartPieChartTick"
#>  @ visible   : logi TRUE
#>  @ lineSymbol: <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: NULL
#>  .. @ width: num 0.5
```
