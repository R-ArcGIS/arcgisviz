# Public, user-facing chart-building API. Wraps the internal S7 type layer
# (R/types-*.R) - none of those classes, or their s7x::Enum values, are
# meant to be constructed or referenced by users of this package. Friendly
# values here are kebab-case with no spec-internal prefixes ("side-by-side",
# not "sideBySide"; "bar", not "barChart"/"barSeries") and get translated to
# the exact spec values internally.
#
# Core pipe: arc_chart(.data) |> set_type() |> set_x() |> set_y() |> ...
# arc_bar()/arc_scatter()/arc_line() are thin sugar around that pipe.
# x/y use tidy eval (bare column names, via {{ }}/rlang::ensym()).

library(S7)

#' ArcChart
#' @name ArcChart
#' @export
ArcChart := new_class(
  properties = list(
    data = S7::class_any,
    chart_type = s7x::class_string,
    webchart = s7x::property_union(WebChart, NULL, default = NULL)
  )
)

# friendly kebab/plain type name -> {model_type (ModelTypes value, for the
# future widget bridge), series_type (the series' own `type` discriminator),
# series_class (which WebChart*Series S7 class to build)}
chart_type_map <- list(
  bar = list(
    model_type = "barChart",
    series_type = "barSeries",
    series_class = WebChartBarChartSeries
  ),
  scatter = list(
    model_type = "scatterplot",
    series_type = "scatterSeries",
    series_class = WebChartScatterplotSeries
  ),
  line = list(
    model_type = "lineChart",
    series_type = "lineSeries",
    series_class = WebChartLineChartSeries
  )
)

#' Start a chart
#'
#' @param .data A data frame (or similar) the chart's fields will come from.
#' @return An `ArcChart`. Pipe it into [set_type()] before [set_x()]/[set_y()].
#' @export
arc_chart <- function(.data) {
  ArcChart(data = .data)
}

#' Set a chart's type
#'
#' @param chart An `ArcChart`, from [arc_chart()].
#' @param type One of `"bar"`, `"scatter"`, `"line"`.
#' @return `chart`, with a fresh single series of the matching type.
#' @export
set_type <- function(chart, type) {
  type <- rlang::arg_match0(type, names(chart_type_map))
  spec <- chart_type_map[[type]]

  chart@chart_type <- type
  chart@webchart <- WebChart(
    version = "25.1.0",
    type = "chart",
    series = list(
      spec$series_class(
        type = spec$series_type,
        id = "series1",
        name = "series1"
      )
    )
  )
  chart
}

check_chart_type_set <- function(chart) {
  if (is.null(chart@webchart)) {
    stop("set_type() must be called before set_x()/set_y().", call. = FALSE)
  }
}

check_column <- function(chart, col) {
  if (!is.null(chart@data) && !(col %in% names(chart@data))) {
    stop(sprintf("Column '%s' not found in `.data`.", col), call. = FALSE)
  }
}

#' Map a column to a chart's x/y field
#'
#' @param chart An `ArcChart`, from [arc_chart()] with [set_type()] already
#'   called.
#' @param x,y A bare column name from `chart`'s data (tidy eval).
#' @return `chart`, with the field mapping set on its (single, current)
#'   series.
#' @export
set_x <- function(chart, x) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(x))
  check_column(chart, col)
  chart@webchart@series[[1]]@x <- col
  chart
}

#' @rdname set_x
#' @export
set_y <- function(chart, y) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(y))
  check_column(chart, col)
  chart@webchart@series[[1]]@y <- col
  chart
}

#' Bar chart
#'
#' @inheritParams arc_chart
#' @param x,y Bare column names from `.data` (tidy eval).
#' @return An `ArcChart`.
#' @export
arc_bar <- function(.data, x, y) {
  arc_chart(.data) |> set_type("bar") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Scatterplot
#'
#' @inheritParams arc_bar
#' @export
arc_scatter <- function(.data, x, y) {
  arc_chart(.data) |> set_type("scatter") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Line chart
#'
#' @inheritParams arc_bar
#' @export
arc_line <- function(.data, x, y) {
  arc_chart(.data) |> set_type("line") |> set_x({{ x }}) |> set_y({{ y }})
}
