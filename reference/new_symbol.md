# Create a symbol

Builds the symbol a renderer draws with. `type` follows the geometry -
`"marker"` for points, `"line"` for lines, `"fill"` for polygons - and
`...` sets that symbol's properties.

## Usage

``` r
new_symbol(type = "marker", ...)
```

## Arguments

- type:

  default `"marker"`. Defines which symbol to build, one of `"marker"`,
  `"fill"`, or `"line"`.

- ...:

  Defines the symbol's properties, all named. See
  [ISimpleMarkerSymbol](http://r.esri.com/arcgisviz/reference/ISimpleMarkerSymbol.md),
  [ISimpleFillSymbol](http://r.esri.com/arcgisviz/reference/ISimpleFillSymbol.md),
  and
  [ISimpleLineSymbol](http://r.esri.com/arcgisviz/reference/ISimpleLineSymbol.md).

## Value

An
[ISimpleMarkerSymbol](http://r.esri.com/arcgisviz/reference/ISimpleMarkerSymbol.md),
[ISimpleFillSymbol](http://r.esri.com/arcgisviz/reference/ISimpleFillSymbol.md),
or
[ISimpleLineSymbol](http://r.esri.com/arcgisviz/reference/ISimpleLineSymbol.md).

## Details

`color` takes a colour name or hex string rather than a
[Color](http://r.esri.com/arcgisviz/reference/Color.md), and `style`
takes a friendly name such as `"solid"` or `"backward-diagonal"` rather
than an esri-prefixed enum value. `style` defaults to `"solid"`.

## Examples

``` r
new_symbol("marker", color = "steelblue", size = 8)
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
#>  .. @ a: num 255
#>  @ size   : num 8
#>  @ outline: NULL
#>  @ angle  : num NA
#>  @ xoffset: num NA
#>  @ yoffset: num NA

new_symbol("fill",
  color = "#b8282899",
  outline = new_symbol("line", color = "white", width = 0.5)
)
#> <arcgisviz::ISimpleFillSymbol>
#>  @ type   : chr "esriSFS"
#>  @ style  : <arcgisviz::SimpleFillSymbolStyle>
#>  .. @ value   : chr "esriSFSSolid"
#>  .. @ variants: chr [1:8] "esriSFSBackwardDiagonal" "esriSFSCross" ...
#>  .. @ allow_na: logi TRUE
#>  @ color  : <arcgisviz::Color>
#>  .. @ r: num 184
#>  .. @ g: num 40
#>  .. @ b: num 40
#>  .. @ a: num 153
#>  @ outline: <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr "esriSLSSolid"
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: <arcgisviz::Color>
#>  .. .. @ r: num 255
#>  .. .. @ g: num 255
#>  .. .. @ b: num 255
#>  .. .. @ a: num 255
#>  .. @ width: num 0.5
```
