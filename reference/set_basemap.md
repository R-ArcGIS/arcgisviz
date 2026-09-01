# Set the basemap

Replaces the imagery the layers draw over.

## Usage

``` r
set_basemap(map, basemap)
```

## Arguments

- map:

  Defines which map to modify.

- basemap:

  Defines the basemap id. See
  [Basemaps](http://r.esri.com/arcgisviz/reference/Basemaps.md).

## Value

`map`, with the basemap set.

## Examples

``` r
set_basemap(arc_map(), "satellite")
```
