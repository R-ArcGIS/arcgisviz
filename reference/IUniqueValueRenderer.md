# IUniqueValueRenderer

One symbol per distinct value of `field1`. This is what
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
builds for a grouping column, and what a map uses for any non-numeric
one.

## Value

An object of class `IUniqueValueRenderer`.

## See also

[`new_renderer()`](http://r.esri.com/arcgisviz/reference/new_renderer.md),
which builds one from friendly names and colours.

## Examples

``` r
IUniqueValueRenderer(
  field1 = "species",
  uniqueValueInfos = list(
    IUniqueValueInfo(
      value = "Adelie",
      symbol = ISimpleFillSymbol(
        color = Color(r = 78, g = 121, b = 167, a = 1)
      )
    ),
    IUniqueValueInfo(
      value = "Gentoo",
      symbol = ISimpleFillSymbol(
        color = Color(r = 242, g = 142, b = 43, a = 1)
      )
    )
  )
)
#> <arcgisviz::IUniqueValueRenderer>
#>  @ type            : chr "uniqueValue"
#>  @ field1          : chr "species"
#>  @ field2          : chr NA
#>  @ field3          : chr NA
#>  @ fieldDelimiter  : chr NA
#>  @ defaultSymbol   : NULL
#>  @ defaultLabel    : chr NA
#>  @ uniqueValueInfos:List of 2
#>  .. $ : <arcgisviz::IUniqueValueInfo>
#>  ..  ..@ value      : chr "Adelie"
#>  ..  ..@ label      : chr NA
#>  ..  ..@ description: chr NA
#>  ..  ..@ symbol     : <arcgisviz::ISimpleFillSymbol>
#>  .. .. .. @ type   : chr "esriSFS"
#>  .. .. .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. .. .. @ value   : chr NA
#>  .. .. .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" "esriSFSDiagonalCross" "esriSFSForwardDiagonal" ...
#>  .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. @ color  : <arcgisviz::Color>
#>  .. .. .. .. @ r: num 78
#>  .. .. .. .. @ g: num 121
#>  .. .. .. .. @ b: num 167
#>  .. .. .. .. @ a: num 1
#>  .. .. .. @ outline: NULL
#>  .. $ : <arcgisviz::IUniqueValueInfo>
#>  ..  ..@ value      : chr "Gentoo"
#>  ..  ..@ label      : chr NA
#>  ..  ..@ description: chr NA
#>  ..  ..@ symbol     : <arcgisviz::ISimpleFillSymbol>
#>  .. .. .. @ type   : chr "esriSFS"
#>  .. .. .. @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. .. .. .. @ value   : chr NA
#>  .. .. .. .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" "esriSFSDiagonalCross" "esriSFSForwardDiagonal" ...
#>  .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. @ color  : <arcgisviz::Color>
#>  .. .. .. .. @ r: num 242
#>  .. .. .. .. @ g: num 142
#>  .. .. .. .. @ b: num 43
#>  .. .. .. .. @ a: num 1
#>  .. .. .. @ outline: NULL
#>  @ visualVariables : list()
#>  @ legendOptions   : NULL
```
