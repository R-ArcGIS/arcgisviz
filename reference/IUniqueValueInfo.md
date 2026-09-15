# IUniqueValueInfo

One level of a
[`IUniqueValueRenderer()`](http://r.esri.com/arcgisviz/reference/IUniqueValueRenderer.md)
and the symbol drawn for it.

## Value

An object of class `IUniqueValueInfo`.

## Examples

``` r
IUniqueValueInfo(
  value = "Adelie",
  label = "Adelie penguin",
  symbol = ISimpleFillSymbol(color = Color(r = 78, g = 121, b = 167, a = 1))
)
#> <arcgisviz::IUniqueValueInfo>
#>  @ value      : chr "Adelie"
#>  @ label      : chr "Adelie penguin"
#>  @ description: chr NA
#>  @ symbol     : <arcgisviz::ISimpleFillSymbol>
#>  .. @ type   : chr "esriSFS"
#>  .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 78
#>  .. .. @ g: num 121
#>  .. .. @ b: num 167
#>  .. .. @ a: num 1
#>  .. @ outline: NULL
```
