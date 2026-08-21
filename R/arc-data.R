#' @include arc-chart.R
NULL

# Builds the createModel() payload. The contract it has to satisfy is
# documented in CLAUDE.md ("Data transfer"); `gi` in
# dist/chunks/index2.js is the function that actually reads `iLayer`.

# arcgisutils::as_layer()'s default. The query engine validates config fields
# against the layer, so `stat = "count"` can't use the SDK's `"*"` fallback.
oid_field <- "object_id"

# arcgisutils::as_fields() needs at least one non-geometry column and fails
# with "arguments imply differing number of rows" without one.
check_attribute_columns <- function(.data, call = rlang::caller_env()) {
  n <- if (inherits(.data, "sf")) {
    ncol(sf::st_drop_geometry(.data))
  } else {
    ncol(.data)
  }
  if (n > 0L) {
    return(invisible(.data))
  }

  cli::cli_abort(
    c(
      "{.arg .data} must have at least one column besides its geometry.",
      "i" = "Add an id or a value column to describe each feature."
    ),
    call = call
  )
}

#' Build a feature layer from a data frame
#'
#' Wraps a data frame as a self-contained client side feature collection. This
#' is the `iLayer` a chart reads and the layer a map draws. No live feature
#' service is involved.
#'
#' @param .data Defines which data frame or `sf` object to convert.
#' @param name default `"layer_data"`. Defines what the layer is named.
#' @param title default `name`. Defines the human readable layer title.
#' @param id default `"arcgisviz-layer"`. Defines the unique layer id.
#' @param drawing_info default `NULL`. Defines how features are symbolized, as
#'   a list holding a `renderer`.
#' @param opacity default `NULL`. Defines the layer opacity, from `0` to `1`.
#' @param visibility default `NULL`. Defines whether the layer starts visible.
#' @param popup_info default `NULL`. Defines which fields are shown when a
#'   feature is hovered or clicked, as a list holding `title` and `fieldInfos`.
#' @return An [IFeatureLayer].
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' as_feature_layer(df)
#' @export
as_feature_layer <- function(
  .data,
  name = "layer_data",
  title = name,
  id = "arcgisviz-layer",
  drawing_info = NULL,
  opacity = NULL,
  visibility = NULL,
  popup_info = NULL
) {
  check_attribute_columns(.data)

  definition <- arcgisutils::as_layer_definition(
    .data,
    name = name,
    object_id_field = oid_field,
    drawing_info = drawing_info
  )

  IFeatureLayer(
    id = id,
    title = title,
    layerType = "ArcGISFeatureLayer",
    opacity = if (rlang::is_null(opacity)) NA_real_ else as.double(opacity),
    visibility = if (rlang::is_null(visibility)) NA else visibility,
    featureCollection = arcgisutils::as_feature_collection(
      layers = list(
        arcgisutils::as_layer(
          .data,
          name = name,
          title = title,
          layer_definition = definition,
          popup_info = popup_info
        )
      )
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

# Shallow, not compact_config(): everything nested here comes from arcgisutils
# already well-formed, and a deep walk would visit every feature.
S7::method(as_vector, IFeatureLayer) <- function(x, ...) {
  out <- as_vector(S7::super(x, S7::S7_object), ...)
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

# `additionalTooltipFields` is `string[]`, and the client both iterates it
# and spreads it into the query's outFields (fu(), index2.js:7857) - a bare
# string would spread to its own characters. A list keeps it an array.
S7::method(as_vector, WebChartScatterplotSeries) <- function(x, ...) {
  out <- series_as_vector(x, ...)
  out$additionalTooltipFields <- as.list(x@additionalTooltipFields)
  if (rlang::is_empty(out$additionalTooltipFields)) {
    out$additionalTooltipFields <- NULL
  }
  out
}

# (3) The spec wants a raw [r,g,b,a] tuple; we store r/g/b/a scalars. A
# partly-specified color isn't one, so it drops out as unset.
S7::method(as_vector, Color) <- function(x, ...) {
  rgba <- c(x@r, x@g, x@b, x@a)
  if (anyNA(rgba)) NULL else rgba
}

# A renderer travels inside layerDefinition$drawingInfo on a map, where no
# parent compacts it. Registering it here covers that and the chart's
# chartRenderer with one rule.
renderer_as_vector <- function(x, ...) {
  compact_config(as_vector(S7::super(x, S7::S7_object), ...))
}

S7::method(as_vector, ISimpleRenderer) <- renderer_as_vector
S7::method(as_vector, IUniqueValueRenderer) <- renderer_as_vector

# Our serializer, installed via htmlwidgets' TOJSON_FUNC hook. Called with
# the whole payload (x, evals, jsHooks), returns a JSON string. yyjsonr's
# defaults are the right ones here; jsonlite's `dataframe = "columns"`
# silently breaks `layerDefinition$fields`.
#
# This is the one place S7 becomes JSON. as_vector() recurses, so a config or
# a layer travels as its class right up to here and every method registered
# above fires on the way through.
widget_json <- function(x, ...) {
  yyjsonr::write_json_str(
    as_vector(x),
    opts = yyjsonr::opts_write_json(
      auto_unbox = TRUE,
      json_verbatim = TRUE,
      ...
    )
  )
}

#' Convert a chart or map to an htmlwidget
#'
#' Turns an [arc_chart()] or an [arc_map()] into a renderable widget. Printing
#' either one calls this for you.
#'
#' @param x Defines which chart or map to render.
#' @param width,height default `NULL`. Defines the widget size, passed to
#'   [htmlwidgets::createWidget()].
#' @param element_id default `NULL`. Defines the DOM element id to render into.
#' @return An htmlwidget.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' as_widget(arc_col(df, species, mass))
#' @export
as_widget <- S7::new_generic(
  "as_widget",
  "x",
  function(x, width = NULL, height = NULL, element_id = NULL) {
    S7::S7_dispatch()
  }
)

S7::method(as_widget, ArcChart) <- function(
  x,
  width = NULL,
  height = NULL,
  element_id = NULL
) {
  check_chart_type_set(x)
  if (rlang::is_null(x@data)) {
    cli::cli_abort("{.arg x} has no data to render.")
  }

  arcgis_chart(
    i_layer = tooltip_aliased(
      as_feature_layer(chart_data(x), name = "chart_data"),
      x@tooltip
    ),
    chart_type = chart_type_map[[x@chart_type]]$model_type,
    config = x@webchart,
    tooltip = tooltip_payload(x),
    width = width,
    height = height,
    element_id = element_id
  )
}

S7::method(print, ArcChart) <- function(x, ...) {
  print(as_widget(x), ...)
  invisible(x)
}
