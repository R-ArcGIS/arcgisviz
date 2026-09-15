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
#
# `type` is the REST discriminator and is fixed by the class, so it defaults
# rather than being restated at every call site - a renderer built by hand
# and handed to add_layer() would otherwise serialize without one.

library(S7)

# One shared legendOptions object in the web map spec, referenced by the
# colorInfo visual variable and by uniqueValueRenderer. @arcgis/core splits it
# into VisualVariableLegendOptions/SizeVariableLegendOptions - follow the spec.
#
# dotLabel/unit (dotDensity) and minLabel/maxLabel (heatmap) are omitted: they
# belong to renderer families this package does not model, the same reason
# authoringInfo is omitted throughout.

#' ILegendOptions
#'
#' How a renderer or visual variable describes itself in a legend. Note
#' `showLegend` is unavailable under `IUniqueValueRenderer`, per the spec.
#'
#' @name ILegendOptions
#' @return An object of class `ILegendOptions`.
#' @seealso [new_legend_options()], which builds one from friendly names.
#' @examples
#' ILegendOptions(
#'   title = "Body mass (g)",
#'   showLegend = TRUE,
#'   order = ILegendOptionsOrder("descendingValues")
#' )
#' @export
ILegendOptions := new_class(
  properties = list(
    title = s7x::class_string,
    showLegend = s7x::class_boolean,
    order = ILegendOptionsOrder
  )
)

#' IColorStop
#'
#' One stop on a colour ramp: the value it sits at, and the colour there. The
#' client interpolates between stops.
#'
#' @name IColorStop
#' @return An object of class `IColorStop`.
#' @examples
#' IColorStop(
#'   value = 3000,
#'   color = Color(r = 237, g = 248, b = 251, a = 1),
#'   label = "Lightest"
#' )
#' @export
IColorStop := new_class(
  properties = list(
    value = s7x::class_float,
    color = Color,
    label = s7x::class_string
  )
)

#' IColorVisualVariable
#'
#' A continuous colour mapping carried on a renderer. This is what
#' [set_color()] builds for a numeric column.
#'
#' @name IColorVisualVariable
#' @return An object of class `IColorVisualVariable`.
#' @examples
#' IColorVisualVariable(
#'   field = "body_mass",
#'   stops = list(
#'     IColorStop(value = 2700, color = Color(r = 237, g = 248, b = 251, a = 1)),
#'     IColorStop(value = 6300, color = Color(r = 8, g = 81, b = 156, a = 1))
#'   ),
#'   legendOptions = ILegendOptions(title = "Body mass (g)")
#' )
#' @export
IColorVisualVariable := new_class(
  properties = list(
    type = s7x::property_scalar(class_character, default = "colorInfo"),
    field = s7x::class_string,
    stops = class_list,
    valueExpression = s7x::class_string,
    valueExpressionTitle = s7x::class_string,
    normalizationField = s7x::class_string,
    legendOptions = s7x::property_union(ILegendOptions, NULL, default = NULL)
  )
)

#' ISizeStop
#'
#' One stop on a size ramp: the value it sits at, and the symbol size there.
#' The client interpolates between stops. The spec allows 2 to 6.
#'
#' @name ISizeStop
#' @return An object of class `ISizeStop`.
#' @examples
#' ISizeStop(value = 5000, size = 4, label = "5,000")
#' @export
ISizeStop := new_class(
  properties = list(
    value = s7x::class_float,
    size = s7x::class_float,
    label = s7x::class_string
  )
)

# axis/useSymbolValue (ObjectSymbol3DLayer) and valueUnit/valueRepresentation
# (real-world sizes) belong to families this package does not model, as does
# `target` and the nested minSize/maxSize object that scale-dependent sizing
# needs. Note the spec's discriminator is "sizeInfo"; @arcgis/core says "size".

#' ISizeVisualVariable
#'
#' A continuous size mapping carried on a renderer. This is what
#' [add_layer()] builds for a numeric `size` column.
#'
#' @name ISizeVisualVariable
#' @return An object of class `ISizeVisualVariable`.
#' @examples
#' ISizeVisualVariable(
#'   field = "POPULATION",
#'   stops = list(
#'     ISizeStop(value = 1e5, size = 6),
#'     ISizeStop(value = 9e6, size = 36)
#'   ),
#'   legendOptions = ILegendOptions(title = "Population")
#' )
#' @export
ISizeVisualVariable := new_class(
  properties = list(
    type = s7x::property_scalar(class_character, default = "sizeInfo"),
    field = s7x::class_string,
    stops = class_list,
    minSize = s7x::class_float,
    maxSize = s7x::class_float,
    minDataValue = s7x::class_float,
    maxDataValue = s7x::class_float,
    valueExpression = s7x::class_string,
    valueExpressionTitle = s7x::class_string,
    normalizationField = s7x::class_string,
    legendOptions = s7x::property_union(ILegendOptions, NULL, default = NULL)
  )
)

#' ISimpleRenderer
#'
#' One symbol for every feature, optionally varied by a visual variable.
#' `type` is fixed by the class, so it is never restated at a call site.
#'
#' @name ISimpleRenderer
#' @return An object of class `ISimpleRenderer`.
#' @seealso [new_renderer()], which builds one from friendly names and colours.
#' @examples
#' ISimpleRenderer(
#'   symbol = ISimpleFillSymbol(color = Color(r = 184, g = 40, b = 40, a = 1))
#' )
#'
#' # With a continuous colour mapping over the top.
#' ISimpleRenderer(
#'   symbol = ISimpleMarkerSymbol(size = 8),
#'   visualVariables = list(IColorVisualVariable(field = "body_mass"))
#' )
#' @export
ISimpleRenderer := new_class(
  properties = list(
    type = s7x::property_scalar(class_character, default = "simple"),
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
#'
#' One level of a [IUniqueValueRenderer()] and the symbol drawn for it.
#'
#' @name IUniqueValueInfo
#' @return An object of class `IUniqueValueInfo`.
#' @examples
#' IUniqueValueInfo(
#'   value = "Adelie",
#'   label = "Adelie penguin",
#'   symbol = ISimpleFillSymbol(color = Color(r = 78, g = 121, b = 167, a = 1))
#' )
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
#'
#' One symbol per distinct value of `field1`. This is what [set_color()]
#' builds for a grouping column, and what a map uses for any non-numeric one.
#'
#' @name IUniqueValueRenderer
#' @return An object of class `IUniqueValueRenderer`.
#' @seealso [new_renderer()], which builds one from friendly names and colours.
#' @examples
#' IUniqueValueRenderer(
#'   field1 = "species",
#'   uniqueValueInfos = list(
#'     IUniqueValueInfo(
#'       value = "Adelie",
#'       symbol = ISimpleFillSymbol(
#'         color = Color(r = 78, g = 121, b = 167, a = 1)
#'       )
#'     ),
#'     IUniqueValueInfo(
#'       value = "Gentoo",
#'       symbol = ISimpleFillSymbol(
#'         color = Color(r = 242, g = 142, b = 43, a = 1)
#'       )
#'     )
#'   )
#' )
#' @export
IUniqueValueRenderer := new_class(
  properties = list(
    type = s7x::property_scalar(class_character, default = "uniqueValue"),
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
    uniqueValueInfos = class_list,
    visualVariables = class_list,
    legendOptions = s7x::property_union(ILegendOptions, NULL, default = NULL)
  )
)
