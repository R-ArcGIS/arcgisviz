# IFontStyle

One of `"italic"`, `"normal"`, `"oblique"`, `NA`.

## Usage

``` r
IFontStyle(value = NA_character_)
```

## Arguments

- value:

  String. One of `"italic"`, `"normal"`, `"oblique"`, `NA`.

## Value

An object of class `IFontStyle`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IFontStyle("italic")
#> <arcgisviz::IFontStyle>
#>  @ value   : chr "italic"
#>  @ variants: chr [1:3] "italic" "normal" "oblique"
#>  @ allow_na: logi TRUE
```
