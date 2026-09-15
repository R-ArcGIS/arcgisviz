# SimpleMarkerSymbolStyle

One of `"esriSMSCircle"`, `"esriSMSCross"`, `"esriSMSDiamond"`,
`"esriSMSSquare"`, `"esriSMSTriangle"`, `"esriSMSX"`, `NA`.

## Usage

``` r
SimpleMarkerSymbolStyle(value = NA_character_)
```

## Arguments

- value:

  String. One of `"esriSMSCircle"`, `"esriSMSCross"`,
  `"esriSMSDiamond"`, `"esriSMSSquare"`, `"esriSMSTriangle"`,
  `"esriSMSX"`, `NA`.

## Value

An object of class `SimpleMarkerSymbolStyle`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
SimpleMarkerSymbolStyle("esriSMSCircle")
#> <arcgisviz::SimpleMarkerSymbolStyle>
#>  @ value   : chr "esriSMSCircle"
#>  @ variants: chr [1:6] "esriSMSCircle" "esriSMSCross" "esriSMSDiamond" ...
#>  @ allow_na: logi TRUE
```
