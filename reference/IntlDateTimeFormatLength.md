# IntlDateTimeFormatLength

One of `"full"`, `"long"`, `"medium"`, `"short"`, `NA`.

## Usage

``` r
IntlDateTimeFormatLength(value = NA_character_)
```

## Arguments

- value:

  String. One of `"full"`, `"long"`, `"medium"`, `"short"`, `NA`.

## Value

An object of class `IntlDateTimeFormatLength`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlDateTimeFormatLength("full")
#> <arcgisviz::IntlDateTimeFormatLength>
#>  @ value   : chr "full"
#>  @ variants: chr [1:4] "full" "long" "medium" "short"
#>  @ allow_na: logi TRUE
```
