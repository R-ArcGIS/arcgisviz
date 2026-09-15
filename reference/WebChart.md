# WebChart

The root of a chart's JSON config - the shape the ArcGIS Maps SDK's
chart component reads. Every
[`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md)
pipeline builds one of these, and `chart@webchart` is where it lands.

## Usage

``` r
WebChart(
  version = NA_character_,
  type = NA_character_,
  id = NA_character_,
  dataFilters = NULL,
  title = NULL,
  subtitle = NULL,
  footer = NULL,
  background = NULL,
  cursorCrosshair = NULL,
  legend = NULL,
  axes = list(),
  horizontalAxisLabelsBehavior = WebChartLabelBehavior(),
  verticalAxisLabelsBehavior = WebChartLabelBehavior(),
  series = list(),
  rotated = NA,
  stackedType = WebChartStackedKinds(),
  colorMatch = NA,
  chartRenderer = NULL,
  orderOptions = NULL,
  iLayer = NULL
)
```

## Arguments

- version:

  String.

- type:

  String.

- id:

  String.

- dataFilters:

  `NULL` or a `WebChartDataFilters` object.

- title:

  `NULL` or a `WebChartText` object.

- subtitle:

  `NULL` or a `WebChartText` object.

- footer:

  `NULL` or a `WebChartText` object.

- background:

  `NULL` or a `Color` object.

- cursorCrosshair:

  `NULL` or a `WebChartCursorCrosshair` object.

- legend:

  `NULL` or a `WebChartLegend` object.

- axes:

  List.

- horizontalAxisLabelsBehavior:

  A `WebChartLabelBehavior` enum.

- verticalAxisLabelsBehavior:

  A `WebChartLabelBehavior` enum.

- series:

  List.

- rotated:

  Bool.

- stackedType:

  A `WebChartStackedKinds` enum.

- colorMatch:

  Bool.

- chartRenderer:

  `NULL` or a `ISimpleRenderer` object or a `IUniqueValueRenderer`
  object.

- orderOptions:

  `NULL` or a `WebChartOrderOptions` object.

- iLayer:

  `NULL` or a `IFeatureLayer` object.

## Value

An object of class `WebChart`.

## Details

Unset properties are dropped rather than sent as `null`, so a sparse
config falls back to the browser's own defaults instead of overriding
them.

## Examples

``` r
# Built for you by the public API.
arc_bar(datasets::penguins, species)@webchart
#> <arcgisviz::WebChart>
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
#>  ..  ..@ valueFormat         : <arcgisviz::NumberFormatOptions>
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
#>  .. .. .. .. @ text               : chr "count"
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
#>  ..  ..@ valueFormat         : <arcgisviz::NumberFormatOptions>
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
#>  .. $ : <arcgisviz::WebChartBarChartSeries>
#>  ..  ..@ type                         : chr "barSeries"
#>  ..  ..@ y                            : chr "COUNT_OBJECT_ID_0"
#>  ..  ..@ fillSymbol                   : NULL
#>  ..  ..@ hideOversizedStackedLabels   : logi NA
#>  ..  ..@ hideOversizedSideBySideLabels: logi NA
#>  ..  ..@ nullCategory                 : NULL
#>  ..  ..@ id                           : chr "series1"
#>  ..  ..@ visible                      : logi NA
#>  ..  ..@ dataTooltipVisible           : logi NA
#>  ..  ..@ dataTooltipReverseColor      : logi NA
#>  ..  ..@ dataTooltipValueFormat       : NULL
#>  ..  ..@ dataTooltipPercentFormat     : NULL
#>  ..  ..@ dataTooltipDateFormat        : NULL
#>  ..  ..@ dataTooltipFontSize          : num NA
#>  ..  ..@ name                         : chr "count"
#>  ..  ..@ query                        : <arcgisviz::WebChartSeriesQuery>
#>  .. .. .. @ outFields                 : chr(0) 
#>  .. .. .. @ where                     : chr NA
#>  .. .. .. @ groupByFieldsForStatistics: 'AsIs' chr "species"
#>  .. .. .. @ outStatistics             :List of 1
#>  .. .. .. .. $ : <arcgisviz::IStatisticDefinition>
#>  .. .. .. ..  ..@ statisticType        : <arcgisviz::IStatisticDefinitionStatisticType>
#>  .. .. .. .. .. .. @ value   : chr "count"
#>  .. .. .. .. .. .. @ variants: chr [1:12] "avg" "centroid-aggregate" "convex-hull-aggregate" "count" ...
#>  .. .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. ..  ..@ statisticParameters  : NULL
#>  .. .. .. ..  ..@ onStatisticField     : chr "object_id"
#>  .. .. .. ..  ..@ outStatisticFieldName: chr "COUNT_OBJECT_ID_0"
#>  .. .. .. @ returnDistinctValues      : logi NA
#>  .. .. .. @ fetchNullValues           : logi NA
#>  ..  ..@ x                            : chr "species"
#>  ..  ..@ dataLabels                   : NULL
#>  ..  ..@ assignToSecondValueAxis      : logi NA
#>  ..  ..@ binTemporalData              : logi NA
#>  ..  ..@ temporalBinning              : NULL
#>  @ rotated                     : logi NA
#>  @ stackedType                 : <arcgisviz::WebChartStackedKinds>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "sideBySide" "stacked" "stacked100"
#>  .. @ allow_na: logi TRUE
#>  @ colorMatch                  : logi NA
#>  @ chartRenderer               : NULL
#>  @ orderOptions                : NULL
#>  @ iLayer                      : NULL

# Or by hand.
WebChart(
  version = "18.1.0",
  type = "barChart",
  series = list(
    WebChartBarChartSeries(type = "barSeries", x = "species", y = "count")
  ),
  axes = list(
    WebChartAxis(type = "chartAxis"),
    WebChartAxis(type = "chartAxis")
  )
)
#> <arcgisviz::WebChart>
#>  @ version                     : chr "18.1.0"
#>  @ type                        : chr "barChart"
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
#>  ..  ..@ title               : NULL
#>  ..  ..@ valueFormat         : <arcgisviz::NumberFormatOptions>
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
#>  ..  ..@ title               : NULL
#>  ..  ..@ valueFormat         : <arcgisviz::NumberFormatOptions>
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
#>  .. $ : <arcgisviz::WebChartBarChartSeries>
#>  ..  ..@ type                         : chr "barSeries"
#>  ..  ..@ y                            : chr "count"
#>  ..  ..@ fillSymbol                   : NULL
#>  ..  ..@ hideOversizedStackedLabels   : logi NA
#>  ..  ..@ hideOversizedSideBySideLabels: logi NA
#>  ..  ..@ nullCategory                 : NULL
#>  ..  ..@ id                           : chr NA
#>  ..  ..@ visible                      : logi NA
#>  ..  ..@ dataTooltipVisible           : logi NA
#>  ..  ..@ dataTooltipReverseColor      : logi NA
#>  ..  ..@ dataTooltipValueFormat       : NULL
#>  ..  ..@ dataTooltipPercentFormat     : NULL
#>  ..  ..@ dataTooltipDateFormat        : NULL
#>  ..  ..@ dataTooltipFontSize          : num NA
#>  ..  ..@ name                         : chr NA
#>  ..  ..@ query                        : NULL
#>  ..  ..@ x                            : chr "species"
#>  ..  ..@ dataLabels                   : NULL
#>  ..  ..@ assignToSecondValueAxis      : logi NA
#>  ..  ..@ binTemporalData              : logi NA
#>  ..  ..@ temporalBinning              : NULL
#>  @ rotated                     : logi NA
#>  @ stackedType                 : <arcgisviz::WebChartStackedKinds>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "sideBySide" "stacked" "stacked100"
#>  .. @ allow_na: logi TRUE
#>  @ colorMatch                  : logi NA
#>  @ chartRenderer               : NULL
#>  @ orderOptions                : NULL
#>  @ iLayer                      : NULL
```
