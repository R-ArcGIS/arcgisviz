#' @include arc-chart.R
NULL

# Builds the createModel() payload. The contract it has to satisfy is
# documented in CLAUDE.md ("Data transfer"); `gi` in
# dist/chunks/index2.js is the function that actually reads `iLayer`.

# arcgisutils::as_layer()'s default. The query engine validates config fields
# against the layer, so `stat = "count"` can't use the SDK's `"*"` fallback.
oid_field <- "object_id"

#' Build a feature layer from a data frame
#'
#' Wraps a data frame as a self-contained client side feature collection, the
#' `iLayer` the browser builds the chart from. No live feature service is
#' involved.
#'
#' @param .data Defines which data frame or `sf` object to convert.
#' @param name default `"chart_data"`. Defines what the layer is named.
#' @param title default `name`. Defines the human readable layer title.
#' @param id default `"arcgisviz-layer"`. Defines the unique layer id.
#' @return A list holding the `IFeatureLayer` JSON shape.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' as_chart_layer(df)
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

# The wire format is `as_vector()` with three deviations from the default
# S7_object method, registered below as methods on the types they concern.
# `to_json()` runs through `as_vector()`, so it gets them for free.
#
# S7 can't register a method against a `pkg::generic` call - the replacement
# form would have to assign back through `::` - so the generic is imported.
#' @importFrom s7x as_vector
NULL

is_unset <- function(x) {
  rlang::is_null(x) ||
    rlang::is_empty(x) ||
    (rlang::is_scalar_atomic(x) && is.na(x))
}

# A JSON `null` - not an absent key - is the only way to unset one of the
# model's own defaults client-side. `is_unset()` leaves it alone, so it
# survives compact_config().
json_null <- structure("null", class = "json")

# (1) The default method materializes every property, so unset ones arrive
# as NA/NULL. They must be dropped, not sent as null - createModel() layers
# `config` over its defaults, so a null overrides a default instead of
# falling back to it.
compact_config <- function(x) {
  # Recursing into a data frame would strip its class and flip it columnar.
  if (!rlang::is_list(x) || is.data.frame(x)) {
    return(x)
  }

  out <- lapply(x, compact_config)
  out[!vapply(out, is_unset, logical(1))]
}

# `title` goes the other way: every default config titles the chart with the
# localized "Chart" (m(), dist/chunks/index.js:289), so dropping our unset
# one would leave that in place. Unset means null here.
S7::method(as_vector, WebChart) <- function(x, ...) {
  out <- compact_config(as_vector(S7::super(x, S7::S7_object), ...))
  if (rlang::is_null(x@title)) {
    out$title <- json_null
  }
  out
}

# (2) `stat = "identity"` needs the series to carry *no* outStatistics -
# that is what ga() (dist/chunks/index2.js:593) keys BarAndLineNoAggregation
# off - but the model's default series always ships a count aggregation
# ($e(), dist/chunks/index.js). Dropping our own unset `query` would leave
# that default in place, so send an explicit null instead.
series_as_vector <- function(x, ...) {
  out <- as_vector(S7::super(x, S7::S7_object), ...)
  if (rlang::is_null(x@query)) {
    out$query <- json_null
  }
  out
}

S7::method(as_vector, WebChartBarChartSeries) <- series_as_vector
S7::method(as_vector, WebChartLineChartSeries) <- series_as_vector
S7::method(as_vector, WebChartScatterplotSeries) <- series_as_vector

# (3) The spec wants a raw [r,g,b,a] tuple; we store r/g/b/a scalars. A
# partly-specified color isn't one, so it drops out as unset.
S7::method(as_vector, Color) <- function(x, ...) {
  rgba <- c(x@r, x@g, x@b, x@a)
  if (anyNA(rgba)) NULL else rgba
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
#' Turns an [arc_chart()] into a renderable widget. Printing an `ArcChart`
#' calls this for you.
#'
#' @param chart Defines which chart to render.
#' @param width,height default `NULL`. Defines the widget size, passed to
#'   [htmlwidgets::createWidget()].
#' @param element_id default `NULL`. Defines the DOM element id to render into.
#' @return An htmlwidget.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' as_widget(arc_col(df, species, mass))
#' @export
as_widget <- function(chart, width = NULL, height = NULL, element_id = NULL) {
  check_chart_type_set(chart)
  if (rlang::is_null(chart@data)) {
    cli::cli_abort("{.arg chart} has no data to render.")
  }

  arcgis_chart(
    i_layer = as_chart_layer(chart_data(chart)),
    chart_type = chart_type_map[[chart@chart_type]]$model_type,
    config = as_vector(chart@webchart),
    width = width,
    height = height,
    element_id = element_id
  )
}

S7::method(print, ArcChart) <- function(x, ...) {
  print(as_widget(x), ...)
  invisible(x)
}
