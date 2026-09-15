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
#'
#' A [WebChartAxis()] with the label orientation only a circular axis needs.
#'
#' @name WebChartRadarChartAxis
#' @return An object of class `WebChartRadarChartAxis`.
#' @examples
#' WebChartRadarChartAxis(
#'   type = "chartAxis",
#'   labelsOrientation = WebChartRadarChartAxisLabelsOrientation("circular")
#' )
#' @export
WebChartRadarChartAxis := new_class(
  WebChartAxis,
  properties = list(
    labelsOrientation = WebChartRadarChartAxisLabelsOrientation
  )
)

#' WebRadarChart
#'
#' A [WebChart()] with no extra properties of its own. It exists so a radar
#' chart is its own class, which is how it inherits the `as_vector()` method
#' that drops unset properties.
#'
#' @name WebRadarChart
#' @return An object of class `WebRadarChart`.
#' @examples
#' WebRadarChart(version = "18.1.0", type = "radarChart")
#'
#' # Built for you by the public API.
#' arc_radar(datasets::penguins, species, body_mass)@webchart
#' @export
WebRadarChart := new_class(WebChart)
