# IntlFormatWidth

One of `"long"`, `"narrow"`, `"short"`, `NA`.

## Usage

``` r
IntlFormatWidth(value = NA_character_)
```

## Arguments

- value:

  String. One of `"long"`, `"narrow"`, `"short"`, `NA`.

## Value

An object of class `IntlFormatWidth`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlFormatWidth("long")
#> <arcgisviz::IntlFormatWidth>
#>  @ value   : chr "long"
#>  @ variants: chr [1:3] "long" "narrow" "short"
#>  @ allow_na: logi TRUE
```
