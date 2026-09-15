# WebChartTimeAggregationTypes

One of `"equalIntervalsFromEndTime"`, `"equalIntervalsFromStartTime"`,
`NA`.

## Usage

``` r
WebChartTimeAggregationTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"equalIntervalsFromEndTime"`,
  `"equalIntervalsFromStartTime"`, `NA`.

## Value

An object of class `WebChartTimeAggregationTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartTimeAggregationTypes("equalIntervalsFromEndTime")
#> <arcgisviz::WebChartTimeAggregationTypes>
#>  @ value   : chr "equalIntervalsFromEndTime"
#>  @ variants: chr [1:2] "equalIntervalsFromEndTime" "equalIntervalsFromStartTime"
#>  @ allow_na: logi TRUE
```
