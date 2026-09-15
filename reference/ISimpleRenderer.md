# ISimpleRenderer

One symbol for every feature, optionally varied by a visual variable.
`type` is fixed by the class, so it is never restated at a call site.

## Value

An object of class `ISimpleRenderer`.

## See also

[`new_renderer()`](http://r.esri.com/arcgisviz/reference/new_renderer.md),
which builds one from friendly names and colours.

## Examples

``` r
ISimpleRenderer(
  symbol = ISimpleFillSymbol(color = Color(r = 184, g = 40, b = 40, a = 1))
)
#> <arcgisviz::ISimpleRenderer>
#>  @ type              : chr "simple"
#>  @ symbol            : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 184
#>  .. .. @ g: num 40
#>  .. .. @ b: num 40
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
#>  @ visualVariables   : list()
#>  @ label             : chr NA
#>  @ description       : chr NA
#>  @ rotationExpression: chr NA
#>  @ rotationType      : <arcgisviz::IRendererRotationType>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "arithmetic" "geographic"
#>  .. @ allow_na: logi TRUE

# With a continuous colour mapping over the top.
ISimpleRenderer(
  symbol = ISimpleMarkerSymbol(size = 8),
  visualVariables = list(IColorVisualVariable(field = "body_mass"))
)
#> <arcgisviz::ISimpleRenderer>
#>  @ type              : chr "simple"
#>  @ symbol            : <arcgisviz::ISimpleMarkerSymbol>
#>  .. @ type   : chr "esriSMS"
#>  .. @ style  : <arcgisviz::SimpleMarkerSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "esriSMSCircle" "esriSMSCross" "esriSMSDiamond" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : NULL
#>  .. @ size   : num 8
#>  .. @ outline: NULL
#>  .. @ angle  : num NA
#>  .. @ xoffset: num NA
#>  .. @ yoffset: num NA
#>  @ visualVariables   :List of 1
#>  .. $ : <arcgisviz::IColorVisualVariable>
#>  ..  ..@ type                : chr "colorInfo"
#>  ..  ..@ field               : chr "body_mass"
#>  ..  ..@ stops               : list()
#>  ..  ..@ valueExpression     : chr NA
#>  ..  ..@ valueExpressionTitle: chr NA
#>  ..  ..@ normalizationField  : chr NA
#>  ..  ..@ legendOptions       : NULL
#>  @ label             : chr NA
#>  @ description       : chr NA
#>  @ rotationExpression: chr NA
#>  @ rotationType      : <arcgisviz::IRendererRotationType>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "arithmetic" "geographic"
#>  .. @ allow_na: logi TRUE
```
