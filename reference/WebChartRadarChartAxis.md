# WebChartRadarChartAxis

A
[`WebChartAxis()`](http://r.esri.com/arcgisviz/reference/WebChartAxis.md)
with the label orientation only a circular axis needs.

## Value

An object of class `WebChartRadarChartAxis`.

## Examples

``` r
WebChartRadarChartAxis(
  type = "chartAxis",
  labelsOrientation = WebChartRadarChartAxisLabelsOrientation("circular")
)
#> <arcgisviz::WebChartRadarChartAxis>
#>  @ type                : chr "chartAxis"
#>  @ visible             : logi NA
#>  @ isLogarithmic       : logi NA
#>  @ title               : NULL
#>  @ valueFormat         : <arcgisviz::NumberFormatOptions>
#>  .. @ type       : chr NA
#>  .. @ intlOptions: <arcgisviz::IntlNumberFormatOptions>
#>  .. .. @ localeMatcher           : <arcgisviz::IntlLocaleMatcher>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ style                   : <arcgisviz::IntlNumberFormatOptionsStyle>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "currency" "decimal" "percent" "unit"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ currency                : chr NA
#>  .. .. @ currencyDisplay         : <arcgisviz::IntlNumberFormatOptionsCurrencyDisplay>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "code" "name" "narrowSymbol" "symbol"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ useGrouping             : logi NA
#>  .. .. @ minimumIntegerDigits    : num NA
#>  .. .. @ minimumFractionDigits   : num NA
#>  .. .. @ maximumFractionDigits   : num NA
#>  .. .. @ minimumSignificantDigits: num NA
#>  .. .. @ maximumSignificantDigits: num NA
#>  .. .. @ numberingSystem         : chr NA
#>  .. .. @ compactDisplay          : <arcgisviz::IntlNumberFormatOptionsCompactDisplay>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:2] "long" "short"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ notation                : <arcgisviz::IntlNumberFormatOptionsNotation>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "compact" "engineering" "scientific" ...
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ signDisplay             : <arcgisviz::IntlNumberFormatOptionsSignDisplay>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "always" "auto" "exceptZero" "never"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ unit                    : chr NA
#>  .. .. @ unitDisplay             : <arcgisviz::IntlFormatWidth>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ currencySign            : <arcgisviz::IntlNumberFormatOptionsCurrencySign>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:2] "accounting" "standard"
#>  .. .. .. @ allow_na: logi TRUE
#>  @ minimum             : num NA
#>  @ maximum             : num NA
#>  @ grid                : NULL
#>  @ guides              : list()
#>  @ lineSymbol          : NULL
#>  @ labels              : <arcgisviz::WebChartText>
#>  .. @ type   : chr NA
#>  .. @ visible: logi NA
#>  .. @ content: <arcgisviz::WebChartTextSymbol>
#>  .. .. @ type               : chr NA
#>  .. .. @ style              : chr NA
#>  .. .. @ text               : chr NA
#>  .. .. @ color              : NULL
#>  .. .. @ backgroundColor    : NULL
#>  .. .. @ borderLineSize     : num NA
#>  .. .. @ borderLineColor    : NULL
#>  .. .. @ haloSize           : num NA
#>  .. .. @ haloColor          : NULL
#>  .. .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. .. @ value   : chr NA
#>  .. .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. .. @ allow_na: logi TRUE
#>  .. .. @ rightToLeft        : logi NA
#>  .. .. @ kerning            : logi NA
#>  .. .. @ font               : NULL
#>  .. .. @ angle              : num NA
#>  .. .. @ xoffset            : chr NA
#>  .. .. @ yoffset            : chr NA
#>  @ scrollbar           : NULL
#>  @ displayZeroLine     : logi NA
#>  @ integerOnlyValues   : logi NA
#>  @ displayCursorTooltip: logi NA
#>  @ buffer              : logi NA
#>  @ tickSpacing         : num NA
#>  @ dateBaseInterval    : NULL
#>  @ labelsOrientation   : <arcgisviz::WebChartRadarChartAxisLabelsOrientation>
#>  .. @ value   : chr "circular"
#>  .. @ variants: chr [1:3] "radial" "circular" "horizontal"
#>  .. @ allow_na: logi TRUE
```
