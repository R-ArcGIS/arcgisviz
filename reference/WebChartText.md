# WebChartText

A piece of chart text and whether it is drawn - the shape a title,
subtitle, or axis label takes.
[`set_labs()`](http://r.esri.com/arcgisviz/reference/set_labs.md) builds
these for you.

## Usage

``` r
WebChartText(
  type = NA_character_,
  visible = NA,
  content = WebChartTextSymbol()
)
```

## Arguments

- type:

  String.

- visible:

  Bool.

- content:

  A `WebChartTextSymbol` object.

## Value

An object of class `WebChartText`.

## Examples

``` r
WebChartText(
  type = "chartText",
  visible = TRUE,
  content = WebChartTextSymbol(type = "esriTS", text = "Palmer penguins")
)
#> <arcgisviz::WebChartText>
#>  @ type   : chr "chartText"
#>  @ visible: logi TRUE
#>  @ content: <arcgisviz::WebChartTextSymbol>
#>  .. @ type               : chr "esriTS"
#>  .. @ style              : chr NA
#>  .. @ text               : chr "Palmer penguins"
#>  .. @ color              : NULL
#>  .. @ backgroundColor    : NULL
#>  .. @ borderLineSize     : num NA
#>  .. @ borderLineColor    : NULL
#>  .. @ haloSize           : num NA
#>  .. @ haloColor          : NULL
#>  .. @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ rightToLeft        : logi NA
#>  .. @ kerning            : logi NA
#>  .. @ font               : NULL
#>  .. @ angle              : num NA
#>  .. @ xoffset            : chr NA
#>  .. @ yoffset            : chr NA
```
