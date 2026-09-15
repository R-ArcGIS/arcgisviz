# WebChartDataFilters

The filter a chart re-queries its own layer with.
[`set_filter()`](http://r.esri.com/arcgisviz/reference/set_filter.md)
sends the same shape to a rendered chart.

## Usage

``` r
WebChartDataFilters(
  distance = NA_real_,
  gdbVersion = NA_character_,
  geometry = NULL,
  objectIds = list(),
  spatialRelationship = WebChartQuerySpatialRelationship(),
  timeExtent = list(),
  units = RESTUnits(),
  where = NA_character_
)
```

## Arguments

- distance:

  Number.

- gdbVersion:

  String.

- geometry:

  Any value.

- objectIds:

  List.

- spatialRelationship:

  A `WebChartQuerySpatialRelationship` enum.

- timeExtent:

  List.

- units:

  A `RESTUnits` enum.

- where:

  String.

## Value

An object of class `WebChartDataFilters`.

## Examples

``` r
WebChartDataFilters(where = "body_mass > 4000")
#> <arcgisviz::WebChartDataFilters>
#>  @ distance           : num NA
#>  @ gdbVersion         : chr NA
#>  @ geometry           : NULL
#>  @ objectIds          : list()
#>  @ spatialRelationship: <arcgisviz::WebChartQuerySpatialRelationship>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:10] "contains" "crosses" "disjoint" "envelope-intersects" ...
#>  .. @ allow_na: logi TRUE
#>  @ timeExtent         : list()
#>  @ units              : <arcgisviz::RESTUnits>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:6] "feet" "kilometers" "meters" "miles" "nautical-miles" ...
#>  .. @ allow_na: logi TRUE
#>  @ where              : chr "body_mass > 4000"

WebChartDataFilters(objectIds = list(1L, 2L, 3L))
#> <arcgisviz::WebChartDataFilters>
#>  @ distance           : num NA
#>  @ gdbVersion         : chr NA
#>  @ geometry           : NULL
#>  @ objectIds          :List of 3
#>  .. $ : int 1
#>  .. $ : int 2
#>  .. $ : int 3
#>  @ spatialRelationship: <arcgisviz::WebChartQuerySpatialRelationship>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:10] "contains" "crosses" "disjoint" "envelope-intersects" ...
#>  .. @ allow_na: logi TRUE
#>  @ timeExtent         : list()
#>  @ units              : <arcgisviz::RESTUnits>
#>  .. @ value   : chr NA
#>  .. @ variants: chr [1:6] "feet" "kilometers" "meters" "miles" "nautical-miles" ...
#>  .. @ allow_na: logi TRUE
#>  @ where              : chr NA
```
