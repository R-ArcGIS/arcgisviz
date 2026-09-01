#' @include types-gauge-chart.R
NULL

# S7 classes for the radar chart's axis and its own WebChart subtype
# (WebRadarChart). Source of truth:
# node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts.
#
# There is no radar series class: the spec declares
# `WebChartRadarChartSeries = WebChartLineChartSeries<"radarSeries">`
# (web-chart.d.ts:1236), the same interface with a different `type`. k()
# (dist/chunks/index2.js:601) routes radar through the bar/line subtype
# detection too, so it aggregates and splits the same way a line does.

library(S7)

#' WebChartRadarChartAxis
#' @name WebChartRadarChartAxis
#' @export
WebChartRadarChartAxis := new_class(
  WebChartAxis,
  properties = list(
    labelsOrientation = WebChartRadarChartAxisLabelsOrientation
  )
)

#' WebRadarChart
#' @name WebRadarChart
#' @export
WebRadarChart := new_class(WebChart)
