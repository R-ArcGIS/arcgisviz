# IntlDateTimeFormatOptionsTimeZoneName

One of `"long"`, `"longGeneric"`, `"longOffset"`, `"short"`,
`"shortGeneric"`, `"shortOffset"`, `NA`.

## Usage

``` r
IntlDateTimeFormatOptionsTimeZoneName(value = NA_character_)
```

## Arguments

- value:

  String. One of `"long"`, `"longGeneric"`, `"longOffset"`, `"short"`,
  `"shortGeneric"`, `"shortOffset"`, `NA`.

## Value

An object of class `IntlDateTimeFormatOptionsTimeZoneName`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlDateTimeFormatOptionsTimeZoneName("long")
#> <arcgisviz::IntlDateTimeFormatOptionsTimeZoneName>
#>  @ value   : chr "long"
#>  @ variants: chr [1:6] "long" "longGeneric" "longOffset" "short" "shortGeneric" ...
#>  @ allow_na: logi TRUE
```
