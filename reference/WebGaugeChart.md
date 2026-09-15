# WebGaugeChart

A [`WebChart()`](http://r.esri.com/arcgisviz/reference/WebChart.md) with
the dial's own geometry. `subType` picks the source: `statisticGauge`
reduces the whole layer, `featureGauge` reads one row.

## Value

An object of class `WebGaugeChart`.

## Examples

``` r
WebGaugeChart(
  version = "18.1.0",
  type = "gauge",
  innerRadius = 70,
  startAngle = -180,
  endAngle = 0,
  subType = GaugeChartSubTypes("statisticGauge")
)
#> <arcgisviz::WebGaugeChart>
#>  @ version                     : chr "18.1.0"
#>  @ type                        : chr "gauge"
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
#>  @ innerRadius                 : num 70
#>  @ startAngle                  : num -180
#>  @ endAngle                    : num 0
#>  @ subType                     : <arcgisviz::GaugeChartSubTypes>
#>  .. @ value   : chr "statisticGauge"
#>  .. @ variants: chr [1:2] "featureGauge" "statisticGauge"
#>  .. @ allow_na: logi TRUE

# Built for you by the public API.
arc_gauge(datasets::penguins, body_mass, stat = "mean")@webchart
#> <arcgisviz::WebGaugeChart>
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
#>  @ axes                        :List of 1
#>  .. $ : <arcgisviz::WebChartGaugeAxis>
#>  ..  ..@ type                      : chr "chartAxis"
#>  ..  ..@ visible                   : logi NA
#>  ..  ..@ isLogarithmic             : logi NA
#>  ..  ..@ title                     : <arcgisviz::WebChartText>
#>  .. .. .. @ type   : chr "chartText"
#>  .. .. .. @ visible: logi NA
#>  .. .. .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. .. .. @ type               : chr "esriTS"
#>  .. .. .. .. @ style              : chr NA
#>  .. .. .. .. @ text               : chr "mean(body_mass)"
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
#>  ..  ..@ valueFormat               : <arcgisviz::NumberFormatOptions>
#>  .. .. .. @ type       : chr NA
#>  .. .. .. @ intlOptions: <arcgisviz::IntlNumberFormatOptions>
#>  .. .. .. .. @ localeMatcher           : <arcgisviz::IntlLocaleMatcher>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ style                   : <arcgisviz::IntlNumberFormatOptionsStyle>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "currency" "decimal" "percent" "unit"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ currency                : chr NA
#>  .. .. .. .. @ currencyDisplay         : <arcgisviz::IntlNumberFormatOptionsCurrencyDisplay>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "code" "name" "narrowSymbol" "symbol"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ useGrouping             : logi NA
#>  .. .. .. .. @ minimumIntegerDigits    : num NA
#>  .. .. .. .. @ minimumFractionDigits   : num NA
#>  .. .. .. .. @ maximumFractionDigits   : num NA
#>  .. .. .. .. @ minimumSignificantDigits: num NA
#>  .. .. .. .. @ maximumSignificantDigits: num NA
#>  .. .. .. .. @ numberingSystem         : chr NA
#>  .. .. .. .. @ compactDisplay          : <arcgisviz::IntlNumberFormatOptionsCompactDisplay>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:2] "long" "short"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ notation                : <arcgisviz::IntlNumberFormatOptionsNotation>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "compact" "engineering" "scientific" "standard"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ signDisplay             : <arcgisviz::IntlNumberFormatOptionsSignDisplay>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:4] "always" "auto" "exceptZero" "never"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ unit                    : chr NA
#>  .. .. .. .. @ unitDisplay             : <arcgisviz::IntlFormatWidth>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. @ currencySign            : <arcgisviz::IntlNumberFormatOptionsCurrencySign>
#>  .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. @ variants: chr [1:2] "accounting" "standard"
#>  .. .. .. .. .. @ allow_na: logi TRUE
#>  ..  ..@ minimum                   : num NA
#>  ..  ..@ maximum                   : num NA
#>  ..  ..@ grid                      : NULL
#>  ..  ..@ guides                    : list()
#>  ..  ..@ lineSymbol                : NULL
#>  ..  ..@ labels                    : <arcgisviz::WebChartText>
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
#>  ..  ..@ scrollbar                 : NULL
#>  ..  ..@ displayZeroLine           : logi NA
#>  ..  ..@ integerOnlyValues         : logi NA
#>  ..  ..@ displayCursorTooltip      : logi NA
#>  ..  ..@ buffer                    : logi NA
#>  ..  ..@ tickSpacing               : num NA
#>  ..  ..@ dateBaseInterval          : NULL
#>  ..  ..@ innerLabel                : NULL
#>  ..  ..@ needle                    : NULL
#>  ..  ..@ ticks                     : NULL
#>  ..  ..@ labelsIncrement           : num NA
#>  ..  ..@ onlyShowFirstAndLastLabels: logi NA
#>  ..  ..@ minimumValueConversion    : NULL
#>  ..  ..@ maximumValueConversion    : NULL
#>  ..  ..@ minimumFromField          : chr NA
#>  ..  ..@ maximumFromField          : chr NA
#>  ..  ..@ progressBands             : NULL
#>  @ horizontalAxisLabelsBehavior: <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ verticalAxisLabelsBehavior  : <arcgisviz::WebChartLabelBehavior>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "hide" "rotate" "stagger" "wrap"
#>  .. @ allow_na: logi TRUE
#>  @ series                      :List of 1
#>  .. $ : <arcgisviz::WebChartGaugeSeries>
#>  ..  ..@ type                    : chr "gaugeSeries"
#>  ..  ..@ id                      : chr "series1"
#>  ..  ..@ visible                 : logi NA
#>  ..  ..@ dataTooltipVisible      : logi NA
#>  ..  ..@ dataTooltipReverseColor : logi NA
#>  ..  ..@ dataTooltipValueFormat  : NULL
#>  ..  ..@ dataTooltipPercentFormat: NULL
#>  ..  ..@ dataTooltipDateFormat   : NULL
#>  ..  ..@ dataTooltipFontSize     : num NA
#>  ..  ..@ name                    : chr "mean(body_mass)"
#>  ..  ..@ query                   : <arcgisviz::WebChartSeriesQuery>
#>  .. .. .. @ outFields                 : chr(0) 
#>  .. .. .. @ where                     : chr NA
#>  .. .. .. @ groupByFieldsForStatistics: chr(0) 
#>  .. .. .. @ outStatistics             :List of 1
#>  .. .. .. .. $ : <arcgisviz::IStatisticDefinition>
#>  .. .. .. ..  ..@ statisticType        : <arcgisviz::IStatisticDefinitionStatisticType>
#>  .. .. .. .. .. .. @ value   : chr "avg"
#>  .. .. .. .. .. .. @ variants: chr [1:12] "avg" "centroid-aggregate" "convex-hull-aggregate" "count" ...
#>  .. .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. ..  ..@ statisticParameters  : NULL
#>  .. .. .. ..  ..@ onStatisticField     : chr "body_mass"
#>  .. .. .. ..  ..@ outStatisticFieldName: chr "AVG_BODY_MASS_0"
#>  .. .. .. @ returnDistinctValues      : logi NA
#>  .. .. .. @ fetchNullValues           : logi NA
#>  ..  ..@ x                       : chr "AVG_BODY_MASS_0"
#>  ..  ..@ dataLabels              : NULL
#>  ..  ..@ assignToSecondValueAxis : logi NA
#>  ..  ..@ valueConversion         : NULL
#>  ..  ..@ featureIndex            : num NA
#>  @ rotated                     : logi NA
#>  @ stackedType                 : <arcgisviz::WebChartStackedKinds>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "sideBySide" "stacked" "stacked100"
#>  .. @ allow_na: logi TRUE
#>  @ colorMatch                  : logi NA
#>  @ chartRenderer               : NULL
#>  @ orderOptions                : NULL
#>  @ iLayer                      : NULL
#>  @ innerRadius                 : num NA
#>  @ startAngle                  : num NA
#>  @ endAngle                    : num NA
#>  @ subType                     : <arcgisviz::GaugeChartSubTypes>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "featureGauge" "statisticGauge"
#>  .. @ allow_na: logi TRUE
```
