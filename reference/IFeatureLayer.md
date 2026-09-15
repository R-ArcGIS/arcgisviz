# IFeatureLayer

A feature layer, either backed by a `featureCollection` stored in the
web map or by a service `url`. Built by
[`as_feature_layer()`](http://r.esri.com/arcgisviz/reference/as_feature_layer.md).

## Value

An object of class `IFeatureLayer`.

## See also

[`as_feature_layer()`](http://r.esri.com/arcgisviz/reference/as_feature_layer.md),
which builds one from a data frame or an `sf` object.

## Examples

``` r
df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))

as_feature_layer(df, name = "penguins")
#> <arcgisviz::IFeatureLayer>
#>  @ id                   : chr "arcgisviz-layer"
#>  @ name                 : chr NA
#>  @ itemId               : chr NA
#>  @ layerType            : chr "ArcGISFeatureLayer"
#>  @ maxScale             : num NA
#>  @ minScale             : num NA
#>  @ opacity              : num NA
#>  @ showLegend           : logi NA
#>  @ title                : chr "penguins"
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
#>  ..  .. .. ..$ name          : chr "penguins"
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
#>  ..  .. ..$ name           : chr "penguins"
#>  ..  .. ..$ title          : chr "penguins"
#>  .. $ showLegend: logi TRUE
#>  @ featureCollectionType: NULL
#>  @ layerDefinition      : NULL
#>  @ mode                 : int NA
#>  @ popupInfo            : NULL
#>  @ refreshInterval      : num NA
#>  @ showLabels           : logi NA
#>  @ visibleLayers        : int(0) 
#>  @ timeAnimation        : logi NA

# Or by hand, when the pieces are already assembled.
IFeatureLayer(
  id = "counties",
  name = "Counties",
  layerType = "ArcGISFeatureLayer",
  opacity = 0.8,
  visibility = TRUE
)
#> <arcgisviz::IFeatureLayer>
#>  @ id                   : chr "counties"
#>  @ name                 : chr "Counties"
#>  @ itemId               : chr NA
#>  @ layerType            : chr "ArcGISFeatureLayer"
#>  @ maxScale             : num NA
#>  @ minScale             : num NA
#>  @ opacity              : num 0.8
#>  @ showLegend           : logi NA
#>  @ title                : chr NA
#>  @ visibility           : logi TRUE
#>  @ url                  : chr NA
#>  @ capabilities         : chr NA
#>  @ definitionEditor     : NULL
#>  @ disablePopup         : logi NA
#>  @ featureCollection    : NULL
#>  @ featureCollectionType: NULL
#>  @ layerDefinition      : NULL
#>  @ mode                 : int NA
#>  @ popupInfo            : NULL
#>  @ refreshInterval      : num NA
#>  @ showLabels           : logi NA
#>  @ visibleLayers        : int(0) 
#>  @ timeAnimation        : logi NA
```
