# ValueConversion

A linear rescaling applied to a gauge's reading before it is drawn.

## Value

An object of class `ValueConversion`.

## Examples

``` r
# Grams to kilograms.
ValueConversion(factor = 0.001, offset = 0)
#> <arcgisviz::ValueConversion>
#>  @ factor: num 0.001
#>  @ offset: num 0
```
