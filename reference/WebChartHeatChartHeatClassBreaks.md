# WebChartHeatChartHeatClassBreaks

Shades a heat chart's cells by classed breaks off a named Esri ramp, the
branch `set_color(palette = "Heatmap 3")` takes.

## Value

An object of class `WebChartHeatChartHeatClassBreaks`.

## Examples

``` r
WebChartHeatChartHeatClassBreaks(
  breaksCount = 5,
  classificationMethod = WebChartClassBreakTypes("equal-interval"),
  colorRampInfo = WebChartHeatChartHeatClassBreaksColorRampInfo(
    name = "Heatmap 3"
  )
)
#> <arcgisviz::WebChartHeatChartHeatClassBreaks>
#>  @ breaksCount         : num 5
#>  @ classificationMethod: <arcgisviz::WebChartClassBreakTypes>
#>  .. @ value   : chr "equal-interval"
#>  .. @ variants: chr [1:4] "equal-interval" "quantile" "natural-breaks" "manual"
#>  .. @ allow_na: logi TRUE
#>  @ colorRampInfo       : <arcgisviz::WebChartHeatChartHeatClassBreaksColorRampInfo>
#>  .. @ name   : chr "Heatmap 3"
#>  .. @ flipped: logi NA
```
