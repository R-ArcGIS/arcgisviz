# SizePolicy

Scales marker area by a numeric column. Declared on the scatterplot
series alone, which is why
[`set_size()`](http://r.esri.com/arcgisviz/reference/set_size.md) works
on no other chart type.

## Usage

``` r
SizePolicy(
  type = NA_character_,
  scaleType = SizePolicyScaleTypes(),
  field = NA_character_,
  minSize = NA_real_,
  maxSize = NA_real_
)
```

## Arguments

- type:

  String.

- scaleType:

  A `SizePolicyScaleTypes` enum.

- field:

  String.

- minSize:

  Number.

- maxSize:

  Number.

## Value

An object of class `SizePolicy`.

## Examples

``` r
SizePolicy(
  type = "sizeScale",
  field = "body_mass",
  scaleType = SizePolicyScaleTypes("linear"),
  minSize = 4,
  maxSize = 18
)
#> <arcgisviz::SizePolicy>
#>  @ type     : chr "sizeScale"
#>  @ scaleType: <arcgisviz::SizePolicyScaleTypes>
#>  .. @ value   : chr "linear"
#>  .. @ variants: chr [1:2] "linear" "logarithmic"
#>  .. @ allow_na: logi TRUE
#>  @ field    : chr "body_mass"
#>  @ minSize  : num 4
#>  @ maxSize  : num 18
```
