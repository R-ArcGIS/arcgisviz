# WebChartPieChartGroupSlice

Folds every slice under a percentage threshold into a single "Other". A
[`WebChartPieChartSlice()`](http://r.esri.com/arcgisviz/reference/WebChartPieChartSlice.md),
so it styles itself the same way. Modelled and not yet reachable from
the public API.

## Value

An object of class `WebChartPieChartGroupSlice`.

## Examples

``` r
WebChartPieChartGroupSlice(label = "Other", percentageThreshold = 5)
#> <arcgisviz::WebChartPieChartGroupSlice>
#>  @ sliceId            : chr NA
#>  @ originalLabel      : NULL
#>  @ label              : chr "Other"
#>  @ fillSymbol         : NULL
#>  @ percentageThreshold: num 5
#>  @ dataLabels         : NULL
```
