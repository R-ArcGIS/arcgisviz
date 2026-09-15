# WebChartTemporalBinningUnits

One of `"days"`, `"hours"`, `"minutes"`, `"months"`, `"quarters"`,
`"seconds"`, `"weeks"`, `"years"`, `NA`.

## Usage

``` r
WebChartTemporalBinningUnits(value = NA_character_)
```

## Arguments

- value:

  String. One of `"days"`, `"hours"`, `"minutes"`, `"months"`,
  `"quarters"`, `"seconds"`, `"weeks"`, `"years"`, `NA`.

## Value

An object of class `WebChartTemporalBinningUnits`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartTemporalBinningUnits("days")
#> <arcgisviz::WebChartTemporalBinningUnits>
#>  @ value   : chr "days"
#>  @ variants: chr [1:8] "days" "hours" "minutes" "months" "quarters" "seconds" ...
#>  @ allow_na: logi TRUE
```
