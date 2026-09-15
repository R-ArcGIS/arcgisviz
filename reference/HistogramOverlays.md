# HistogramOverlays

The four overlays a histogram supports. An overlay whose `created` is
true is also what earns a histogram a legend.

## Value

An object of class `HistogramOverlays`.

## Examples

``` r
HistogramOverlays(
  type = "histogramOverlays",
  mean = WebChartOverlay(created = TRUE, visible = TRUE),
  median = WebChartOverlay(created = TRUE, visible = TRUE)
)
#> <arcgisviz::HistogramOverlays>
#>  @ type                  : chr "histogramOverlays"
#>  @ mean                  : <arcgisviz::WebChartOverlay>
#>  .. @ type   : chr NA
#>  .. @ created: logi TRUE
#>  .. @ visible: logi TRUE
#>  .. @ symbol : NULL
#>  @ median                : <arcgisviz::WebChartOverlay>
#>  .. @ type   : chr NA
#>  .. @ created: logi TRUE
#>  .. @ visible: logi TRUE
#>  .. @ symbol : NULL
#>  @ standardDeviation     : NULL
#>  @ comparisonDistribution: NULL
```
