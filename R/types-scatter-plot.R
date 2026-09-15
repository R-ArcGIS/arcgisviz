#' @include types-bar-chart.R
NULL

# S7 classes for the scatterplot's JSON config shape (WebChart + a series
# array of WebChartScatterplotSeries). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts (see
# CLAUDE.md).
#
# Renamed from the old charts-spec-derived version to match the current
# spec's exact names: WebChartScatterPlotSeries -> WebChartScatterplotSeries,
# ScatterPlotOverlays -> ScatterplotOverlays (lowercase "p" in "plot" both
# times). New property: additionalTooltipFields.
#
# Optional properties (not in the interface's `?`-marked properties): scalar/
# enum ones need no special handling - NA already satisfies class_string,
# class_float, class_boolean, and Enum's allow_na. Object-typed optional
# properties get property_union(Type, NULL, default = NULL) since there's
# no NA equivalent for a class instance.

library(S7)

#' WebChartOverlay
#'
#' One overlay drawn over a chart's marks, such as a trend line. `created`
#' being true is also what gives a scatterplot or histogram a legend.
#'
#' @name WebChartOverlay
#' @return An object of class `WebChartOverlay`.
#' @examples
#' WebChartOverlay(
#'   type = "chartOverlay",
#'   created = TRUE,
#'   visible = TRUE,
#'   symbol = ISimpleLineSymbol(
#'     style = SimpleLineSymbolStyle("esriSLSDash"),
#'     width = 1
#'   )
#' )
#' @export
WebChartOverlay <- new_class(
  "WebChartOverlay",
  properties = list(
    type = s7x::class_string,
    created = s7x::class_boolean,
    visible = s7x::class_boolean,
    symbol = s7x::property_union(ISimpleLineSymbol, NULL, default = NULL)
  )
)

#' ScatterplotOverlays
#'
#' The overlays a scatterplot supports - a trend line, and nothing else.
#'
#' @name ScatterplotOverlays
#' @return An object of class `ScatterplotOverlays`.
#' @examples
#' ScatterplotOverlays(
#'   type = "scatterPlotOverlays",
#'   trendLine = WebChartOverlay(created = TRUE, visible = TRUE)
#' )
#' @export
ScatterplotOverlays <- new_class(
  "ScatterplotOverlays",
  properties = list(
    type = s7x::class_string,
    trendLine = s7x::property_union(WebChartOverlay, NULL, default = NULL)
  )
)

#' SizePolicy
#'
#' Scales marker area by a numeric column. Declared on the scatterplot series
#' alone, which is why [set_size()] works on no other chart type.
#'
#' @name SizePolicy
#' @return An object of class `SizePolicy`.
#' @examples
#' SizePolicy(
#'   type = "sizeScale",
#'   field = "body_mass",
#'   scaleType = SizePolicyScaleTypes("linear"),
#'   minSize = 4,
#'   maxSize = 18
#' )
#' @export
SizePolicy <- new_class(
  "SizePolicy",
  properties = list(
    type = s7x::class_string,
    scaleType = SizePolicyScaleTypes,
    field = s7x::class_string,
    minSize = s7x::class_float,
    maxSize = s7x::class_float
  )
)

#' WebChartScatterplotSeries
#'
#' The scatterplot's series. It is the only one in the spec that can name
#' extra tooltip fields (`additionalTooltipFields`) or size its markers by a
#' column (`sizePolicy`), which is why [set_size()] and the native tooltip
#' path are scatter-only.
#'
#' @name WebChartScatterplotSeries
#' @return An object of class `WebChartScatterplotSeries`.
#' @examples
#' WebChartScatterplotSeries(
#'   type = "scatterSeries",
#'   id = "series0",
#'   name = "bill_dep",
#'   x = "bill_len",
#'   y = "bill_dep",
#'   additionalTooltipFields = c("island", "body_mass"),
#'   sizePolicy = SizePolicy(type = "sizeScale", field = "body_mass")
#' )
#' @export
WebChartScatterplotSeries <- new_class(
  "WebChartScatterplotSeries",
  properties = list(
    type = s7x::class_string,
    y = s7x::class_string,
    markerSymbol = s7x::property_union(
      ISimpleMarkerSymbol,
      NULL,
      default = NULL
    ),
    overlays = s7x::property_union(ScatterplotOverlays, NULL, default = NULL),
    sizePolicy = s7x::property_union(SizePolicy, NULL, default = NULL),
    additionalTooltipFields = S7::class_character,
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
    dataTooltipFontSize = s7x::class_float,
    name = s7x::class_string,
    query = s7x::property_union(WebChartSeriesQuery, NULL, default = NULL),
    x = s7x::class_string,
    dataLabels = s7x::property_union(WebChartText, NULL, default = NULL),
    assignToSecondValueAxis = s7x::class_boolean
  )
)
