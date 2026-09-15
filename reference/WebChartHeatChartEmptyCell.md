# WebChartHeatChartEmptyCell

How a cell with no rows in it is labelled and drawn.

## Value

An object of class `WebChartHeatChartEmptyCell`.

## Examples

``` r
WebChartHeatChartEmptyCell(
  text = "None",
  symbol = ISimpleFillSymbol(color = Color(r = 245, g = 245, b = 245, a = 1))
)
#> <arcgisviz::WebChartHeatChartEmptyCell>
#>  @ text  : chr "None"
#>  @ symbol: <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 245
#>  .. .. @ g: num 245
#>  .. .. @ b: num 245
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
```
