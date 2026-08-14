# Builds the createModel() payload. The contract it has to satisfy is
# documented in CLAUDE.md ("Data transfer"); `gi` in
# dist/chunks/index2.js is the function that actually reads `iLayer`.

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

# The spec wants a raw [r,g,b,a] tuple; we store r/g/b/a scalars.
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

# `as_vector()` materializes every property, so unset ones arrive as
# NA/NULL. They must be dropped, not sent as JSON null - null would
# override the model's default rather than fall back to it.
compact_config <- function(x) {
  if (is_color_list(x)) {
    return(unname(unlist(x)))
  }
  # Recursing into a data frame would strip its class and flip it columnar.
  if (!is.list(x) || is.data.frame(x)) {
    return(x)
  }

  out <- lapply(x, compact_config)
  out[!vapply(out, is_unset, logical(1))]
}

# Our serializer, installed via htmlwidgets' TOJSON_FUNC hook. Called with
# the whole payload (x, evals, jsHooks), returns a JSON string. yyjsonr's
# defaults are the right ones here; jsonlite's `dataframe = "columns"`
# silently breaks `layerDefinition$fields`.
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
    chart_type = chart_type_map[[chart@chart_type]]$model_type,
    config = compact_config(s7x::as_vector(chart@webchart)),
    width = width,
    height = height,
    element_id = element_id
  )
}

S7::method(print, ArcChart) <- function(x, ...) {
  print(as_widget(x), ...)
  invisible(x)
}
