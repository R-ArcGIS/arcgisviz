# WebChartTemporalBinning

Groups a date column into intervals before plotting it.

## Usage

``` r
WebChartTemporalBinning(
  unit = WebChartTemporalBinningUnits(),
  size = NA_real_,
  timeAggregationType = WebChartTimeAggregationTypes(),
  trimIncompleteTimeInterval = NA,
  start = NA_real_,
  end = NA_real_,
  offset = NULL,
  outTimeZone = NA_character_,
  firstDayOfWeek = NA_real_,
  nullPolicy = WebChartNullPolicyTypes()
)
```

## Arguments

- unit:

  A `WebChartTemporalBinningUnits` enum.

- size:

  Number.

- timeAggregationType:

  A `WebChartTimeAggregationTypes` enum.

- trimIncompleteTimeInterval:

  Bool.

- start:

  Number.

- end:

  Number.

- offset:

  `NULL` or a `WebChartTemporalBinningOffset` object.

- outTimeZone:

  String.

- firstDayOfWeek:

  Number.

- nullPolicy:

  A `WebChartNullPolicyTypes` enum.

## Value

An object of class `WebChartTemporalBinning`.

## Examples

``` r
WebChartTemporalBinning(
  unit = WebChartTemporalBinningUnits("months"),
  size = 1,
  trimIncompleteTimeInterval = TRUE,
  nullPolicy = WebChartNullPolicyTypes("zero")
)
#> <arcgisviz::WebChartTemporalBinning>
#>  @ unit                      : <arcgisviz::WebChartTemporalBinningUnits>
#>  .. @ value   : chr "months"
#>  .. @ variants: chr [1:8] "days" "hours" "minutes" "months" "quarters" "seconds" ...
#>  .. @ allow_na: logi TRUE
#>  @ size                      : num 1
#>  @ timeAggregationType       : <arcgisviz::WebChartTimeAggregationTypes>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "equalIntervalsFromEndTime" ...
#>  .. @ allow_na: logi TRUE
#>  @ trimIncompleteTimeInterval: logi TRUE
#>  @ start                     : num NA
#>  @ end                       : num NA
#>  @ offset                    : NULL
#>  @ outTimeZone               : chr NA
#>  @ firstDayOfWeek            : num NA
#>  @ nullPolicy                : <arcgisviz::WebChartNullPolicyTypes>
#>  .. @ value   : chr "zero"
#>  .. @ variants: chr [1:3] "interpolate" "null" "zero"
#>  .. @ allow_na: logi TRUE
```
