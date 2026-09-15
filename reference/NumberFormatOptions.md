# NumberFormatOptions

How a numeric axis or label formats its values.

## Usage

``` r
NumberFormatOptions(
  type = NA_character_,
  intlOptions = IntlNumberFormatOptions()
)
```

## Arguments

- type:

  String.

- intlOptions:

  A `IntlNumberFormatOptions` object.

## Value

An object of class `NumberFormatOptions`.

## Examples

``` r
NumberFormatOptions(
  type = "number",
  intlOptions = IntlNumberFormatOptions(
    useGrouping = TRUE,
    maximumFractionDigits = 0
  )
)
#> <arcgisviz::NumberFormatOptions>
#>  @ type       : chr "number"
#>  @ intlOptions: <arcgisviz::IntlNumberFormatOptions>
#>  .. @ localeMatcher           : <arcgisviz::IntlLocaleMatcher>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ style                   : <arcgisviz::IntlNumberFormatOptionsStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "currency" "decimal" "percent" "unit"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ currency                : chr NA
#>  .. @ currencyDisplay         : <arcgisviz::IntlNumberFormatOptionsCurrencyDisplay>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "code" "name" "narrowSymbol" "symbol"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ useGrouping             : logi TRUE
#>  .. @ minimumIntegerDigits    : num NA
#>  .. @ minimumFractionDigits   : num NA
#>  .. @ maximumFractionDigits   : num 0
#>  .. @ minimumSignificantDigits: num NA
#>  .. @ maximumSignificantDigits: num NA
#>  .. @ numberingSystem         : chr NA
#>  .. @ compactDisplay          : <arcgisviz::IntlNumberFormatOptionsCompactDisplay>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "long" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ notation                : <arcgisviz::IntlNumberFormatOptionsNotation>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "compact" "engineering" "scientific" "standard"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ signDisplay             : <arcgisviz::IntlNumberFormatOptionsSignDisplay>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "always" "auto" "exceptZero" "never"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ unit                    : chr NA
#>  .. @ unitDisplay             : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ currencySign            : <arcgisviz::IntlNumberFormatOptionsCurrencySign>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "accounting" "standard"
#>  .. .. @ allow_na: logi TRUE
```
