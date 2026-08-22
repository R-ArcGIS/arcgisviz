#' @include types-statistics.R
NULL

# IFeatureLayer (rest-js-types.d.ts:1953), flattening its ILayer (:1324) and
# ISupportsTime (:1359) parents the same way the series classes flatten theirs.
# This is WebChart$iLayer and the layer <arcgis-map> builds a FeatureLayer from.
#
# `featureCollection` is `any` in the spec; `layerDefinition` and `popupInfo`
# are bare lists because arcgisutils::as_layer_definition() already builds them
# and there is no popupInfo helper anywhere.

library(S7)

#' IFeatureLayer
#'
#' A feature layer, either backed by a `featureCollection` stored in the web
#' map or by a service `url`. Built by [as_feature_layer()].
#'
#' @name IFeatureLayer
#' @export
IFeatureLayer := new_class(
  properties = list(
    id = s7x::class_string,
    name = s7x::class_string,
    itemId = s7x::class_string,
    layerType = s7x::class_string,
    maxScale = s7x::class_float,
    minScale = s7x::class_float,
    opacity = s7x::property_range(0, 1),
    showLegend = s7x::class_boolean,
    title = s7x::class_string,
    visibility = s7x::class_boolean,
    url = s7x::class_string,
    capabilities = s7x::class_string,
    definitionEditor = class_any,
    disablePopup = s7x::class_boolean,
    featureCollection = class_any,
    featureCollectionType = s7x::property_union(
      IFeatureLayerFeatureCollectionType,
      NULL,
      default = NULL
    ),
    layerDefinition = class_any,
    mode = s7x::property_range_discrete(0, 2),
    popupInfo = class_any,
    refreshInterval = s7x::class_float,
    showLabels = s7x::class_boolean,
    visibleLayers = S7::class_numeric,
    timeAnimation = s7x::class_boolean
  )
)
