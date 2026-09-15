# IFontDecoration

One of `"line-through"`, `"none"`, `"underline"`, `NA`.

## Usage

``` r
IFontDecoration(value = NA_character_)
```

## Arguments

- value:

  String. One of `"line-through"`, `"none"`, `"underline"`, `NA`.

## Value

An object of class `IFontDecoration`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IFontDecoration("line-through")
#> <arcgisviz::IFontDecoration>
#>  @ value   : chr "line-through"
#>  @ variants: chr [1:3] "line-through" "none" "underline"
#>  @ allow_na: logi TRUE
```
