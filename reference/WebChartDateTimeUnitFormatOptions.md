# WebChartDateTimeUnitFormatOptions

A different date format per time unit, so an axis that zooms from years
to hours relabels itself as it goes.

## Usage

``` r
WebChartDateTimeUnitFormatOptions(
  year = NULL,
  month = NULL,
  day = NULL,
  hour = NULL,
  minute = NULL,
  second = NULL
)
```

## Arguments

- year:

  `NULL` or a `IntlDateTimeFormatOptions` object.

- month:

  `NULL` or a `IntlDateTimeFormatOptions` object.

- day:

  `NULL` or a `IntlDateTimeFormatOptions` object.

- hour:

  `NULL` or a `IntlDateTimeFormatOptions` object.

- minute:

  `NULL` or a `IntlDateTimeFormatOptions` object.

- second:

  `NULL` or a `IntlDateTimeFormatOptions` object.

## Value

An object of class `WebChartDateTimeUnitFormatOptions`.

## Examples

``` r
WebChartDateTimeUnitFormatOptions(
  year = IntlDateTimeFormatOptions(
    year = IntlDateTimeDigitStyle("numeric")
  ),
  month = IntlDateTimeFormatOptions(
    month = IntlDateTimeFormatOptionsMonth("short")
  )
)
#> <arcgisviz::WebChartDateTimeUnitFormatOptions>
#>  @ year  : <arcgisviz::IntlDateTimeFormatOptions>
#>  .. @ localeMatcher         : <arcgisviz::IntlLocaleMatcher>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ weekday               : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ era                   : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ year                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr "numeric"
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ month                 : <arcgisviz::IntlDateTimeFormatOptionsMonth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:5] "2-digit" "long" "narrow" "numeric" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ day                   : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hour                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ minute                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ second                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ timeZoneName          : <arcgisviz::IntlDateTimeFormatOptionsTimeZoneName>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "long" "longGeneric" "longOffset" "short" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ formatMatcher         : <arcgisviz::IntlDateTimeFormatOptionsFormatMatcher>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "basic" "best fit"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hour12                : logi NA
#>  .. @ timeZone              : chr NA
#>  .. @ calendar              : chr NA
#>  .. @ dayPeriod             : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ numberingSystem       : chr NA
#>  .. @ dateStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ timeStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hourCycle             : <arcgisviz::IntlDateTimeFormatOptionsHourCycle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "h11" "h12" "h23" "h24"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ fractionalSecondDigits: int NA
#>  @ month : <arcgisviz::IntlDateTimeFormatOptions>
#>  .. @ localeMatcher         : <arcgisviz::IntlLocaleMatcher>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "best fit" "lookup"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ weekday               : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ era                   : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ year                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ month                 : <arcgisviz::IntlDateTimeFormatOptionsMonth>
#>  .. .. @ value   : chr "short"
#>  .. .. @ variants: chr [1:5] "2-digit" "long" "narrow" "numeric" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ day                   : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hour                  : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ minute                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ second                : <arcgisviz::IntlDateTimeDigitStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "2-digit" "numeric"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ timeZoneName          : <arcgisviz::IntlDateTimeFormatOptionsTimeZoneName>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "long" "longGeneric" "longOffset" "short" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ formatMatcher         : <arcgisviz::IntlDateTimeFormatOptionsFormatMatcher>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "basic" "best fit"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hour12                : logi NA
#>  .. @ timeZone              : chr NA
#>  .. @ calendar              : chr NA
#>  .. @ dayPeriod             : <arcgisviz::IntlFormatWidth>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "long" "narrow" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ numberingSystem       : chr NA
#>  .. @ dateStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ timeStyle             : <arcgisviz::IntlDateTimeFormatLength>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "full" "long" "medium" "short"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ hourCycle             : <arcgisviz::IntlDateTimeFormatOptionsHourCycle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "h11" "h12" "h23" "h24"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ fractionalSecondDigits: int NA
#>  @ day   : NULL
#>  @ hour  : NULL
#>  @ minute: NULL
#>  @ second: NULL
```
