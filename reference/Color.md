# An RGBA colour

Holds a colour as separate `r`, `g`, `b`, and `a` components, each on a
0 to 255 scale. Serialization converts it back to the tuple the spec
uses.

## Usage

``` r
Color(r = NA_real_, g = NA_real_, b = NA_real_, a = NA_real_)
```

## Examples

``` r
s7x::as_vector(Color(r = 70, g = 130, b = 180, a = 255))
#> [1]  70 130 180 255
```
