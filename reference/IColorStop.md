# IColorStop

One stop on a colour ramp: the value it sits at, and the colour there.
The client interpolates between stops.

## Value

An object of class `IColorStop`.

## Examples

``` r
IColorStop(
  value = 3000,
  color = Color(r = 237, g = 248, b = 251, a = 1),
  label = "Lightest"
)
#> <arcgisviz::IColorStop>
#>  @ value: num 3000
#>  @ color: <arcgisviz::Color>
#>  .. @ r: num 237
#>  .. @ g: num 248
#>  .. @ b: num 251
#>  .. @ a: num 1
#>  @ label: chr "Lightest"
```
