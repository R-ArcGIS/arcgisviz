# WebChartGuide

A reference line or band drawn across an axis.

## Usage

``` r
WebChartGuide(
  type = NA_character_,
  start = NA_character_,
  end = NA_character_,
  style = ISimpleLineSymbol(),
  name = NA_character_,
  label = NULL,
  visible = NA,
  above = NA,
  tooltipReverseColor = NA
)
```

## Arguments

- type:

  String.

- start:

  String or Number.

- end:

  String or Number.

- style:

  A `ISimpleLineSymbol` object or a `ISimpleFillSymbol` object.

- name:

  String.

- label:

  `NULL` or a `WebChartTextSymbol` object.

- visible:

  Bool.

- above:

  Bool.

- tooltipReverseColor:

  Bool.

## Value

An object of class `WebChartGuide`.

## Examples

``` r
WebChartGuide(
  type = "chartGuide",
  start = 4000,
  name = "Target",
  style = ISimpleLineSymbol(
    style = SimpleLineSymbolStyle("esriSLSDash"),
    color = Color(r = 184, g = 40, b = 40, a = 1),
    width = 1
  )
)
#> <arcgisviz::WebChartGuide>
#>  @ type               : chr "chartGuide"
#>  @ start              : num 4000
#>  @ end                : chr NA
#>  @ style              : <arcgisviz::ISimpleLineSymbol>
#>  .. @ type : chr "esriSLS"
#>  .. @ style: <arcgisviz::SimpleLineSymbolStyle>
#>  .. .. @ value   : chr "esriSLSDash"
#>  .. .. @ variants: chr [1:6] "esriSLSDash" "esriSLSDashDot" ...
#>  .. .. @ allow_na: logi TRUE
#>  .. @ color: <arcgisviz::Color>
#>  .. .. @ r: num 184
#>  .. .. @ g: num 40
#>  .. .. @ b: num 40
#>  .. .. @ a: num 1
#>  .. @ width: num 1
#>  @ name               : chr "Target"
#>  @ label              : NULL
#>  @ visible            : logi NA
#>  @ above              : logi NA
#>  @ tooltipReverseColor: logi NA
```
