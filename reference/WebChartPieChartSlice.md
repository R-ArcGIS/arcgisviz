# WebChartPieChartSlice

Per-slice styling. Modelled, but nothing in the public API sets it -
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
already does what this would.

## Value

An object of class `WebChartPieChartSlice`.

## Examples

``` r
WebChartPieChartSlice(
  sliceId = "Adelie",
  label = "Adelie",
  fillSymbol = ISimpleFillSymbol(
    color = Color(r = 78, g = 121, b = 167, a = 1)
  )
)
#> <arcgisviz::WebChartPieChartSlice>
#>  @ sliceId      : chr "Adelie"
#>  @ originalLabel: NULL
#>  @ label        : chr "Adelie"
#>  @ fillSymbol   : <arcgisviz::ISimpleFillSymbol>
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
