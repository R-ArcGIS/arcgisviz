# Build a feature layer from a data frame

Wraps a data frame as a self-contained client side feature collection.
This is the `iLayer` a chart reads and the layer a map draws. No live
feature service is involved.

## Usage

``` r
as_feature_layer(
  .data,
  name = "layer_data",
  title = name,
  id = "arcgisviz-layer",
  drawing_info = NULL,
  opacity = NULL,
  visibility = NULL
)
```

## Arguments

- .data:

  Defines which data frame or `sf` object to convert.

- name:

  default `"layer_data"`. Defines what the layer is named.

- title:

  default `name`. Defines the human readable layer title.

- id:

  default `"arcgisviz-layer"`. Defines the unique layer id.

- drawing_info:

  default `NULL`. Defines how features are symbolized, as a list holding
  a `renderer`.

- opacity:

  default `NULL`. Defines the layer opacity, from `0` to `1`.

- visibility:

  default `NULL`. Defines whether the layer starts visible.

## Value

An
[IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md).

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

as_feature_layer(df)
#> <arcgisviz::IFeatureLayer>
#>  @ id                   : chr "arcgisviz-layer"
#>  @ name                 : chr NA
#>  @ itemId               : chr NA
#>  @ layerType            : chr "ArcGISFeatureLayer"
#>  @ maxScale             : num NA
#>  @ minScale             : num NA
#>  @ opacity              : num NA
#>  @ showLegend           : logi NA
#>  @ title                : chr "layer_data"
#>  @ visibility           : logi NA
#>  @ url                  : chr NA
#>  @ capabilities         : chr NA
#>  @ definitionEditor     : NULL
#>  @ disablePopup         : logi NA
#>  @ featureCollection    :List of 2
#>  .. $ layers    :List of 1
#>  ..  ..$ :List of 4
#>  ..  .. ..$ featureSet     :List of 2
#>  ..  .. .. ..$ spatialReference: Named list()
#>  ..  .. .. ..$ features        :List of 3
#>  ..  .. .. .. ..$ :List of 1
#>  ..  .. .. .. .. ..$ attributes:List of 3
#>  ..  .. .. .. .. .. ..$ mass     : num 1
#>  ..  .. .. .. .. .. ..$ object_id: num 1
#>  ..  .. .. .. .. .. ..$ species  : chr "a"
#>  ..  .. .. .. ..$ :List of 1
#>  ..  .. .. .. .. ..$ attributes:List of 3
#>  ..  .. .. .. .. .. ..$ mass     : num 5
#>  ..  .. .. .. .. .. ..$ object_id: num 2
#>  ..  .. .. .. .. .. ..$ species  : chr "b"
#>  ..  .. .. .. ..$ :List of 1
#>  ..  .. .. .. .. ..$ attributes:List of 3
#>  ..  .. .. .. .. .. ..$ mass     : num 3
#>  ..  .. .. .. .. .. ..$ object_id: num 3
#>  ..  .. .. .. .. .. ..$ species  : chr "c"
#>  ..  .. ..$ layerDefinition:List of 7
#>  ..  .. .. ..$ name          : chr "layer_data"
#>  ..  .. .. ..$ objectIdField : chr "object_id"
#>  ..  .. .. ..$ fields        :'data.frame':  3 obs. of  6 variables:
#>  ..  .. .. .. ..$ name    : chr [1:3] "object_id" "species" "mass"
#>  ..  .. .. .. ..$ type    : chr [1:3] "esriFieldTypeOID" "esriFieldTypeString" "esriFieldTypeDouble"
#>  ..  .. .. .. ..$ alias   : chr [1:3] "object_id" "species" "mass"
#>  ..  .. .. .. ..$ length  : logi [1:3] NA NA NA
#>  ..  .. .. .. ..$ editable: logi [1:3] FALSE TRUE TRUE
#>  ..  .. .. .. ..$ nullable: logi [1:3] FALSE TRUE TRUE
#>  ..  .. .. ..$ hasAttachments: logi FALSE
#>  ..  .. .. ..$ maxScale      : num 0
#>  ..  .. .. ..$ minScale      : num 0
#>  ..  .. .. ..$ type          : chr "Table"
#>  ..  .. ..$ name           : chr "layer_data"
#>  ..  .. ..$ title          : chr "layer_data"
#>  .. $ showLegend: logi TRUE
#>  @ featureCollectionType: NULL
#>  @ layerDefinition      : NULL
#>  @ mode                 : int NA
#>  @ popupInfo            : NULL
#>  @ refreshInterval      : num NA
#>  @ showLabels           : logi NA
#>  @ visibleLayers        : int(0) 
#>  @ timeAnimation        : logi NA
```
