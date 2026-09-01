# A chart specification

Holds a data frame and the mapping built up by the `set_*()` functions.
The `@webchart` property is computed from that mapping rather than
stored, so assigning to it has no effect.

## Usage

``` r
ArcChart(
  data = NULL,
  chart_type = NA_character_,
  x = NA_character_,
  y = NA_character_,
  stat = NA_character_,
  labs = list(),
  color = list(),
  size = list(),
  tooltip = character(0),
  axes = list(),
  legend = list(),
  flipped = NA,
  position = NA_character_,
  series_opts = list(),
  config_opts = list()
)
```

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

arc_col(df, species, mass)@webchart
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
#>  .. .. .. .. @ text               : chr "mass"
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
#>  ..  ..@ y                            : chr "mass"
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
#>  ..  ..@ name                         : chr "mass"
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
