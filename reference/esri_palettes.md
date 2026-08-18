# Browse the Esri colour ramps

Lists every ramp
[`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md)
accepts by name, with the tags the ArcGIS SDK ships alongside them. Call
it with no arguments for all of them, or narrow it with any combination
of the arguments below.

## Usage

``` r
esri_palettes(type = NULL, color_mode = NULL, hue = NULL, tag = NULL)
```

## Arguments

- type:

  default `NULL`. Keeps only ramps of these types, any of
  `"sequential"`, `"diverging"`, or `"categorical"`.

- color_mode:

  default `NULL`. Keeps only ramps drawn for a `"light"` or `"dark"`
  background.

- hue:

  default `NULL`. Keeps ramps drawing on any of these colour families,
  such as `"blues"` or `"reds"`.

- tag:

  default `NULL`. Keeps ramps carrying all of these tags, such as
  `"heatmap"` or `"colorblind-friendly"`.

## Value

A data frame of ramps, one row each.

## Details

The result has one row per ramp and these columns.

- palette:

  The name to pass to
  [`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md).

- type:

  `"sequential"`, `"diverging"`, `"categorical"`, or `NA`.

- color_mode:

  `"light"` or `"dark"`, the background the ramp is drawn for.

- colorblind_friendly:

  Whether Esri tags the ramp as such.

- n_stops:

  How many colours the ramp defines.

- hues:

  The colour families the ramp draws on.

- tags:

  Every tag, including the ones above.

## Examples

``` r
esri_palettes(type = "diverging", color_mode = "dark")
#> # A data frame: 87 × 7
#>    palette             type   color_mode colorblind_friendly n_stops hues  tags 
#>    <chr>               <chr>  <chr>      <lgl>                 <int> <I<l> <I<l>
#>  1 Blue and Orange 1   diver… dark       TRUE                      5 <chr> <chr>
#>  2 Purple and Yellow 1 diver… dark       TRUE                      5 <chr> <chr>
#>  3 Blue and Red 5      diver… dark       TRUE                      5 <chr> <chr>
#>  4 Purple and Green 4  diver… dark       TRUE                      5 <chr> <chr>
#>  5 Blue and Yellow 1   diver… dark       TRUE                      5 <chr> <chr>
#>  6 Green and Gray 2    diver… dark       TRUE                      5 <chr> <chr>
#>  7 Red and Gray 2      diver… dark       TRUE                      5 <chr> <chr>
#>  8 Purple and Gray 1   diver… dark       TRUE                      5 <chr> <chr>
#>  9 Green and Yellow 1  diver… dark       TRUE                      5 <chr> <chr>
#> 10 Blue and Yellow 2   diver… dark       TRUE                      5 <chr> <chr>
#> # ℹ 77 more rows
```
