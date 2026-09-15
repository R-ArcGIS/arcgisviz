# WebChartGaugeSeries

The gauge's series. Its value rides `x`, not `y`, and `featureIndex`
picks a single row instead of aggregating - the spec indexes from zero
where
[`set_gauge()`](http://r.esri.com/arcgisviz/reference/arc_gauge.md)'s
`feature` counts from one.

## Value

An object of class `WebChartGaugeSeries`.

## Examples

``` r
WebChartGaugeSeries(
  type = "gaugeSeries",
  id = "series0",
  x = "AVG_body_mass_0"
)
#> <arcgisviz::WebChartGaugeSeries>
#>  @ type                    : chr "gaugeSeries"
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
#>  @ x                       : chr "AVG_body_mass_0"
#>  @ dataLabels              : NULL
#>  @ assignToSecondValueAxis : logi NA
#>  @ valueConversion         : NULL
#>  @ featureIndex            : num NA

# Reading the first row verbatim rather than a statistic.
WebChartGaugeSeries(type = "gaugeSeries", x = "body_mass", featureIndex = 0)
#> <arcgisviz::WebChartGaugeSeries>
#>  @ type                    : chr "gaugeSeries"
#>  @ id                      : chr NA
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
#>  @ valueConversion         : NULL
#>  @ featureIndex            : num 0
```
