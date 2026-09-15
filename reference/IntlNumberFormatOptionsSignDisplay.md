# IntlNumberFormatOptionsSignDisplay

One of `"always"`, `"auto"`, `"exceptZero"`, `"never"`, `NA`.

## Usage

``` r
IntlNumberFormatOptionsSignDisplay(value = NA_character_)
```

## Arguments

- value:

  String. One of `"always"`, `"auto"`, `"exceptZero"`, `"never"`, `NA`.

## Value

An object of class `IntlNumberFormatOptionsSignDisplay`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlNumberFormatOptionsSignDisplay("always")
#> <arcgisviz::IntlNumberFormatOptionsSignDisplay>
#>  @ value   : chr "always"
#>  @ variants: chr [1:4] "always" "auto" "exceptZero" "never"
#>  @ allow_na: logi TRUE
```
