# ISimpleLineSymbol

ISimpleLineSymbol

## Usage

``` r
ISimpleLineSymbol(
  type = "esriSLS",
  style = SimpleLineSymbolStyle(),
  color = NULL,
  width = NA_real_
)
```

## Arguments

- type:

  String.

- style:

  A `SimpleLineSymbolStyle` enum.

- color:

  `NULL` or a `Color` object.

- width:

  Number.

## Value

An object of class `ISimpleLineSymbol`.

## See also

[`new_symbol()`](http://r.esri.com/arcgisviz/reference/new_symbol.md),
which builds one from friendly names and colours.

## Examples

``` r
ISimpleLineSymbol(
  style = SimpleLineSymbolStyle("esriSLSDash"),
  color = Color(r = 51, g = 51, b = 51, a = 1),
  width = 1.5
)
#> <arcgisviz::ISimpleLineSymbol>
#>  @ type : chr "esriSLS"
#>  @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. @ value   : chr "esriSLSDash"
#>  .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" "esriSLSDashDotDot" ...
#>  .. @ allow_na: logi TRUE
#>  @ color: <arcgisviz::Color>
#>  .. @ r: num 51
#>  .. @ g: num 51
#>  .. @ b: num 51
#>  .. @ a: num 1
#>  @ width: num 1.5
```
