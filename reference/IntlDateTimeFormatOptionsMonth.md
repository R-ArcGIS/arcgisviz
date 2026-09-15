# IntlDateTimeFormatOptionsMonth

One of `"2-digit"`, `"long"`, `"narrow"`, `"numeric"`, `"short"`, `NA`.

## Usage

``` r
IntlDateTimeFormatOptionsMonth(value = NA_character_)
```

## Arguments

- value:

  String. One of `"2-digit"`, `"long"`, `"narrow"`, `"numeric"`,
  `"short"`, `NA`.

## Value

An object of class `IntlDateTimeFormatOptionsMonth`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlDateTimeFormatOptionsMonth("2-digit")
#> <arcgisviz::IntlDateTimeFormatOptionsMonth>
#>  @ value   : chr "2-digit"
#>  @ variants: chr [1:5] "2-digit" "long" "narrow" "numeric" "short"
#>  @ allow_na: logi TRUE
```
