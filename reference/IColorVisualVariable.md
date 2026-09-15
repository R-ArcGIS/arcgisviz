# IColorVisualVariable

A continuous colour mapping carried on a renderer. This is what
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
builds for a numeric column.

## Value

An object of class `IColorVisualVariable`.

## Examples

``` r
IColorVisualVariable(
  field = "body_mass",
  stops = list(
    IColorStop(value = 2700, color = Color(r = 237, g = 248, b = 251, a = 1)),
    IColorStop(value = 6300, color = Color(r = 8, g = 81, b = 156, a = 1))
  ),
  legendOptions = ILegendOptions(title = "Body mass (g)")
)
#> <arcgisviz::IColorVisualVariable>
#>  @ type                : chr "colorInfo"
#>  @ field               : chr "body_mass"
#>  @ stops               :List of 2
#>  .. $ : <arcgisviz::IColorStop>
#>  ..  ..@ value: num 2700
#>  ..  ..@ color: <arcgisviz::Color>
#>  .. .. .. @ r: num 237
#>  .. .. .. @ g: num 248
#>  .. .. .. @ b: num 251
#>  .. .. .. @ a: num 1
#>  ..  ..@ label: chr NA
#>  .. $ : <arcgisviz::IColorStop>
#>  ..  ..@ value: num 6300
#>  ..  ..@ color: <arcgisviz::Color>
#>  .. .. .. @ r: num 8
#>  .. .. .. @ g: num 81
#>  .. .. .. @ b: num 156
#>  .. .. .. @ a: num 1
#>  ..  ..@ label: chr NA
#>  @ valueExpression     : chr NA
#>  @ valueExpressionTitle: chr NA
#>  @ normalizationField  : chr NA
#>  @ legendOptions       : <arcgisviz::ILegendOptions>
#>  .. @ title     : chr "Body mass (g)"
#>  .. @ showLegend: logi NA
#>  .. @ order     : <arcgisviz::ILegendOptionsOrder>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:2] "ascendingValues" "descendingValues"
#>  .. .. @ allow_na: logi TRUE
```
