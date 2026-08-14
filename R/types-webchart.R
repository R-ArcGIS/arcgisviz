# S7 classes for ArcGIS Charts WebChart* spec object types with nested/ref'd
# properties (built on top of the enums, Color, and simple types in
# color.R/types-simple.R/types-format-options.R). Generated from
# data-raw/spec-type-registry.json.
#
# Deferred (see data-raw/resolve-spec-types.R deferred_types): geometry
# types. WebChartDataFilters$geometry is typed as class_any until those
# land.
#
# Optional properties (not in the schema's `required` array): scalar/enum
# ones need no special handling - NA already satisfies class_string,
# class_double, class_boolean, and Enum's allow_na. Object-typed optional
# properties get property_union(Type, NULL, default = NULL) since there's
# no NA equivalent for a class instance. Required object-typed properties
# stay strictly typed (WebChartText$content, WebChartGuide$style/start,
# WebChartAxis$labels/valueFormat).

library(S7)

#' @export
ISimpleFillSymbol := new_class(
  properties = list(
    type = s7x::class_string,
    style = ISimpleFillSymbolStyle,
    color = s7x::property_union(Color, NULL, default = NULL),
    outline = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' @export
WebChartTextSymbol := new_class(
  properties = list(
    type = s7x::class_string,
    style = s7x::class_string,
    text = s7x::class_string,
    color = s7x::property_union(Color, NULL, default = NULL),
    backgroundColor = s7x::property_union(Color, NULL, default = NULL),
    borderLineSize = s7x::class_double,
    borderLineColor = s7x::property_union(Color, NULL, default = NULL),
    haloSize = s7x::class_double,
    haloColor = s7x::property_union(Color, NULL, default = NULL),
    verticalAlignment = WebChartTextSymbolVerticalAlignment,
    horizontalAlignment = WebChartTextSymbolHorizontalAlignment,
    rightToLeft = s7x::class_boolean,
    kerning = s7x::class_boolean,
    font = s7x::property_union(IFont, NULL, default = NULL),
    angle = s7x::class_double,
    xoffset = s7x::property_union(s7x::class_string, s7x::class_double),
    yoffset = s7x::property_union(s7x::class_string, s7x::class_double)
  )
)

#' @export
WebChartText := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    content = WebChartTextSymbol
  )
)

#' @export
WebChartCursorCrosshair := new_class(
  properties = list(
    type = s7x::class_string,
    style = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    verticalLineVisible = s7x::class_boolean,
    horizontalLineVisible = s7x::class_boolean
  )
)

#' @export
WebChartLegend := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    title = s7x::property_union(WebChartText, NULL, default = NULL),
    body = s7x::property_union(WebChartTextSymbol, NULL, default = NULL),
    position = WebChartLegendPositions,
    maxHeight = s7x::class_double,
    roundMarkers = s7x::class_boolean
  )
)

#' @export
WebChartGuide := new_class(
  properties = list(
    type = s7x::class_string,
    start = s7x::property_union(s7x::class_string, s7x::class_double),
    end = s7x::property_union(s7x::class_string, s7x::class_double),
    style = s7x::property_union(ISimpleLineSymbol, ISimpleFillSymbol),
    name = s7x::class_string,
    label = s7x::property_union(WebChartTextSymbol, NULL, default = NULL),
    visible = s7x::class_boolean,
    above = s7x::class_boolean,
    tooltipReverseColor = s7x::class_boolean
  )
)

#' @export
WebChartAxis := new_class(
  properties = list(
    type = s7x::class_string,
    visible = s7x::class_boolean,
    isLogarithmic = s7x::class_boolean,
    title = s7x::property_union(WebChartText, NULL, default = NULL),
    valueFormat = s7x::property_union(
      NumberFormatOptions,
      DateTimeFormatOptions,
      CategoryFormatOptions
    ),
    minimum = s7x::class_double,
    maximum = s7x::class_double,
    grid = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    guides = class_list,
    lineSymbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL),
    labels = WebChartText,
    scrollbar = s7x::property_union(
      WebChartAxisScrollBar,
      NULL,
      default = NULL
    ),
    displayZeroLine = s7x::class_boolean,
    integerOnlyValues = s7x::class_boolean,
    displayCursorTooltip = s7x::class_boolean,
    buffer = s7x::class_boolean,
    tickSpacing = s7x::class_double
  )
)

#' @export
WebChartDirectionalDataOrder := new_class(
  properties = list(
    orderType = WebChartOrderDataByTypes,
    orderBy = WebChartSortOrderKinds,
    preferLabel = s7x::class_boolean
  )
)

#' @export
WebChartDataFilters := new_class(
  properties = list(
    distance = s7x::class_double,
    gdbVersion = s7x::class_string,
    geometry = class_any,
    timeExtent = class_list,
    units = WebChartDataFiltersUnits,
    where = s7x::class_string
  )
)

#' @export
WebChartOrderOptions := new_class(
  properties = list(
    series = s7x::property_union(WebChartOrderSeriesBy, NULL, default = NULL),
    data = s7x::property_union(
      WebChartDirectionalDataOrder,
      WebChartPredefinedLabelsDataOrder,
      NULL,
      default = NULL
    ),
    orderByFields = S7::class_character
  )
)
