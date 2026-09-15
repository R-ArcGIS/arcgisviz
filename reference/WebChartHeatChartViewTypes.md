# WebChartHeatChartViewTypes

One of `"SingleCalendarView"`, `"SequentialCalendarViews"`, `NA`.

## Usage

``` r
WebChartHeatChartViewTypes(value = NA_character_)
```

## Arguments

- value:

  String. One of `"SingleCalendarView"`, `"SequentialCalendarViews"`,
  `NA`.

## Value

An object of class `WebChartHeatChartViewTypes`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
WebChartHeatChartViewTypes("SingleCalendarView")
#> <arcgisviz::WebChartHeatChartViewTypes>
#>  @ value   : chr "SingleCalendarView"
#>  @ variants: chr [1:2] "SingleCalendarView" "SequentialCalendarViews"
#>  @ allow_na: logi TRUE
```
