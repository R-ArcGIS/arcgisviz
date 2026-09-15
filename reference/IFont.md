# IFont

IFont

## Usage

``` r
IFont(
  family = NA_character_,
  size = NA_real_,
  style = IFontStyle(),
  weight = IFontWeight(),
  decoration = IFontDecoration()
)
```

## Arguments

- family:

  String.

- size:

  Number.

- style:

  A `IFontStyle` enum.

- weight:

  A `IFontWeight` enum.

- decoration:

  A `IFontDecoration` enum.

## Value

An object of class `IFont`.

## Examples

``` r
IFont(
  family = "Avenir Next",
  size = 12,
  style = IFontStyle("normal"),
  weight = IFontWeight("bold")
)
#> <arcgisviz::IFont>
#>  @ family    : chr "Avenir Next"
#>  @ size      : num 12
#>  @ style     : <arcgisviz::IFontStyle>
#>  .. @ value   : chr "normal"
#>  .. @ variants: chr [1:3] "italic" "normal" "oblique"
#>  .. @ allow_na: logi TRUE
#>  @ weight    : <arcgisviz::IFontWeight>
#>  .. @ value   : chr "bold"
#>  .. @ variants: chr [1:4] "bold" "bolder" "lighter" "normal"
#>  .. @ allow_na: logi TRUE
#>  @ decoration: <arcgisviz::IFontDecoration>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:3] "line-through" "none" "underline"
#>  .. @ allow_na: logi TRUE
```
