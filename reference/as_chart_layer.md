# Build a feature layer from a data frame

Wraps a data frame as a self-contained client side feature collection,
the `iLayer` the browser builds the chart from. No live feature service
is involved.

## Usage

``` r
as_chart_layer(
  .data,
  name = "chart_data",
  title = name,
  id = "arcgisviz-layer"
)
```

## Arguments

- .data:

  Defines which data frame or `sf` object to convert.

- name:

  default `"chart_data"`. Defines what the layer is named.

- title:

  default `name`. Defines the human readable layer title.

- id:

  default `"arcgisviz-layer"`. Defines the unique layer id.

## Value

A list holding the `IFeatureLayer` JSON shape.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

as_chart_layer(df)
#> $id
#> [1] "arcgisviz-layer"
#> 
#> $title
#> [1] "chart_data"
#> 
#> $layerType
#> [1] "ArcGISFeatureLayer"
#> 
#> $featureCollection
#> $featureCollection$layers
#> $featureCollection$layers[[1]]
#> $featureCollection$layers[[1]]$featureSet
#> $featureCollection$layers[[1]]$featureSet$spatialReference
#> named list()
#> 
#> $featureCollection$layers[[1]]$featureSet$features
#> $featureCollection$layers[[1]]$featureSet$features[[1]]
#> $featureCollection$layers[[1]]$featureSet$features[[1]]$attributes
#> $featureCollection$layers[[1]]$featureSet$features[[1]]$attributes$mass
#> [1] 1
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[1]]$attributes$object_id
#> [1] 1
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[1]]$attributes$species
#> [1] "a"
#> 
#> 
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[2]]
#> $featureCollection$layers[[1]]$featureSet$features[[2]]$attributes
#> $featureCollection$layers[[1]]$featureSet$features[[2]]$attributes$mass
#> [1] 5
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[2]]$attributes$object_id
#> [1] 2
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[2]]$attributes$species
#> [1] "b"
#> 
#> 
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[3]]
#> $featureCollection$layers[[1]]$featureSet$features[[3]]$attributes
#> $featureCollection$layers[[1]]$featureSet$features[[3]]$attributes$mass
#> [1] 3
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[3]]$attributes$object_id
#> [1] 3
#> 
#> $featureCollection$layers[[1]]$featureSet$features[[3]]$attributes$species
#> [1] "c"
#> 
#> 
#> 
#> 
#> 
#> $featureCollection$layers[[1]]$layerDefinition
#> $featureCollection$layers[[1]]$layerDefinition$name
#> [1] "chart_data"
#> 
#> $featureCollection$layers[[1]]$layerDefinition$objectIdField
#> [1] "object_id"
#> 
#> $featureCollection$layers[[1]]$layerDefinition$fields
#>                name                type     alias length editable nullable
#> 1         object_id    esriFieldTypeOID object_id     NA    FALSE    FALSE
#> character   species esriFieldTypeString   species     NA     TRUE     TRUE
#> double         mass esriFieldTypeDouble      mass     NA     TRUE     TRUE
#> 
#> $featureCollection$layers[[1]]$layerDefinition$hasAttachments
#> [1] FALSE
#> 
#> $featureCollection$layers[[1]]$layerDefinition$maxScale
#> [1] 0
#> 
#> $featureCollection$layers[[1]]$layerDefinition$minScale
#> [1] 0
#> 
#> $featureCollection$layers[[1]]$layerDefinition$type
#> [1] "Table"
#> 
#> 
#> $featureCollection$layers[[1]]$name
#> [1] "chart_data"
#> 
#> $featureCollection$layers[[1]]$title
#> [1] "chart_data"
#> 
#> 
#> 
#> $featureCollection$showLegend
#> [1] TRUE
#> 
#> 
```
