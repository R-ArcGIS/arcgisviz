# WebChartDirectionalDataOrder

WebChartDirectionalDataOrder

## Usage

``` r
WebChartDirectionalDataOrder(
  orderType = WebChartDirectionalDataOrderOrderType(),
  orderBy = WebChartSortOrderKinds(),
  preferLabel = NA
)
```

## Arguments

- orderType:

  A `WebChartDirectionalDataOrderOrderType` enum.

- orderBy:

  A `WebChartSortOrderKinds` enum.

- preferLabel:

  Bool.

## Value

An object of class `WebChartDirectionalDataOrder`.

## Examples

``` r
WebChartDirectionalDataOrder(
  orderType = WebChartDirectionalDataOrderOrderType("arcgis-charts-y-value"),
  orderBy = WebChartSortOrderKinds("DESC")
)
#> <arcgisviz::WebChartDirectionalDataOrder>
#>  @ orderType  : <arcgisviz::WebChartDirectionalDataOrderOrderType>
#>  .. @ value   : chr "arcgis-charts-y-value"
#>  .. @ variants: chr [1:4] "arcgis-charts-category" "arcgis-charts-mean" ...
#>  .. @ allow_na: logi TRUE
#>  @ orderBy    : <arcgisviz::WebChartSortOrderKinds>
#>  .. @ value   : chr "DESC"
#>  .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. @ allow_na: logi TRUE
#>  @ preferLabel: logi NA
```
