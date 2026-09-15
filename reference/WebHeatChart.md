# WebHeatChart

A [`WebChart()`](http://r.esri.com/arcgisviz/reference/WebChart.md) with
the settings only a heat chart has.

## Value

An object of class `WebHeatChart`.

## Examples

``` r
WebHeatChart(
  version = "18.1.0",
  type = "heatChart",
  hideEmptyRowsAndColumns = TRUE,
  nullPolicy = WebChartNullPolicyTypes("zero")
)
#> <arcgisviz::WebHeatChart>
#>  @ version                     : chr "18.1.0"
#>  @ type                        : chr "heatChart"
#>  @ id                          : chr NA
#>  @ dataFilters                 : NULL
#>  @ title                       : NULL
#>  @ subtitle                    : NULL
#>  @ footer                      : NULL
#>  @ background                  : NULL
#>  @ cursorCrosshair             : NULL
#>  @ legend                      : NULL
#>  @ axes                        : list()
#>  @ horizontalAxisLabelsBehavior: <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ verticalAxisLabelsBehavior  : <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ series                      : list()
#>  @ rotated                     : logi NA
#>  @ stackedType                 : <arcgisviz::WebChartStackedKinds>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "sideBySide" "stacked" "stacked100"
#>  .. @ allow_na: logi TRUE
#>  @ colorMatch                  : logi NA
#>  @ chartRenderer               : NULL
#>  @ orderOptions                : NULL
#>  @ iLayer                      : NULL
#>  @ outTimeZone                 : chr NA
#>  @ firstDayOfWeek              : int NA
#>  @ nullPolicy                  : <arcgisviz::WebChartNullPolicyTypes>
#>  .. @ value   : chr "zero"
#>  .. @ variants: chr [1:3] "interpolate" "null" "zero"
#>  .. @ allow_na: logi TRUE
#>  @ hideEmptyRowsAndColumns     : logi TRUE
#>  @ viewType                    : <arcgisviz::WebChartHeatChartViewTypes>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "SingleCalendarView" "SequentialCalendarViews"
#>  .. @ allow_na: logi TRUE
#>  @ includeLeapDay              : logi NA

# Built for you by the public API.
arc_heat(datasets::penguins, species, island)@webchart
#> <arcgisviz::WebHeatChart>
#>  @ version                     : chr "25.1.0"
#>  @ type                        : chr "chart"
#>  @ id                          : chr NA
#>  @ dataFilters                 : NULL
#>  @ title                       : NULL
#>  @ subtitle                    : NULL
#>  @ footer                      : NULL
#>  @ background                  : NULL
#>  @ cursorCrosshair             : NULL
#>  @ legend                      : NULL
#>  @ axes                        :List of 2
#>  .. $ : <arcgisviz::WebChartAxis>
#>  ..  ..@ type                : chr "chartAxis"
#>  ..  ..@ visible             : logi NA
#>  ..  ..@ isLogarithmic       : logi NA
#>  ..  ..@ title               : <arcgisviz::WebChartText>
#>  .. .. .. @ type   : chr "chartText"
#>  .. .. .. @ visible: logi NA
#>  .. .. .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. .. .. @ type               : chr "esriTS"
#>  .. .. .. .. @ style              : chr NA
#>  .. .. .. .. @ text               : chr "species"
#>  .. .. .. .. @ color              : NULL
#>  .. .. .. .. @ backgroundColor    : NULL
#>  .. .. .. .. @ borderLineSize     : num NA
#>  .. .. .. .. @ borderLineColor    : NULL
#>  .. .. .. .. @ haloSize           : num NA
#>  .. .. .. .. @ haloColor          : NULL
#>  .. .. .. .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ rightToLeft        : logi NA
#>  .. .. .. .. @ kerning            : logi NA
#>  .. .. .. .. @ font               : NULL
#>  .. .. .. .. @ angle              : num NA
#>  .. .. .. .. @ xoffset            : chr NA
#>  .. .. .. .. @ yoffset            : chr NA
#>  ..  ..@ valueFormat         : <arcgisviz::CategoryFormatOptions>
#>  .. .. .. @ type          : chr "category"
#>  .. .. .. @ characterLimit: num NA
#>  ..  ..@ minimum             : num NA
#>  ..  ..@ maximum             : num NA
#>  ..  ..@ grid                : NULL
#>  ..  ..@ guides              : list()
#>  ..  ..@ lineSymbol          : NULL
#>  ..  ..@ labels              : <arcgisviz::WebChartText>
#>  .. .. .. @ type   : chr NA
#>  .. .. .. @ visible: logi NA
#>  .. .. .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. .. .. @ type               : chr NA
#>  .. .. .. .. @ style              : chr NA
#>  .. .. .. .. @ text               : chr NA
#>  .. .. .. .. @ color              : NULL
#>  .. .. .. .. @ backgroundColor    : NULL
#>  .. .. .. .. @ borderLineSize     : num NA
#>  .. .. .. .. @ borderLineColor    : NULL
#>  .. .. .. .. @ haloSize           : num NA
#>  .. .. .. .. @ haloColor          : NULL
#>  .. .. .. .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ rightToLeft        : logi NA
#>  .. .. .. .. @ kerning            : logi NA
#>  .. .. .. .. @ font               : NULL
#>  .. .. .. .. @ angle              : num NA
#>  .. .. .. .. @ xoffset            : chr NA
#>  .. .. .. .. @ yoffset            : chr NA
#>  ..  ..@ scrollbar           : NULL
#>  ..  ..@ displayZeroLine     : logi NA
#>  ..  ..@ integerOnlyValues   : logi NA
#>  ..  ..@ displayCursorTooltip: logi NA
#>  ..  ..@ buffer              : logi NA
#>  ..  ..@ tickSpacing         : num NA
#>  ..  ..@ dateBaseInterval    : NULL
#>  .. $ : <arcgisviz::WebChartAxis>
#>  ..  ..@ type                : chr "chartAxis"
#>  ..  ..@ visible             : logi NA
#>  ..  ..@ isLogarithmic       : logi NA
#>  ..  ..@ title               : <arcgisviz::WebChartText>
#>  .. .. .. @ type   : chr "chartText"
#>  .. .. .. @ visible: logi NA
#>  .. .. .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. .. .. @ type               : chr "esriTS"
#>  .. .. .. .. @ style              : chr NA
#>  .. .. .. .. @ text               : chr "island"
#>  .. .. .. .. @ color              : NULL
#>  .. .. .. .. @ backgroundColor    : NULL
#>  .. .. .. .. @ borderLineSize     : num NA
#>  .. .. .. .. @ borderLineColor    : NULL
#>  .. .. .. .. @ haloSize           : num NA
#>  .. .. .. .. @ haloColor          : NULL
#>  .. .. .. .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ rightToLeft        : logi NA
#>  .. .. .. .. @ kerning            : logi NA
#>  .. .. .. .. @ font               : NULL
#>  .. .. .. .. @ angle              : num NA
#>  .. .. .. .. @ xoffset            : chr NA
#>  .. .. .. .. @ yoffset            : chr NA
#>  ..  ..@ valueFormat         : <arcgisviz::CategoryFormatOptions>
#>  .. .. .. @ type          : chr "category"
#>  .. .. .. @ characterLimit: num NA
#>  ..  ..@ minimum             : num NA
#>  ..  ..@ maximum             : num NA
#>  ..  ..@ grid                : NULL
#>  ..  ..@ guides              : list()
#>  ..  ..@ lineSymbol          : NULL
#>  ..  ..@ labels              : <arcgisviz::WebChartText>
#>  .. .. .. @ type   : chr NA
#>  .. .. .. @ visible: logi NA
#>  .. .. .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. .. .. @ type               : chr NA
#>  .. .. .. .. @ style              : chr NA
#>  .. .. .. .. @ text               : chr NA
#>  .. .. .. .. @ color              : NULL
#>  .. .. .. .. @ backgroundColor    : NULL
#>  .. .. .. .. @ borderLineSize     : num NA
#>  .. .. .. .. @ borderLineColor    : NULL
#>  .. .. .. .. @ haloSize           : num NA
#>  .. .. .. .. @ haloColor          : NULL
#>  .. .. .. .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ rightToLeft        : logi NA
#>  .. .. .. .. @ kerning            : logi NA
#>  .. .. .. .. @ font               : NULL
#>  .. .. .. .. @ angle              : num NA
#>  .. .. .. .. @ xoffset            : chr NA
#>  .. .. .. .. @ yoffset            : chr NA
#>  ..  ..@ scrollbar           : NULL
#>  ..  ..@ displayZeroLine     : logi NA
#>  ..  ..@ integerOnlyValues   : logi NA
#>  ..  ..@ displayCursorTooltip: logi NA
#>  ..  ..@ buffer              : logi NA
#>  ..  ..@ tickSpacing         : num NA
#>  ..  ..@ dateBaseInterval    : NULL
#>  @ horizontalAxisLabelsBehavior: <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ verticalAxisLabelsBehavior  : <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ series                      :List of 1
#>  .. $ : <arcgisviz::WebChartHeatChartSeries>
#>  ..  ..@ type                    : chr "heatSeries"
#>  ..  ..@ id                      : chr "series1"
#>  ..  ..@ visible                 : logi NA
#>  ..  ..@ dataTooltipVisible      : logi NA
#>  ..  ..@ dataTooltipReverseColor : logi NA
#>  ..  ..@ dataTooltipValueFormat  : NULL
#>  ..  ..@ dataTooltipPercentFormat: NULL
#>  ..  ..@ dataTooltipDateFormat   : NULL
#>  ..  ..@ dataTooltipFontSize     : num NA
#>  ..  ..@ name                    : chr "island"
#>  ..  ..@ query                   : NULL
#>  ..  ..@ x                       : chr "species"
#>  ..  ..@ dataLabels              : NULL
#>  ..  ..@ assignToSecondValueAxis : logi NA
#>  ..  ..@ y                       : chr "island"
#>  ..  ..@ xTemporalBinning        : NULL
#>  ..  ..@ yTemporalBinning        : NULL
#>  ..  ..@ gridLine                : NULL
#>  ..  ..@ heatRulesType           : <arcgisviz::WebChartHeatChartHeatRulesTypes>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:2] "gradient" "renderer"
#>  .. .. .. @ allow_na: logi TRUE
#>  ..  ..@ gradientRules           : NULL
#>  ..  ..@ classBreaksRules        : NULL
#>  ..  ..@ emptyCells              : NULL
#>  @ rotated                     : logi NA
#>  @ stackedType                 : <arcgisviz::WebChartStackedKinds>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "sideBySide" "stacked" "stacked100"
#>  .. @ allow_na: logi TRUE
#>  @ colorMatch                  : logi NA
#>  @ chartRenderer               : NULL
#>  @ orderOptions                : NULL
#>  @ iLayer                      : NULL
#>  @ outTimeZone                 : chr NA
#>  @ firstDayOfWeek              : int NA
#>  @ nullPolicy                  : <arcgisviz::WebChartNullPolicyTypes>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "interpolate" "null" "zero"
#>  .. @ allow_na: logi TRUE
#>  @ hideEmptyRowsAndColumns     : logi NA
#>  @ viewType                    : <arcgisviz::WebChartHeatChartViewTypes>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "SingleCalendarView" "SequentialCalendarViews"
#>  .. @ allow_na: logi TRUE
#>  @ includeLeapDay              : logi NA
```
