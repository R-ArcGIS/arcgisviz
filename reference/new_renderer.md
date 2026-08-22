# Create a renderer

Builds a renderer to hand to
[`add_renderer()`](http://r.esri.com/arcgisviz/reference/add_renderer.md).
`type` picks which kind and `...` sets that kind's properties, so this
is one function instead of remembering which class goes with which
symbology.

## Usage

``` r
new_renderer(type = "simple", ...)
```

## Arguments

- type:

  default `"simple"`. Defines which renderer to build, either `"simple"`
  or `"unique-value"`.

- ...:

  Defines the renderer's properties, all named. See
  [ISimpleRenderer](http://r.esri.com/arcgisviz/reference/ISimpleRenderer.md)
  and
  [IUniqueValueRenderer](http://r.esri.com/arcgisviz/reference/IUniqueValueRenderer.md)
  for what each kind takes.

## Value

An
[ISimpleRenderer](http://r.esri.com/arcgisviz/reference/ISimpleRenderer.md)
or an
[IUniqueValueRenderer](http://r.esri.com/arcgisviz/reference/IUniqueValueRenderer.md).

## Details

A `"simple"` renderer draws every feature the same way, optionally
varying colour by a `colorInfo` visual variable. A `"unique-value"`
renderer draws one symbol per value of a field.

## Examples

``` r
new_renderer("simple", symbol = new_symbol("marker", color = "red"))
#> <arcgisviz::ISimpleRenderer>
#>  @ type              : chr "simple"
#>  @ symbol            : <arcgisviz::ISimpleMarkerSymbol>
#>  .. @ type   : chr "esriSMS"
#>  .. @ style  : <arcgisviz::SimpleMarkerSymbolStyle>
#>  .. .. @ value   : chr "esriSMSCircle"
#>  .. .. @ variants: chr [1:6] "esriSMSCircle" "esriSMSCross" "esriSMSDiamond" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color  : <arcgisviz::Color>
#>  .. .. @ r: num 255
#>  .. .. @ g: num 0
#>  .. .. @ b: num 0
#>  .. .. @ a: num 255
#>  .. @ size   : num NA
#>  .. @ outline: NULL
#>  .. @ angle  : num NA
#>  .. @ xoffset: num NA
#>  .. @ yoffset: num NA
#>  @ visualVariables   : list()
#>  @ label             : chr NA
#>  @ description       : chr NA
#>  @ rotationExpression: chr NA
#>  @ rotationType      : <arcgisviz::IRendererRotationType>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:2] "arithmetic" "geographic"
#>  .. @ allow_na: logi TRUE

new_renderer("unique-value", field1 = "species")
#> <arcgisviz::IUniqueValueRenderer>
#>  @ type            : chr "uniqueValue"
#>  @ field1          : chr "species"
#>  @ field2          : chr NA
#>  @ field3          : chr NA
#>  @ fieldDelimiter  : chr NA
#>  @ defaultSymbol   : NULL
#>  @ defaultLabel    : chr NA
#>  @ uniqueValueInfos: list()
#>  @ legendOptions   : NULL
```
