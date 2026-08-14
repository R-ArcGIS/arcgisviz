# S7 classes for the scatter plot's JSON config shape (WebChart + a series
# array of WebChartScatterPlotSeries). Generated from
# data-raw/spec-type-registry.json, scoped to scatter-plot-model.json.
#
# Optional properties (not in the schema's `required` array): scalar/enum
# ones need no special handling - NA already satisfies class_string,
# class_double, class_boolean, and Enum's allow_na. Object-typed optional
# properties get property_union(Type, NULL, default = NULL) since there's
# no NA equivalent for a class instance.

library(S7)

#' @export
WebChartOverlay := new_class(
  properties = list(
    type = s7x::class_string,
    created = s7x::class_boolean,
    visible = s7x::class_boolean,
    symbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' @export
ScatterPlotOverlays := new_class(
  properties = list(
    type = s7x::class_string,
    trendLine = s7x::property_union(WebChartOverlay, NULL, default = NULL)
  )
)

#' @export
ISimpleMarkerSymbol := new_class(
  properties = list(
    type = s7x::class_string,
    style = ISimpleMarkerSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    size = s7x::class_double,
    outline = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    angle = s7x::class_double,
    xoffset = s7x::class_double,
    yoffset = s7x::class_double
  )
)

#' @export
SizePolicy := new_class(
  properties = list(
    type = s7x::class_string,
    scaleType = SizePolicyScaleType,
    field = s7x::class_string,
    minSize = s7x::class_double,
    maxSize = s7x::class_double
  )
)

#' @export
WebChartScatterPlotSeries := new_class(
  properties = list(
    type = s7x::class_string,
    y = s7x::class_string,
    markerSymbol = s7x::property_union(
      ISimpleMarkerSymbol,
      NULL,
      default = NULL
    ),
    overlays = s7x::property_union(ScatterPlotOverlays, NULL, default = NULL),
    sizePolicy = s7x::property_union(SizePolicy, NULL, default = NULL),
    id = s7x::class_string,
    visible = s7x::class_boolean,
    dataTooltipVisible = s7x::class_boolean,
    dataTooltipReverseColor = s7x::class_boolean,
    dataTooltipValueFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    dataTooltipPercentFormat = s7x::property_union(
      NumberFormatOptions,
      NULL,
      default = NULL
    ),
    dataTooltipDateFormat = s7x::property_union(
      DateTimeFormatOptions,
      NULL,
      default = NULL
    ),
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean
  )
)
