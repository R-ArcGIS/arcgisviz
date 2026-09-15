# IntlNumberFormatOptions

Mirrors JavaScript's own `Intl.NumberFormat` options object.

## Usage

``` r
IntlNumberFormatOptions(
  localeMatcher = IntlLocaleMatcher(),
  style = IntlNumberFormatOptionsStyle(),
  currency = NA_character_,
  currencyDisplay = IntlNumberFormatOptionsCurrencyDisplay(),
  useGrouping = NA,
  minimumIntegerDigits = NA_real_,
  minimumFractionDigits = NA_real_,
  maximumFractionDigits = NA_real_,
  minimumSignificantDigits = NA_real_,
  maximumSignificantDigits = NA_real_,
  numberingSystem = NA_character_,
  compactDisplay = IntlNumberFormatOptionsCompactDisplay(),
  notation = IntlNumberFormatOptionsNotation(),
  signDisplay = IntlNumberFormatOptionsSignDisplay(),
  unit = NA_character_,
  unitDisplay = IntlFormatWidth(),
  currencySign = IntlNumberFormatOptionsCurrencySign()
)
```

## Arguments

- localeMatcher:

  A `IntlLocaleMatcher` enum.

- style:

  A `IntlNumberFormatOptionsStyle` enum.

- currency:

  String.

- currencyDisplay:

  A `IntlNumberFormatOptionsCurrencyDisplay` enum.

- useGrouping:

  Bool.

- minimumIntegerDigits:

  Number.

- minimumFractionDigits:

  Number.

- maximumFractionDigits:

  Number.

- minimumSignificantDigits:

  Number.

- maximumSignificantDigits:

  Number.

- numberingSystem:

  String.

- compactDisplay:

  A `IntlNumberFormatOptionsCompactDisplay` enum.

- notation:

  A `IntlNumberFormatOptionsNotation` enum.

- signDisplay:

  A `IntlNumberFormatOptionsSignDisplay` enum.

- unit:

  String.

- unitDisplay:

  A `IntlFormatWidth` enum.

- currencySign:

  A `IntlNumberFormatOptionsCurrencySign` enum.

## Value

An object of class `IntlNumberFormatOptions`.

## Examples

``` r
IntlNumberFormatOptions(
  style = IntlNumberFormatOptionsStyle("decimal"),
  useGrouping = TRUE,
  maximumFractionDigits = 1
)
#> <arcgisviz::IntlNumberFormatOptions>
#>  @ localeMatcher           : <arcgisviz::IntlLocaleMatcher>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. @ allow_na: logi TRUE
#>  @ style                   : <arcgisviz::IntlNumberFormatOptionsStyle>
#>  .. @ value   : chr "decimal"
#>  .. @ variants: chr [1:4] "currency" "decimal" "percent" "unit"
#>  .. @ allow_na: logi TRUE
#>  @ currency                : chr NA
#>  @ currencyDisplay         : <arcgisviz::IntlNumberFormatOptionsCurrencyDisplay>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "code" "name" "narrowSymbol" "symbol"
#>  .. @ allow_na: logi TRUE
#>  @ useGrouping             : logi TRUE
#>  @ minimumIntegerDigits    : num NA
#>  @ minimumFractionDigits   : num NA
#>  @ maximumFractionDigits   : num 1
#>  @ minimumSignificantDigits: num NA
#>  @ maximumSignificantDigits: num NA
#>  @ numberingSystem         : chr NA
#>  @ compactDisplay          : <arcgisviz::IntlNumberFormatOptionsCompactDisplay>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "long" "short"
#>  .. @ allow_na: logi TRUE
#>  @ notation                : <arcgisviz::IntlNumberFormatOptionsNotation>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "compact" "engineering" "scientific" "standard"
#>  .. @ allow_na: logi TRUE
#>  @ signDisplay             : <arcgisviz::IntlNumberFormatOptionsSignDisplay>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "always" "auto" "exceptZero" "never"
#>  .. @ allow_na: logi TRUE
#>  @ unit                    : chr NA
#>  @ unitDisplay             : <arcgisviz::IntlFormatWidth>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. @ allow_na: logi TRUE
#>  @ currencySign            : <arcgisviz::IntlNumberFormatOptionsCurrencySign>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "accounting" "standard"
#>  .. @ allow_na: logi TRUE
```
