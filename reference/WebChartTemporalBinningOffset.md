# WebChartTemporalBinningOffset

Shifts where temporal bins start - a fiscal year beginning in April
rather than January, say.

## Usage

``` r
WebChartTemporalBinningOffset(
  unit = WebChartTemporalBinningUnits(),
  size = NA_real_
)
```

## Arguments

- unit:

  A `WebChartTemporalBinningUnits` enum.

- size:

  Number.

## Value

An object of class `WebChartTemporalBinningOffset`.

## Examples

``` r
WebChartTemporalBinningOffset(
  unit = WebChartTemporalBinningUnits("months"),
  size = 3
)
#> <arcgisviz::WebChartTemporalBinningOffset>
#>  @ unit: <arcgisviz::WebChartTemporalBinningUnits>
#>  .. @ value   : chr "months"
#>  .. @ variants: chr [1:8] "days" "hours" "minutes" "months" "quarters" "seconds" ...
#>  .. @ allow_na: logi TRUE
#>  @ size: num 3
```
