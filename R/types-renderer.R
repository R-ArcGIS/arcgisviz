#' @include types-simple.R
NULL

# S7 classes for the renderers WebChart$chartRenderer accepts. Unlike every
# other type in this package these do NOT come from
# @arcgis/charts-components' spec - IDrawingInfo$renderer is `any` there
# (dist/spec/rest-js-types.d.ts:1547). Source of truth is the web *map*
# specification, <https://developers.arcgis.com/web-map-specification/>
# objects/simpleRenderer/, /colorInfo_visualVariable/, /uniqueValueRenderer/,
# plus @arcgis/core/renderers/. The web *scene* spec's renderers are the wrong
# ones - they reference Symbol3D and only draw in a SceneView.
#
# The chart hands this to @arcgis/core's jsonUtils.fromJSON() and then resolves
# a symbol per data item via symbolUtils.getDisplayedSymbol()
# (dist/chunks/index2.js:1541, :1612), so these carry REST discriminators
# ("simple", "colorInfo", "uniqueValue", esriSMS) - not the runtime class ones
# ("simple-marker", "color").
#
# `authoringInfo` is omitted throughout: authoring metadata, nothing on this
# path reads it.

library(S7)

#' IColorStop
#' @name IColorStop
#' @export
IColorStop := new_class(
  properties = list(
    value = s7x::class_double,
    color = Color,
    label = s7x::class_string
  )
)

#' IColorVisualVariable
#' @name IColorVisualVariable
#' @export
IColorVisualVariable := new_class(
  properties = list(
    type = s7x::class_string,
    field = s7x::class_string,
    stops = class_list,
    valueExpression = s7x::class_string,
    valueExpressionTitle = s7x::class_string,
    normalizationField = s7x::class_string,
    legendOptions = class_any
  )
)

#' ISimpleRenderer
#' @name ISimpleRenderer
#' @export
ISimpleRenderer := new_class(
  properties = list(
    type = s7x::class_string,
    symbol = s7x::property_union(
      ISimpleMarkerSymbol,
      ISimpleFillSymbol,
      ISimpleLineSymbol,
      NULL,
      default = NULL
    ),
    visualVariables = class_list,
    label = s7x::class_string,
    description = s7x::class_string,
    rotationExpression = s7x::class_string,
    rotationType = IRendererRotationType
  )
)

#' IUniqueValueInfo
#' @name IUniqueValueInfo
#' @export
IUniqueValueInfo := new_class(
  properties = list(
    value = s7x::class_string,
    label = s7x::class_string,
    description = s7x::class_string,
    symbol = s7x::property_union(
      ISimpleMarkerSymbol,
      ISimpleFillSymbol,
      ISimpleLineSymbol,
      NULL,
      default = NULL
    )
  )
)

#' IUniqueValueRenderer
#' @name IUniqueValueRenderer
#' @export
IUniqueValueRenderer := new_class(
  properties = list(
    type = s7x::class_string,
    field1 = s7x::class_string,
    field2 = s7x::class_string,
    field3 = s7x::class_string,
    fieldDelimiter = s7x::class_string,
    defaultSymbol = s7x::property_union(
      ISimpleMarkerSymbol,
      ISimpleFillSymbol,
      ISimpleLineSymbol,
      NULL,
      default = NULL
    ),
    defaultLabel = s7x::class_string,
    uniqueValueInfos = class_list
  )
)
