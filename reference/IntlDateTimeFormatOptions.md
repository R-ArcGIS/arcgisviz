# IntlDateTimeFormatOptions

Mirrors JavaScript's own `Intl.DateTimeFormat` options object.

## Usage

``` r
IntlDateTimeFormatOptions(
  localeMatcher = IntlLocaleMatcher(),
  weekday = IntlFormatWidth(),
  era = IntlFormatWidth(),
  year = IntlDateTimeDigitStyle(),
  month = IntlDateTimeFormatOptionsMonth(),
  day = IntlDateTimeDigitStyle(),
  hour = IntlDateTimeDigitStyle(),
  minute = IntlDateTimeDigitStyle(),
  second = IntlDateTimeDigitStyle(),
  timeZoneName = IntlDateTimeFormatOptionsTimeZoneName(),
  formatMatcher = IntlDateTimeFormatOptionsFormatMatcher(),
  hour12 = NA,
  timeZone = NA_character_,
  calendar = NA_character_,
  dayPeriod = IntlFormatWidth(),
  numberingSystem = NA_character_,
  dateStyle = IntlDateTimeFormatLength(),
  timeStyle = IntlDateTimeFormatLength(),
  hourCycle = IntlDateTimeFormatOptionsHourCycle(),
  fractionalSecondDigits = NA_integer_
)
```

## Arguments

- localeMatcher:

  A `IntlLocaleMatcher` enum.

- weekday:

  A `IntlFormatWidth` enum.

- era:

  A `IntlFormatWidth` enum.

- year:

  A `IntlDateTimeDigitStyle` enum.

- month:

  A `IntlDateTimeFormatOptionsMonth` enum.

- day:

  A `IntlDateTimeDigitStyle` enum.

- hour:

  A `IntlDateTimeDigitStyle` enum.

- minute:

  A `IntlDateTimeDigitStyle` enum.

- second:

  A `IntlDateTimeDigitStyle` enum.

- timeZoneName:

  A `IntlDateTimeFormatOptionsTimeZoneName` enum.

- formatMatcher:

  A `IntlDateTimeFormatOptionsFormatMatcher` enum.

- hour12:

  Bool.

- timeZone:

  String.

- calendar:

  String.

- dayPeriod:

  A `IntlFormatWidth` enum.

- numberingSystem:

  String.

- dateStyle:

  A `IntlDateTimeFormatLength` enum.

- timeStyle:

  A `IntlDateTimeFormatLength` enum.

- hourCycle:

  A `IntlDateTimeFormatOptionsHourCycle` enum.

- fractionalSecondDigits:

  Number.

## Value

An object of class `IntlDateTimeFormatOptions`.

## Examples

``` r
IntlDateTimeFormatOptions(
  year = IntlDateTimeDigitStyle("numeric"),
  month = IntlDateTimeFormatOptionsMonth("short"),
  day = IntlDateTimeDigitStyle("2-digit")
)
#> <arcgisviz::IntlDateTimeFormatOptions>
#>  @ localeMatcher         : <arcgisviz::IntlLocaleMatcher>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. @ allow_na: logi TRUE
#>  @ weekday               : <arcgisviz::IntlFormatWidth>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. @ allow_na: logi TRUE
#>  @ era                   : <arcgisviz::IntlFormatWidth>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. @ allow_na: logi TRUE
#>  @ year                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. @ value   : chr "numeric"
#>  .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. @ allow_na: logi TRUE
#>  @ month                 : <arcgisviz::IntlDateTimeFormatOptionsMonth>
#>  .. @ value   : chr "short"
#>  .. @ variants: chr [1:5] "2-digit" "long" "narrow" "numeric" "short"
#>  .. @ allow_na: logi TRUE
#>  @ day                   : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. @ value   : chr "2-digit"
#>  .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. @ allow_na: logi TRUE
#>  @ hour                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. @ allow_na: logi TRUE
#>  @ minute                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. @ allow_na: logi TRUE
#>  @ second                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. @ allow_na: logi TRUE
#>  @ timeZoneName          : <arcgisviz::IntlDateTimeFormatOptionsTimeZoneName>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:6] "long" "longGeneric" "longOffset" "short" ...
#>  .. @ allow_na: logi TRUE
#>  @ formatMatcher         : <arcgisviz::IntlDateTimeFormatOptionsFormatMatcher>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "basic" "best fit"
#>  .. @ allow_na: logi TRUE
#>  @ hour12                : logi NA
#>  @ timeZone              : chr NA
#>  @ calendar              : chr NA
#>  @ dayPeriod             : <arcgisviz::IntlFormatWidth>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. @ allow_na: logi TRUE
#>  @ numberingSystem       : chr NA
#>  @ dateStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. @ allow_na: logi TRUE
#>  @ timeStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. @ allow_na: logi TRUE
#>  @ hourCycle             : <arcgisviz::IntlDateTimeFormatOptionsHourCycle>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "h11" "h12" "h23" "h24"
#>  .. @ allow_na: logi TRUE
#>  @ fractionalSecondDigits: int NA
```
