# WebChartOrderOptions

How a chart's series and categories are sorted.

## Usage

``` r
WebChartOrderOptions(series = NULL, data = NULL, orderByFields = character(0))
```

## Arguments

- series:

  `NULL` or a `WebChartOrderSeriesBy` object.

- data:

  `NULL` or a `WebChartDirectionalDataOrder` object or a
  `WebChartMultiAxesDataOrder` object or a
  `WebChartPredefinedLabelsDataOrder` object.

- orderByFields:

  String.

## Value

An object of class `WebChartOrderOptions`.

## Examples

``` r
WebChartOrderOptions(
  series = WebChartOrderSeriesBy(orderBy = WebChartSortOrderKinds("ASC")),
  data = WebChartDirectionalDataOrder(
    orderType = WebChartDirectionalDataOrderOrderType(
      "arcgis-charts-y-value"
    ),
    orderBy = WebChartSortOrderKinds("DESC")
  )
)
#> <arcgisviz::WebChartOrderOptions>
#>  @ series       : <arcgisviz::WebChartOrderSeriesBy>
#>  .. @ preferLabel: logi NA
#>  .. @ orderBy    : <arcgisviz::WebChartSortOrderKinds>
#>  .. .. @ value   : chr "ASC"
#>  .. .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. .. @ allow_na: logi TRUE
#>  @ data         : <arcgisviz::WebChartDirectionalDataOrder>
#>  .. @ orderType  : <arcgisviz::WebChartDirectionalDataOrderOrderType>
#>  .. .. @ value   : chr "arcgis-charts-y-value"
#>  .. .. @ variants: chr [1:4] "arcgis-charts-category" "arcgis-charts-mean" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ orderBy    : <arcgisviz::WebChartSortOrderKinds>
#>  .. .. @ value   : chr "DESC"
#>  .. .. @ variants: chr [1:2] "ASC" "DESC"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ preferLabel: logi NA
#>  @ orderByFields: chr(0) 
```
