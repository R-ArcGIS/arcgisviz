# WebChartHeatChartHeatClassBreaksColorRampInfo

Names an Esri colour ramp for the client to generate class breaks from.
The ramp travels by *name*: no colours leave R, which is why a named
ramp cannot carry an alpha channel.

## Value

An object of class `WebChartHeatChartHeatClassBreaksColorRampInfo`.

## Examples

``` r
WebChartHeatChartHeatClassBreaksColorRampInfo(
  name = "Heatmap 3",
  flipped = FALSE
)
#> <arcgisviz::WebChartHeatChartHeatClassBreaksColorRampInfo>
#>  @ name   : chr "Heatmap 3"
#>  @ flipped: logi FALSE
```
