# IntlNumberFormatOptionsCompactDisplay

One of `"long"`, `"short"`, `NA`.

## Usage

``` r
IntlNumberFormatOptionsCompactDisplay(value = NA_character_)
```

## Arguments

- value:

  String. One of `"long"`, `"short"`, `NA`.

## Value

An object of class `IntlNumberFormatOptionsCompactDisplay`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlNumberFormatOptionsCompactDisplay("long")
#> <arcgisviz::IntlNumberFormatOptionsCompactDisplay>
#>  @ value   : chr "long"
#>  @ variants: chr [1:2] "long" "short"
#>  @ allow_na: logi TRUE
```
