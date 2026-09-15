# WebChartCalendarDatePartsBinning

Bins a date column by a part of the calendar rather than by an
interval - every Monday together, every January together. Modelled, but
nothing in the public API sets it: a heat series with this takes the
client's calendar branch instead of the matrix one.

## Value

An object of class `WebChartCalendarDatePartsBinning`.

## Examples

``` r
WebChartCalendarDatePartsBinning(
  type = "calendarDatePartsBinning",
  unit = WebChartCalendarDatePartsUnits("dayOfWeek")
)
#> <arcgisviz::WebChartCalendarDatePartsBinning>
#>  @ trimIncompleteTimeInterval: logi NA
#>  @ start                     : num NA
#>  @ end                       : num NA
#>  @ offset                    : NULL
#>  @ type                      : chr "calendarDatePartsBinning"
#>  @ unit                      : <arcgisviz::WebChartCalendarDatePartsUnits>
#>  .. @ value   : chr "dayOfWeek"
#>  .. @ variants: chr [1:8] "dayOfMonth" "dayOfWeek" "dayOfYear" "hourOfDay" ...
#>  .. @ allow_na: logi TRUE
```
