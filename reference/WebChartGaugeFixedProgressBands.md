# WebChartGaugeFixedProgressBands

Modelled, but nothing in the public API sets it - progress bands replace
the axis guides this package does not build either.

## Value

An object of class `WebChartGaugeFixedProgressBands`.

## Examples

``` r
WebChartGaugeFixedProgressBands(
  type = "chartGaugeFixedProgressBands",
  visible = TRUE,
  bands = WebChartGaugeFixedProgressBandsBands(
    target = ISimpleFillSymbol(
      color = Color(r = 78, g = 121, b = 167, a = 1)
    )
  )
)
#> <arcgisviz::WebChartGaugeFixedProgressBands>
#>  @ type   : chr "chartGaugeFixedProgressBands"
#>  @ visible: logi TRUE
#>  @ bands  : <arcgisviz::WebChartGaugeFixedProgressBandsBands>
#>  .. @ target: <arcgisviz::ISimpleFillSymbol>
#>  .. .. @ type   : chr "esriSFS"
#>  .. .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ color  : <arcgisviz::Color>
#>  .. .. .. @ r: num 78
#>  .. .. .. @ g: num 121
#>  .. .. .. @ b: num 167
#>  .. .. .. @ a: num 1
#>  .. .. @ outline: NULL
#>  .. @ base  : NULL
```
