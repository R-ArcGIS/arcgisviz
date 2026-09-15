# WebChartPieChartSeries

The pie's series. It reads the same query shape a bar chart's does, so
[`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) works
unchanged - what differs is that a pie sends no axes at all, and carries
the dial geometry (`innerRadius`, the angles) itself.

## Value

An object of class `WebChartPieChartSeries`.

## Examples

``` r
WebChartPieChartSeries(
  type = "pieSeries",
  id = "series0",
  x = "species",
  y = "count_0",
  innerRadius = 55,
  displayCategoryOnDataLabel = TRUE,
  displayPercentageOnDataLabel = TRUE
)
#> <arcgisviz::WebChartPieChartSeries>
#>  @ type                          : chr "pieSeries"
#>  @ id                            : chr "series0"
#>  @ visible                       : logi NA
#>  @ dataTooltipVisible            : logi NA
#>  @ dataTooltipReverseColor       : logi NA
#>  @ dataTooltipValueFormat        : NULL
#>  @ dataTooltipPercentFormat      : NULL
#>  @ dataTooltipDateFormat         : NULL
#>  @ dataTooltipFontSize           : num NA
#>  @ name                          : chr NA
#>  @ query                         : NULL
#>  @ x                             : chr "species"
#>  @ dataLabels                    : NULL
#>  @ assignToSecondValueAxis       : logi NA
#>  @ y                             : chr "count_0"
#>  @ innerRadius                   : num 55
#>  @ startAngle                    : num NA
#>  @ endAngle                      : num NA
#>  @ fillSymbol                    : NULL
#>  @ displayCategoryOnDataLabel    : logi TRUE
#>  @ displayNumericValueOnDataLabel: logi NA
#>  @ displayPercentageOnDataLabel  : logi TRUE
#>  @ displayCategoryOnTooltip      : logi NA
#>  @ displayNumericValueOnTooltip  : logi NA
#>  @ displayPercentageOnTooltip    : logi NA
#>  @ numericValueFormat            : NULL
#>  @ percentValueFormat            : NULL
#>  @ valuePrefix                   : chr NA
#>  @ valueSuffix                   : chr NA
#>  @ percentagePrefix              : chr NA
#>  @ percentageSuffix              : chr NA
#>  @ dataLabelsCharacterLimit      : num NA
#>  @ ticks                         : NULL
#>  @ dataLabelsInside              : logi NA
#>  @ dataLabelsOffset              : num NA
#>  @ alignDataLabels               : logi NA
#>  @ optimizeDataLabelsOverlapping : logi NA
#>  @ sliceGrouping                 : NULL
#>  @ slices                        : list()
```
