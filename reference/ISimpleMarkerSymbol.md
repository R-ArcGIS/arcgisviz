# ISimpleMarkerSymbol

ISimpleMarkerSymbol

## Usage

``` r
ISimpleMarkerSymbol(
  type = "esriSMS",
  style = SimpleMarkerSymbolStyle(),
  color = NULL,
  size = NA_real_,
  outline = NULL,
  angle = NA_real_,
  xoffset = NA_real_,
  yoffset = NA_real_
)
```

## Arguments

- type:

  String.

- style:

  A `SimpleMarkerSymbolStyle` enum.

- color:

  `NULL` or a `Color` object.

- size:

  Number.

- outline:

  `NULL` or a `ISimpleLineSymbol` object.

- angle:

  Number.

- xoffset:

  Number.

- yoffset:

  Number.

## Value

An object of class `ISimpleMarkerSymbol`.

## See also

[`new_symbol()`](http://r.esri.com/arcgisviz/reference/new_symbol.md),
which builds one from friendly names and colours.

## Examples

``` r
ISimpleMarkerSymbol(
  style = SimpleMarkerSymbolStyle("esriSMSCircle"),
  color = Color(r = 70, g = 130, b = 180, a = 1),
  size = 8
)
#> <arcgisviz::ISimpleMarkerSymbol>
#>  @ type   : chr "esriSMS"
#>  @ style  : <arcgisviz::SimpleMarkerSymbolStyle>
#>  .. @ value   : chr "esriSMSCircle"
#>  .. @ variants: chr [1:6] "esriSMSCircle" "esriSMSCross" "esriSMSDiamond" ...
#>  .. @ allow_na: logi TRUE
#>  @ color  : <arcgisviz::Color>
#>  .. @ r: num 70
#>  .. @ g: num 130
#>  .. @ b: num 180
#>  .. @ a: num 1
#>  @ size   : num 8
#>  @ outline: NULL
#>  @ angle  : num NA
#>  @ xoffset: num NA
#>  @ yoffset: num NA
```
