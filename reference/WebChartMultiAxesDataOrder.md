# WebChartMultiAxesDataOrder

WebChartMultiAxesDataOrder

## Usage

``` r
WebChartMultiAxesDataOrder(
  orderType = NA_character_,
  orderByX = NULL,
  orderByY = NULL
)
```

## Arguments

- orderType:

  String.

- orderByX:

  `NULL` or String or a `WebChartSortOrderKinds` enum.

- orderByY:

  `NULL` or String or a `WebChartSortOrderKinds` enum.

## Value

An object of class `WebChartMultiAxesDataOrder`.

## Examples

``` r
WebChartMultiAxesDataOrder(
  orderType = "arcgis-charts-multi-axes",
  orderByX = WebChartSortOrderKinds("ASC"),
  orderByY = WebChartSortOrderKinds("DESC")
)
#> <arcgisviz::WebChartMultiAxesDataOrder>
#>  @ orderType: chr "arcgis-charts-multi-axes"
#>  @ orderByX : <arcgisviz::WebChartSortOrderKinds>
#>  .. @ value   : chr "ASC"
#>  .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. @ allow_na: logi TRUE
#>  @ orderByY : <arcgisviz::WebChartSortOrderKinds>
#>  .. @ value   : chr "DESC"
#>  .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. @ allow_na: logi TRUE
```
