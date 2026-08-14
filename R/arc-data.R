# Data transfer: turn an R data.frame + our S7 config into the exact JSON
# payload the browser's createModel() consumes.
#
# The contract, read out of @arcgis/charts-components' own dist (5.1.x):
#
# * createModel() accepts several prop combinations
#   (dist/model/shared/setup-utils.d.ts); the one we want is
#   `ILayerAndSourcelessConfig` = { iLayer, config }.
# * `config` is a `ChartConfig<T>` (dist/utils/types/index.d.ts), which is
#   `Omit<WebChart, "legend"|"series"> & { series: ...[] }` - i.e. exactly
#   our `WebChart` S7 class. No separate `chartType` is needed: the model
#   type is derived from `config$series[[1]]$type`
#   (dist/chunks/model-types.js), and a series list holding both a
#   `lineSeries` and a `barSeries` is auto-detected as a combo chart
#   (dist/chunks/series-types.js).
# * `iLayer` must be an `IFeatureLayer` (`layerType = "ArcGISFeatureLayer"`).
#   The converter (`gi`, dist/chunks/index2.js) reads exactly these paths
#   off it, and nothing else, for a client-side collection:
#       featureCollection$layers[[1]]$featureSet       -> FeatureLayer$source
#       featureCollection$layers[[1]]$layerDefinition$fields
#                                    ...$objectIdField
#                                    ...$geometryType      (optional)
#                                    ...$spatialReference  (optional)
#   which is precisely the shape `arcgisutils::as_feature_collection()`
#   produces from `arcgisutils::as_layer()`.
#
# Everything here is a single-shot conversion - the whole collection goes
# over in one payload. `arcgisutils::as_esri_features()` produces the
# per-feature JSON that a future batched path could stream in incrementally
# (cf. the SDK's own large-collection sample, which does that via
# `applyEdits()` on a live layer), but nothing needs it yet.

#' Build an `IFeatureLayer` from a data frame
#'
#' Wraps `.data` as a self-contained client-side feature collection layer -
#' the `iLayer` argument of the JS `createModel()`. No live feature service
#' is involved.
#'
#' @param .data A data frame (or `sf` object) to convert.
#' @param name,title Layer name and human-readable title.
#' @param id A unique layer id.
#' @return A list with the `IFeatureLayer` JSON shape.
#' @export
as_chart_layer <- function(
  .data,
  name = "chart_data",
  title = name,
  id = "arcgisviz-layer"
) {
  layer <- arcgisutils::as_layer(.data, name = name, title = title)

  list(
    id = id,
    title = title,
    layerType = "ArcGISFeatureLayer",
    featureCollection = arcgisutils::as_feature_collection(
      layers = list(layer)
    )
  )
}

# `Color` is stored as four scalar doubles (r/g/b/a) rather than the spec's
# raw [r,g,b,a] tuple - a deliberate exception (see CLAUDE.md). Undo that
# here, on the way out, so the wire format matches the spec. An
# all-or-partly-NA Color isn't a real color, so it falls through to normal
# compaction and gets dropped.
is_color_list <- function(x) {
  is.list(x) &&
    identical(names(x), c("r", "g", "b", "a")) &&
    all(vapply(
      x,
      function(e) is.numeric(e) && length(e) == 1L && !is.na(e),
      logical(1)
    ))
}

is_unset <- function(x) {
  is.null(x) ||
    length(x) == 0L ||
    (is.atomic(x) && length(x) == 1L && is.na(x))
}

# `s7x::as_vector()` materializes *every* property of a WebChart, so
# anything the user never set arrives as NA (scalars/enums) or NULL (object
# properties) - 16 of WebChart's 20 top-level properties, for a minimally
# built chart. Those have to be dropped rather than sent as JSON `null`:
# createModel() layers `config` over its own defaults, and an explicit null
# overrides a default instead of falling back to it.
compact_config <- function(x) {
  if (is_color_list(x)) {
    return(unname(unlist(x)))
  }
  # A data frame is a list, but recursing into it would strip its class and
  # flip it from a row-wise JSON array to a columnar object.
  if (!is.list(x) || is.data.frame(x)) {
    return(x)
  }

  out <- lapply(x, compact_config)
  out[!vapply(out, is_unset, logical(1))]
}

# The widget's JSON serializer, installed via htmlwidgets' `TOJSON_FUNC`
# hook so we never depend on htmlwidgets'/jsonlite's defaults. htmlwidgets
# calls this with the whole payload (`x`, `evals`, `jsHooks`) and expects a
# JSON string back.
#
# yyjsonr is already this project's serializer (`s7x::to_json()` is built on
# it), and its defaults are the ones we want, where jsonlite's are not:
# `dataframe = "rows"` (jsonlite/htmlwidgets default to "columns", which
# silently breaks `layerDefinition$fields` - the JS does
# `fields.map(Field.fromJSON)` and needs an array of objects), and
# `str_specials`/`num_specials = "null"` so any NA that survives compaction
# becomes JSON null rather than a string.
widget_json <- function(x, ...) {
  yyjsonr::write_json_str(
    x,
    opts = yyjsonr::opts_write_json(
      auto_unbox = TRUE,
      json_verbatim = TRUE,
      ...
    )
  )
}

#' Convert a chart to an htmlwidget
#'
#' Converts an [arc_chart()] object into a renderable htmlwidget: its data
#' becomes a client-side feature collection layer, and its config is sent as
#' the `config` argument of the JS `createModel()`.
#'
#' @param chart An `ArcChart`, from [arc_chart()] or one of [arc_bar()],
#'   [arc_scatter()], [arc_line()].
#' @param width,height Widget sizing, passed to [htmlwidgets::createWidget()].
#' @param element_id Optional DOM element ID for the widget.
#' @return An htmlwidget.
#' @export
as_widget <- function(chart, width = NULL, height = NULL, element_id = NULL) {
  if (is.null(chart@webchart)) {
    stop("set_type() must be called before the chart can be rendered.", call. = FALSE)
  }
  if (is.null(chart@data)) {
    stop("`chart` has no data to render.", call. = FALSE)
  }

  arcgis_chart(
    i_layer = as_chart_layer(chart@data),
    config = compact_config(s7x::as_vector(chart@webchart)),
    width = width,
    height = height,
    element_id = element_id
  )
}

# Printing a chart renders it, so `arc_scatter(df, x, y)` at the console
# just shows the chart instead of an S7 object dump.
S7::method(print, ArcChart) <- function(x, ...) {
  print(as_widget(x), ...)
  invisible(x)
}
