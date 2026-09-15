# SimpleLineSymbolStyle

One of `"esriSLSDash"`, `"esriSLSDashDot"`, `"esriSLSDashDotDot"`,
`"esriSLSDot"`, `"esriSLSNull"`, `"esriSLSSolid"`, `NA`.

## Usage

``` r
SimpleLineSymbolStyle(value = NA_character_)
```

## Arguments

- value:

  String. One of `"esriSLSDash"`, `"esriSLSDashDot"`,
  `"esriSLSDashDotDot"`, `"esriSLSDot"`, `"esriSLSNull"`,
  `"esriSLSSolid"`, `NA`.

## Value

An object of class `SimpleLineSymbolStyle`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
SimpleLineSymbolStyle("esriSLSDash")
#> <arcgisviz::SimpleLineSymbolStyle>
#>  @ value   : chr "esriSLSDash"
#>  @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" "esriSLSDashDotDot" ...
#>  @ allow_na: logi TRUE
```
