# ISimpleFillSymbol

ISimpleFillSymbol

## Usage

``` r
ISimpleFillSymbol(
  type = "esriSFS",
  style = SimpleFillSymbolStyle(),
  color = NULL,
  outline = NULL
)
```

## Arguments

- type:

  String.

- style:

  A `SimpleFillSymbolStyle` enum.

- color:

  `NULL` or a `Color` object.

- outline:

  `NULL` or a `ISimpleLineSymbol` object.

## Value

An object of class `ISimpleFillSymbol`.

## See also

[`new_symbol()`](http://r.esri.com/arcgisviz/reference/new_symbol.md),
which builds one from friendly names and colours.

## Examples

``` r
ISimpleFillSymbol(
  color = Color(r = 184, g = 40, b = 40, a = 1),
  outline = ISimpleLineSymbol(
    color = Color(r = 255, g = 255, b = 255, a = 1),
    width = 0.5
  )
)
#> <arcgisviz::ISimpleFillSymbol>
#>  @ type   : chr "esriSFS"
#>  @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. @ allow_na: logi TRUE
#>  @ color  : <arcgisviz::Color>
#>  .. @ r: num 184
#>  .. @ g: num 40
#>  .. @ b: num 40
#>  .. @ a: num 1
#>  @ outline: <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: <arcgisviz::Color>
#>  .. .. @ r: num 255
#>  .. .. @ g: num 255
#>  .. .. @ b: num 255
#>  .. .. @ a: num 1
#>  .. @ width: num 0.5
```
