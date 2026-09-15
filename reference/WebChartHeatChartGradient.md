# WebChartHeatChartGradient

The two-colour gradient a heat chart shades its cells with. This is what
`set_color(palette = )` builds for anything that is not a named Esri
ramp.

## Value

An object of class `WebChartHeatChartGradient`.

## Examples

``` r
WebChartHeatChartGradient(
  colorList = list(
    Color(r = 255, g = 255, b = 255, a = 1),
    Color(r = 0, g = 0, b = 128, a = 1)
  )
)
#> <arcgisviz::WebChartHeatChartGradient>
#>  @ colorList             :List of 2
#>  .. $ : <arcgisviz::Color>
#>  ..  ..@ r: num 255
#>  ..  ..@ g: num 255
#>  ..  ..@ b: num 255
#>  ..  ..@ a: num 1
#>  .. $ : <arcgisviz::Color>
#>  ..  ..@ r: num 0
#>  ..  ..@ g: num 0
#>  ..  ..@ b: num 128
#>  ..  ..@ a: num 1
#>  @ minValue              : num NA
#>  @ maxValue              : num NA
#>  @ outsideRangeLowerColor: NULL
#>  @ outsideRangeUpperColor: NULL
```
