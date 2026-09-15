# WebChartPredefinedLabelsDataOrder

WebChartPredefinedLabelsDataOrder

## Usage

``` r
WebChartPredefinedLabelsDataOrder(
  orderType = NA_character_,
  orderBy = character(0),
  preferLabel = NA
)
```

## Arguments

- orderType:

  String.

- orderBy:

  String.

- preferLabel:

  Bool.

## Value

An object of class `WebChartPredefinedLabelsDataOrder`.

## Examples

``` r
WebChartPredefinedLabelsDataOrder(
  orderType = "arcgis-charts-predefined-labels",
  orderBy = c("Adelie", "Chinstrap", "Gentoo")
)
#> <arcgisviz::WebChartPredefinedLabelsDataOrder>
#>  @ orderType  : chr "arcgis-charts-predefined-labels"
#>  @ orderBy    : chr [1:3] "Adelie" "Chinstrap" "Gentoo"
#>  @ preferLabel: logi NA
```
