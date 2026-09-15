# WebChartHeatChartSeries

The heat chart's series. Cells are shaded by their own `gradientRules`
or `classBreaksRules` rather than by the chart's renderer, and the value
is the cell count - which is why
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
takes `palette` alone here.

## Value

An object of class `WebChartHeatChartSeries`.

## Examples

``` r
WebChartHeatChartSeries(
  type = "heatSeries",
  id = "series0",
  x = "species",
  y = "island",
  heatRulesType = WebChartHeatChartHeatRulesTypes("gradient"),
  gradientRules = WebChartHeatChartGradient(
    colorList = list(
      Color(r = 255, g = 255, b = 255, a = 1),
      Color(r = 0, g = 0, b = 128, a = 1)
    )
  )
)
#> <arcgisviz::WebChartHeatChartSeries>
#>  @ type                    : chr "heatSeries"
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
#>  @ x                       : chr "species"
#>  @ dataLabels              : NULL
#>  @ assignToSecondValueAxis : logi NA
#>  @ y                       : chr "island"
#>  @ xTemporalBinning        : NULL
#>  @ yTemporalBinning        : NULL
#>  @ gridLine                : NULL
#>  @ heatRulesType           : <arcgisviz::WebChartHeatChartHeatRulesTypes>
#>  .. @ value   : chr "gradient"
#>  .. @ variants: chr [1:2] "gradient" "renderer"
#>  .. @ allow_na: logi TRUE
#>  @ gradientRules           : <arcgisviz::WebChartHeatChartGradient>
#>  .. @ colorList             :List of 2
#>  .. .. $ : <arcgisviz::Color>
#>  .. ..  ..@ r: num 255
#>  .. ..  ..@ g: num 255
#>  .. ..  ..@ b: num 255
#>  .. ..  ..@ a: num 1
#>  .. .. $ : <arcgisviz::Color>
#>  .. ..  ..@ r: num 0
#>  .. ..  ..@ g: num 0
#>  .. ..  ..@ b: num 128
#>  .. ..  ..@ a: num 1
#>  .. @ minValue              : num NA
#>  .. @ maxValue              : num NA
#>  .. @ outsideRangeLowerColor: NULL
#>  .. @ outsideRangeUpperColor: NULL
#>  @ classBreaksRules        : NULL
#>  @ emptyCells              : NULL
```
