#' @include palettes.R
NULL

# ArcProxy subclasses ArcChart so every set_*() works on it unchanged: they
# assign a property and return the object, and S7 keeps the subclass.

#' Update a rendered chart from the Shiny server
#'
#' `arc_proxy()` wraps a chart that is already on screen. Every `set_*()`
#' function works on the result, and [arc_update()] sends the accumulated
#' changes to the browser.
#'
#' The data never crosses the wire again. Only the configuration is resent,
#' and the browser merges it over the model it already built, so changing a
#' mapping on a large layer costs nothing beyond the config itself.
#'
#' @param output_id Defines which [arcgisChartOutput()] to update.
#' @param chart Defines the chart currently rendered there, so that the
#'   `set_*()` functions can validate against the same data.
#' @param session default [shiny::getDefaultReactiveDomain()]. Defines the
#'   Shiny session to send through.
#' @return An `ArcProxy`, which every `set_*()` function accepts.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#' chart <- arc_col(df, species, mass)
#'
#' # Inside a Shiny server:
#' if (interactive()) {
#'   arc_proxy("chart", chart) |>
#'     set_color(species) |>
#'     arc_update()
#' }
#' @name ArcProxy
#' @export
ArcProxy <- new_class(
  "ArcProxy",
  parent = ArcChart,
  properties = list(
    output_id = s7x::class_string,
    session = S7::class_any
  )
)

#' @rdname ArcProxy
#' @export
arc_proxy <- function(
  output_id,
  chart,
  session = shiny::getDefaultReactiveDomain()
) {
  rlang::check_installed("shiny")
  if (!S7::S7_inherits(chart, ArcChart)) {
    cli::cli_abort(c(
      "{.arg chart} must be an {.cls ArcChart}.",
      "x" = "You supplied {.obj_type_friendly {chart}}."
    ))
  }

  props <- S7::props(chart)
  props$webchart <- NULL
  rlang::exec(ArcProxy, !!!props, output_id = output_id, session = session)
}

#' Send a proxy's changes to the browser
#'
#' Flushes everything the `set_*()` and [add_layer()] calls have changed on an
#' [arc_proxy()] or [arc_map_proxy()] as one message, so a pipeline of them
#' costs one re-render.
#'
#' @param proxy Defines which [arc_proxy()] or [arc_map_proxy()] to flush.
#' @param ... Reserved for methods.
#' @return `proxy`, invisibly.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' if (interactive()) {
#'   arc_proxy("chart", arc_col(df, species, mass)) |>
#'     set_flipped() |>
#'     arc_update()
#' }
#' @export
arc_update <- S7::new_generic("arc_update", "proxy", function(proxy, ...) {
  S7::S7_dispatch()
})

S7::method(arc_update, ArcProxy) <- function(proxy, ...) {
  proxy_send(
    proxy,
    "config",
    list(
      config = as_vector(proxy@webchart),
      tooltip = tooltip_payload(proxy)
    )
  )
}

#' Filter a rendered chart or map in the browser
#'
#' Applies a SQL `where` clause, or a set of object ids, to a chart or map that
#' is already on screen. Nothing is resent and no model is rebuilt: the chart
#' requeries the layer it already holds, and a map layer re-evaluates its own
#' definition expression.
#'
#' @param proxy Defines which [arc_proxy()] or [arc_map_proxy()] to filter.
#' @param ... Reserved for methods.
#' @param where default `NULL`. Defines a SQL where clause, such as
#'   `"species = 'Adelie'"`. `NULL`, `NA`, or `""` clear it.
#' @param object_ids default `NULL`. Defines which rows to keep, by object id.
#'   `NULL` or an empty vector clears them. Charts only.
#' @param layer default `NULL`. Defines which map layer to filter, by name.
#'   `NULL` filters every layer. Maps only.
#' @return `proxy`, invisibly.
#' @details
#' Each call defines the complete filter state, because the element replaces
#' `runtimeDataFilters` wholesale rather than merging into it.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' if (interactive()) {
#'   arc_proxy("chart", arc_col(df, species, mass)) |>
#'     set_filter("mass > 2")
#' }
#' @export
set_filter <- S7::new_generic("set_filter", "proxy", function(proxy, ...) {
  S7::S7_dispatch()
})

S7::method(set_filter, ArcProxy) <- function(
  proxy,
  where = NULL,
  object_ids = NULL,
  ...
) {
  if (!rlang::is_null(where) && !is_where_clause(where)) {
    cli::cli_abort(c(
      "{.arg where} must be a single SQL clause, {.code NA}, or {.code NULL}.",
      "x" = "You supplied {.obj_type_friendly {where}}."
    ))
  }

  # Built in one call so an unset filter stays a NULL-valued key: Shiny
  # serializes that to a JSON null, which is what clears one client-side.
  filters <- list(
    where = if (is_blank_filter(where)) NULL else where,
    objectIds = if (rlang::is_empty(object_ids)) {
      NULL
    } else {
      as.list(as.integer(object_ids))
    }
  )

  proxy_send(proxy, "element", list(runtimeDataFilters = filters))
}

# NA arrives as logical from `if (nzchar(x)) x else NA`, so any scalar NA
# counts, not just NA_character_.
is_where_clause <- function(x) {
  rlang::is_scalar_character(x) ||
    (rlang::is_scalar_atomic(x) && is.na(x))
}

is_blank_filter <- function(x) {
  rlang::is_null(x) || is.na(x) || !nzchar(x)
}

#' Select features on a rendered chart or map
#'
#' Marks rows as selected by object id. A chart draws them as its own
#' selection; a map hands them to the view's selection manager, which
#' highlights them and reports the new selection back as
#' `input$<output_id>$selection`. Object ids are row numbers, so a chart and a
#' map built from the same data frame select each other's rows.
#'
#' On a map the selection is a set that persists across calls, which is what
#' `mode` operates on and what a click on a `selectable` layer
#' ([add_layer()]) or a drawn [arc_draw_selection()] shape adds to. [set_highlight()]
#' styles it and [arc_selected()] reads it.
#'
#' @param proxy Defines which [arc_proxy()] or [arc_map_proxy()] to select on.
#' @param object_ids Defines which rows to select, by object id. An empty
#'   vector clears the selection.
#' @param ... Reserved for methods.
#' @param layer default `NULL`. Defines which map layer to select in, by
#'   name. `NULL` selects in every layer. Maps only.
#' @param mode default `"replace"`. Defines what these ids do to the current
#'   selection, one of `"replace"`, `"add"`, `"remove"`, or `"toggle"`. Maps
#'   only.
#' @return `proxy`, invisibly.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' if (interactive()) {
#'   arc_proxy("chart", arc_col(df, species, mass)) |>
#'     set_selection(c(1, 2))
#' }
#' @export
set_selection <- S7::new_generic(
  "set_selection",
  "proxy",
  function(proxy, object_ids, ...) S7::S7_dispatch()
)

S7::method(set_selection, ArcProxy) <- function(proxy, object_ids, ...) {
  if (rlang::is_empty(object_ids)) {
    return(arc_clear_selection(proxy))
  }
  proxy_send(
    proxy,
    "element",
    list(
      selectionData = list(selectionOIDs = as.list(as.integer(object_ids)))
    )
  )
}

#' Control a rendered chart's legend
#'
#' @param proxy Defines which [arc_proxy()] to modify.
#' @param visible default `NULL`. Defines whether the legend is shown.
#' @param position default `NULL`. Defines where it sits, one of `"top"`,
#'   `"bottom"`, `"leading"`, or `"trailing"`.
#' @param title default `NULL`. Defines the legend title.
#' @return `proxy`, invisibly.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' if (interactive()) {
#'   arc_proxy("chart", arc_col(df, species, mass)) |>
#'     set_legend(visible = TRUE, position = "bottom")
#' }
#' @export
set_legend <- function(proxy, visible = NULL, position = NULL, title = NULL) {
  check_proxy(proxy)
  props <- list()
  if (!rlang::is_null(visible)) {
    props$legendVisibility <- isTRUE(visible)
  }
  if (!rlang::is_null(position)) {
    props$legendPosition <- rlang::arg_match0(
      position,
      c("top", "bottom", "leading", "trailing")
    )
  }
  if (!rlang::is_null(title)) {
    props$legendTitleText <- title
  }
  proxy_send(proxy, "model", props)
}

#' Invoke a rendered chart's own methods
#'
#' Each of these calls a method on the `<arcgis-chart>` element directly.
#' The two export functions download in the reader's browser.
#'
#' @param proxy Defines which [arc_proxy()] to act on.
#' @param update_data default `TRUE`. Defines whether `arc_refresh()`
#'   requeries the layer or only redraws.
#' @param reset_axes default `FALSE`. Defines whether axis bounds are
#'   recomputed.
#' @param format default `"png"`. Defines the image format, one of `"png"`,
#'   `"jpeg"`, or `"svg"`.
#' @param message,heading Defines the text `arc_notify()` shows in the
#'   chart's own info panel.
#' @return `proxy`, invisibly.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' if (interactive()) {
#'   arc_proxy("chart", arc_col(df, species, mass)) |>
#'     arc_reset_zoom()
#' }
#' @export
arc_refresh <- function(proxy, update_data = TRUE, reset_axes = FALSE) {
  check_proxy(proxy)
  proxy_call(
    proxy,
    "refresh",
    list(list(
      updateData = isTRUE(update_data),
      resetAxesBounds = isTRUE(reset_axes)
    ))
  )
}

#' @rdname arc_refresh
#' @export
arc_reset_zoom <- function(proxy) {
  check_proxy(proxy)
  proxy_call(proxy, "resetZoom", list())
}

#' @rdname arc_refresh
#' @export
arc_clear_selection <- function(proxy) {
  check_proxy(proxy)
  proxy_call(proxy, "clearSelection", list())
}

#' @rdname arc_refresh
#' @export
arc_export_image <- function(proxy, format = "png") {
  check_proxy(proxy)
  format <- rlang::arg_match0(format, c("png", "jpeg", "svg"))
  proxy_call(proxy, "exportAsImage", list(format))
}

#' @rdname arc_refresh
#' @export
arc_export_csv <- function(proxy) {
  check_proxy(proxy)
  proxy_call(proxy, "exportAsCSV", list())
}

#' @rdname arc_refresh
#' @export
arc_notify <- function(proxy, message, heading = NULL) {
  check_proxy(proxy)
  proxy_call(proxy, "notify", list(message, heading))
}

# Without these, dispatch on a plain chart or map reports S7's own "can't
# find method", which does not say what to do about it.
proxy_expected <- function(proxy, call = rlang::caller_env()) {
  cli::cli_abort(
    c(
      "{.arg proxy} must be an {.cls ArcProxy} or {.cls ArcMapProxy}.",
      "i" = "Build one with {.fn arc_proxy} or {.fn arc_map_proxy}."
    ),
    call = call
  )
}

S7::method(arc_update, S7::class_any) <- function(proxy, ...) {
  proxy_expected(proxy)
}

S7::method(set_filter, S7::class_any) <- function(proxy, ...) {
  proxy_expected(proxy)
}

S7::method(set_selection, S7::class_any) <- function(proxy, object_ids, ...) {
  proxy_expected(proxy)
}

check_proxy <- function(proxy, call = rlang::caller_env()) {
  if (S7::S7_inherits(proxy, ArcProxy)) {
    return(invisible(proxy))
  }
  cli::cli_abort(
    c(
      "{.arg proxy} must be an {.cls ArcProxy}.",
      "i" = "Build one with {.fn arc_proxy}."
    ),
    call = call
  )
}

proxy_call <- function(proxy, method, args) {
  proxy_send(proxy, "call", list(method = method, args = args))
}

proxy_send <- function(proxy, method, payload, handler = "arcgisviz-chart") {
  msg <- list(id = proxy@output_id, method = method, payload = payload)
  proxy@session$sendCustomMessage(handler, msg)
  invisible(proxy)
}

S7::method(print, ArcProxy) <- function(x, ...) {
  cli::cli_inform(
    "<ArcProxy> for output {.val {x@output_id}}, {.fn arc_update} to send."
  )
  invisible(x)
}
