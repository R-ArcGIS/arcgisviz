# WebChartOrderSeriesBy

WebChartOrderSeriesBy

## Usage

``` r
WebChartOrderSeriesBy(preferLabel = NA, orderBy = WebChartSortOrderKinds())
```

## Arguments

- preferLabel:

  Bool.

- orderBy:

  A `WebChartSortOrderKinds` enum.

## Value

An object of class `WebChartOrderSeriesBy`.

## Examples

``` r
WebChartOrderSeriesBy(
  preferLabel = TRUE,
  orderBy = WebChartSortOrderKinds("DESC")
)
#> <arcgisviz::WebChartOrderSeriesBy>
#>  @ preferLabel: logi TRUE
#>  @ orderBy    : <arcgisviz::WebChartSortOrderKinds>
#>  .. @ value   : chr "DESC"
#>  .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. @ allow_na: logi TRUE
```
