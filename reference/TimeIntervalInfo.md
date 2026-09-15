# TimeIntervalInfo

TimeIntervalInfo

## Usage

``` r
TimeIntervalInfo(unit = WebChartTemporalBinningUnits(), size = NA_real_)
```

## Arguments

- unit:

  A `WebChartTemporalBinningUnits` enum.

- size:

  Number.

## Value

An object of class `TimeIntervalInfo`.

## Examples

``` r
TimeIntervalInfo(unit = WebChartTemporalBinningUnits("months"), size = 3)
#> <arcgisviz::TimeIntervalInfo>
#>  @ unit: <arcgisviz::WebChartTemporalBinningUnits>
#>  .. @ value   : chr "months"
#>  .. @ variants: chr [1:8] "days" "hours" "minutes" "months" "quarters" "seconds" ...
#>  .. @ allow_na: logi TRUE
#>  @ size: num 3
```
