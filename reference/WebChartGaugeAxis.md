# WebChartGaugeAxis

A
[`WebChartAxis()`](http://r.esri.com/arcgisviz/reference/WebChartAxis.md)
carrying the needle. A gauge has exactly one axis, and
[`set_axis()`](http://r.esri.com/arcgisviz/reference/set_axis.md)`("x")`
is it.

## Value

An object of class `WebChartGaugeAxis`.

## Examples

``` r
WebChartGaugeAxis(
  type = "chartAxis",
  minimum = 0,
  maximum = 250,
  needle = WebChartNeedle(visible = TRUE),
  ticks = WebChartGaugeAxisTick(visible = TRUE)
)
#> <arcgisviz::WebChartGaugeAxis>
#>  @ type                      : chr "chartAxis"
#>  @ visible                   : logi NA
#>  @ isLogarithmic             : logi NA
#>  @ title                     : NULL
#>  @ valueFormat               : <arcgisviz::NumberFormatOptions>
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
#>  @ minimum                   : num 0
#>  @ maximum                   : num 250
#>  @ grid                      : NULL
#>  @ guides                    : list()
#>  @ lineSymbol                : NULL
#>  @ labels                    : <arcgisviz::WebChartText>
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
#>  @ scrollbar                 : NULL
#>  @ displayZeroLine           : logi NA
#>  @ integerOnlyValues         : logi NA
#>  @ displayCursorTooltip      : logi NA
#>  @ buffer                    : logi NA
#>  @ tickSpacing               : num NA
#>  @ dateBaseInterval          : NULL
#>  @ innerLabel                : NULL
#>  @ needle                    : <arcgisviz::WebChartNeedle>
#>  .. @ type       : chr NA
#>  .. @ visible    : logi TRUE
#>  .. @ symbol     : NULL
#>  .. @ startWidth : num NA
#>  .. @ endWidth   : num NA
#>  .. @ innerRadius: num NA
#>  .. @ displayPin : logi NA
#>  @ ticks                     : <arcgisviz::WebChartGaugeAxisTick>
#>  .. @ type   : chr NA
#>  .. @ visible: logi TRUE
#>  @ labelsIncrement           : num NA
#>  @ onlyShowFirstAndLastLabels: logi NA
#>  @ minimumValueConversion    : NULL
#>  @ maximumValueConversion    : NULL
#>  @ minimumFromField          : chr NA
#>  @ maximumFromField          : chr NA
#>  @ progressBands             : NULL
```
