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
    type = s7x::property_scalar(class_character, default = "colorInfo"),
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
    uniqueValueInfos = class_list
  )
)

# Friendly names, kebab-case and without the REST prefixes, mapped to the
# class each one builds. The class supplies its own `type` discriminator.
renderer_classes <- list(
  simple = ISimpleRenderer,
  `unique-value` = IUniqueValueRenderer
)

#' Create a renderer
#'
#' Builds a renderer to hand to [add_renderer()]. `type` picks which kind and
#' `...` sets that kind's properties, so this is one function instead of
#' remembering which class goes with which symbology.
#'
#' A `"simple"` renderer draws every feature the same way, optionally varying
#' colour by a `colorInfo` visual variable. A `"unique-value"` renderer draws
#' one symbol per value of a field.
#'
#' @param type default `"simple"`. Defines which renderer to build, either
#'   `"simple"` or `"unique-value"`.
#' @param ... Defines the renderer's properties, all named. See
#'   [ISimpleRenderer] and [IUniqueValueRenderer] for what each kind takes.
#' @return An [ISimpleRenderer] or an [IUniqueValueRenderer].
#' @examples
#' new_renderer("simple", symbol = ISimpleMarkerSymbol(size = 8))
#'
#' new_renderer("unique-value", field1 = "species")
#' @export
new_renderer <- function(type = "simple", ...) {
  call <- rlang::caller_env()
  type <- rlang::arg_match0(type, names(renderer_classes), error_call = call)
  args <- rlang::list2(...)
  cls <- renderer_classes[[type]]

  # A positional value would land on `type`, the first property, and quietly
  # replace the discriminator.
  unnamed <- rlang::names2(args) == ""
  if (any(unnamed)) {
    cli::cli_abort(
      c(
        "Every argument in {.arg ...} must be named.",
        "x" = "Argument{?s} {.val {which(unnamed)}} {?is/are} not."
      ),
      call = call
    )
  }

  known <- names(S7::props(cls()))
  unknown <- setdiff(names(args), known)
  if (!rlang::is_empty(unknown)) {
    cli::cli_abort(
      c(
        "{.arg {unknown}} {?is not a/are not} propert{?y/ies} of a
         {.val {type}} renderer.",
        "i" = "It takes {.arg {setdiff(known, 'type')}}."
      ),
      call = call
    )
  }

  rlang::exec(cls, !!!args)
}
