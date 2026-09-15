# IntlNumberFormatOptionsCurrencyDisplay

One of `"code"`, `"name"`, `"narrowSymbol"`, `"symbol"`, `NA`.

## Usage

``` r
IntlNumberFormatOptionsCurrencyDisplay(value = NA_character_)
```

## Arguments

- value:

  String. One of `"code"`, `"name"`, `"narrowSymbol"`, `"symbol"`, `NA`.

## Value

An object of class `IntlNumberFormatOptionsCurrencyDisplay`.

## Additional properties

- `@variants`:

  Character vector. The values this enum allows.

- `@allow_na`:

  Bool. Whether `NA_character_` is allowed.

## Examples

``` r
IntlNumberFormatOptionsCurrencyDisplay("code")
#> <arcgisviz::IntlNumberFormatOptionsCurrencyDisplay>
#>  @ value   : chr "code"
#>  @ variants: chr [1:4] "code" "name" "narrowSymbol" "symbol"
#>  @ allow_na: logi TRUE
```
