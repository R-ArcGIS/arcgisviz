# Set a layer's renderer

Attaches a renderer to a layer built by
[`as_feature_layer()`](http://r.esri.com/arcgisviz/reference/as_feature_layer.md),
so that a symbology this package does not expose can still be handed to
[`add_layer()`](http://r.esri.com/arcgisviz/reference/add_layer.md).

## Usage

``` r
add_renderer(layer, renderer)
```

## Arguments

- layer:

  Defines which
  [IFeatureLayer](http://r.esri.com/arcgisviz/reference/IFeatureLayer.md)
  to modify.

- renderer:

  Defines the renderer, an
  [ISimpleRenderer](http://r.esri.com/arcgisviz/reference/ISimpleRenderer.md)
  or an
  [IUniqueValueRenderer](http://r.esri.com/arcgisviz/reference/IUniqueValueRenderer.md).

## Value

`layer`, with the renderer set on its `layerDefinition`.

## Examples

``` r
df <- data.frame(species = c("a", "b"), mass = c(1, 5))

as_feature_layer(df) |>
  add_renderer(ISimpleRenderer(symbol = ISimpleMarkerSymbol(size = 8)))
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
#>  ..  .. .. ..$ features        :List of 2
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
#>  ..  .. ..$ layerDefinition:List of 8
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
#>  ..  .. .. ..$ drawingInfo   :List of 1
#>  ..  .. .. .. ..$ renderer: <arcgisviz::ISimpleRenderer>
#>  ..  .. .. .. .. ..@ type              : chr "simple"
#>  ..  .. .. .. .. ..@ symbol            : <arcgisviz::ISimpleMarkerSymbol>
#>  .. .. .. .. .. .. .. @ type   : chr "esriSMS"
#>  .. .. .. .. .. .. .. @ style  : <arcgisviz::SimpleMarkerSymbolStyle>
#>  .. .. .. .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. .. .. .. @ variants: chr [1:6] "esriSMSCircle" "esriSMSCross" "esriSMSDiamond" "esriSMSSquare" ...
#>  .. .. .. .. .. .. .. .. @ allow_na: logi TRUE
#>  .. .. .. .. .. .. .. @ color  : NULL
#>  .. .. .. .. .. .. .. @ size   : num 8
#>  .. .. .. .. .. .. .. @ outline: NULL
#>  .. .. .. .. .. .. .. @ angle  : num NA
#>  .. .. .. .. .. .. .. @ xoffset: num NA
#>  .. .. .. .. .. .. .. @ yoffset: num NA
#>  ..  .. .. .. .. ..@ visualVariables   : list()
#>  ..  .. .. .. .. ..@ label             : chr NA
#>  ..  .. .. .. .. ..@ description       : chr NA
#>  ..  .. .. .. .. ..@ rotationExpression: chr NA
#>  ..  .. .. .. .. ..@ rotationType      : <arcgisviz::IRendererRotationType>
#>  .. .. .. .. .. .. .. @ value   : chr NA
#>  .. .. .. .. .. .. .. @ variants: chr [1:2] "arithmetic" "geographic"
#>  .. .. .. .. .. .. .. @ allow_na: logi TRUE
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
