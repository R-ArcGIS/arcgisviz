# WebChartTextSymbol

WebChartTextSymbol

## Usage

``` r
WebChartTextSymbol(
  type = NA_character_,
  style = NA_character_,
  text = NA_character_,
  color = NULL,
  backgroundColor = NULL,
  borderLineSize = NA_real_,
  borderLineColor = NULL,
  haloSize = NA_real_,
  haloColor = NULL,
  verticalAlignment = WebChartTextSymbolVerticalAlignment(),
  horizontalAlignment = WebChartTextSymbolHorizontalAlignment(),
  rightToLeft = NA,
  kerning = NA,
  font = NULL,
  angle = NA_real_,
  xoffset = NA_character_,
  yoffset = NA_character_
)
```

## Arguments

- type:

  String.

- style:

  String.

- text:

  String.

- color:

  `NULL` or a `Color` object.

- backgroundColor:

  `NULL` or a `Color` object.

- borderLineSize:

  Number.

- borderLineColor:

  `NULL` or a `Color` object.

- haloSize:

  Number.

- haloColor:

  `NULL` or a `Color` object.

- verticalAlignment:

  A `WebChartTextSymbolVerticalAlignment` enum.

- horizontalAlignment:

  A `WebChartTextSymbolHorizontalAlignment` enum.

- rightToLeft:

  Bool.

- kerning:

  Bool.

- font:

  `NULL` or a `IFont` object.

- angle:

  Number.

- xoffset:

  String or Number.

- yoffset:

  String or Number.

## Value

An object of class `WebChartTextSymbol`.

## Examples

``` r
WebChartTextSymbol(
  type = "esriTS",
  text = "Mean body mass (g)",
  color = Color(r = 51, g = 51, b = 51, a = 1),
  font = IFont(family = "Avenir Next", size = 12)
)
#> <arcgisviz::WebChartTextSymbol>
#>  @ type               : chr "esriTS"
#>  @ style              : chr NA
#>  @ text               : chr "Mean body mass (g)"
#>  @ color              : <arcgisviz::Color>
#>  .. @ r: num 51
#>  .. @ g: num 51
#>  .. @ b: num 51
#>  .. @ a: num 1
#>  @ backgroundColor    : NULL
#>  @ borderLineSize     : num NA
#>  @ borderLineColor    : NULL
#>  @ haloSize           : num NA
#>  @ haloColor          : NULL
#>  @ verticalAlignment  : <arcgisviz::WebChartTextSymbolVerticalAlignment>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "baseline" "bottom" "middle" "top"
#>  .. @ allow_na: logi TRUE
#>  @ horizontalAlignment: <arcgisviz::WebChartTextSymbolHorizontalAlignment>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:4] "center" "justify" "left" "right"
#>  .. @ allow_na: logi TRUE
#>  @ rightToLeft        : logi NA
#>  @ kerning            : logi NA
#>  @ font               : <arcgisviz::IFont>
#>  .. @ family    : chr "Avenir Next"
#>  .. @ size      : num 12
#>  .. @ style     : <arcgisviz::IFontStyle>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "italic" "normal" "oblique"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ weight    : <arcgisviz::IFontWeight>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:4] "bold" "bolder" "lighter" "normal"
#>  .. .. @ allow_na: logi TRUE
#>  .. @ decoration: <arcgisviz::IFontDecoration>
#>  .. .. @ value   : chr NA
#>  .. .. @ variants: chr [1:3] "line-through" "none" "underline"
#>  .. .. @ allow_na: logi TRUE
#>  @ angle              : num NA
#>  @ xoffset            : chr NA
#>  @ yoffset            : chr NA
```
