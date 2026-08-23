#' @include arc-proxy.R arc-map.R
NULL

# ArcMapProxy subclasses ArcMap for the same reason ArcProxy subclasses
# ArcChart: set_basemap(), set_view() and add_layer() assign a property and
# return the object, so all three work on a proxy with no duplicated code.

#' Update a rendered map from the Shiny server
#'
#' `arc_map_proxy()` wraps a map that is already on screen. [set_basemap()],
#' [set_view()] and [add_layer()] all work on the result, and [arc_update()]
#' sends the accumulated changes to the browser as one message.
#'
#' Only what changed crosses the wire. A basemap or view change carries no
#' data at all, and a layer already drawn is never resent - it is filtered,
#' highlighted, hidden or removed in place by [set_filter()],
#' [set_selection()], [set_layer()] and [remove_layer()].
#'
#' A layer added through a proxy must be named, because the name is what
#' identifies it to those functions. Adding one whose name is already on the
#' map replaces it.
#'
#' @param output_id Defines which [arcgisMapOutput()] to update.
#' @param session default [shiny::getDefaultReactiveDomain()]. Defines the
#'   Shiny session to send through.
#' @return An `ArcMapProxy`, which [add_layer()] and the map `set_*()`
#'   functions accept.
#' @examples
#' # Inside a Shiny server:
#' if (interactive()) {
#'   arc_map_proxy("map") |>
#'     set_basemap("satellite") |>
#'     arc_update()
#' }
#' @name ArcMapProxy
#' @export
ArcMapProxy <- new_class(
  "ArcMapProxy",
  parent = ArcMap,
  properties = list(
    output_id = s7x::class_string,
    session = S7::class_any
  )
)

#' @rdname ArcMapProxy
#' @export
arc_map_proxy <- function(
  output_id,
  session = shiny::getDefaultReactiveDomain()
) {
  rlang::check_installed("shiny")
  ArcMapProxy(output_id = output_id, session = session)
}

S7::method(arc_update, ArcMapProxy) <- function(proxy, ...) {
  call <- rlang::caller_env()
  layers <- lapply(seq_along(proxy@layers), function(i) {
    map_feature_layer(proxy@layers[[i]], i, call)
  })

  map_send(
    proxy,
    "update",
    list(
      basemap = if (is.na(proxy@basemap)) NULL else proxy@basemap,
      center = if (rlang::is_empty(proxy@center)) NULL else proxy@center,
      zoom = if (is.na(proxy@zoom)) NULL else proxy@zoom,
      extent = if (rlang::is_empty(proxy@extent)) NULL else proxy@extent,
      layers = layers
    )
  )
}

S7::method(set_filter, ArcMapProxy) <- function(
  proxy,
  where = NULL,
  layer = NULL,
  ...
) {
  if (!rlang::is_null(where) && !is_where_clause(where)) {
    cli::cli_abort(c(
      "{.arg where} must be a single SQL clause, {.code NA}, or {.code NULL}.",
      "x" = "You supplied {.obj_type_friendly {where}}."
    ))
  }

  map_send(
    proxy,
    "filter",
    list(
      ids = layer_ids(layer),
      where = if (is_blank_filter(where)) NULL else where
    )
  )
}

S7::method(set_selection, ArcMapProxy) <- function(
  proxy,
  object_ids,
  layer = NULL,
  ...
) {
  map_send(
    proxy,
    "highlight",
    list(
      ids = layer_ids(layer),
      objectIds = if (rlang::is_empty(object_ids)) {
        NULL
      } else {
        as.integer(object_ids)
      }
    )
  )
}

#' Show, hide, or fade a layer that is already drawn
#'
#' Changes one layer's appearance without resending it. `remove_layer()`
#' takes it off the map instead.
#'
#' @param proxy Defines which [arc_map_proxy()] to modify.
#' @param layer Defines which layer, by the `name` it was added with.
#'   `remove_layer()` accepts `NULL` to remove every layer.
#' @param visible default `NULL`. Defines whether the layer is drawn.
#' @param opacity default `NULL`. Defines the layer opacity, from `0` to `1`.
#' @return `proxy`, invisibly.
#' @examples
#' if (interactive()) {
#'   arc_map_proxy("map") |>
#'     set_layer("Counties", visible = FALSE)
#' }
#' @export
set_layer <- function(proxy, layer, visible = NULL, opacity = NULL) {
  check_map_proxy(proxy)
  props <- list()
  if (!rlang::is_null(visible)) {
    props$visible <- isTRUE(visible)
  }
  if (!rlang::is_null(opacity)) {
    props$opacity <- as.double(opacity)
  }
  map_send(proxy, "layer", list(ids = layer_ids(layer), props = props))
}

#' @rdname set_layer
#' @export
remove_layer <- function(proxy, layer = NULL) {
  check_map_proxy(proxy)
  map_send(proxy, "remove", list(ids = layer_ids(layer)))
}

#' Move a rendered map's view
#'
#' `arc_goto()` animates the view, unlike [set_view()] on a proxy, which jumps
#' to the new position. `arc_screenshot()` captures the view as a PNG data URL
#' and sends it back as `input$<output_id>_screenshot`.
#'
#' @param proxy Defines which [arc_map_proxy()] to act on.
#' @param center default `NULL`. Defines the target centre as `c(lon, lat)`.
#' @param zoom default `NULL`. Defines the target zoom level.
#' @param extent default `NULL`. Defines the target extent, overriding
#'   `center` and `zoom`.
#' @param duration default `NULL`. Defines the animation length in
#'   milliseconds.
#' @param format default `"png"`. Defines the screenshot format, `"png"` or
#'   `"jpg"`.
#' @return `proxy`, invisibly.
#' @examples
#' if (interactive()) {
#'   arc_map_proxy("map") |>
#'     arc_goto(center = c(-79, 35.5), zoom = 8)
#' }
#' @export
arc_goto <- function(
  proxy,
  center = NULL,
  zoom = NULL,
  extent = NULL,
  duration = NULL
) {
  check_map_proxy(proxy)
  if (
    rlang::is_null(center) && rlang::is_null(zoom) && rlang::is_null(extent)
  ) {
    cli::cli_abort(c(
      "{.fn arc_goto} needs somewhere to go.",
      "i" = "Set {.arg center}, {.arg zoom}, or {.arg extent}."
    ))
  }

  map_send(
    proxy,
    "goto",
    list(
      target = drop_null(list(
        center = if (rlang::is_null(center)) NULL else as.double(center),
        zoom = zoom,
        extent = extent
      )),
      options = drop_null(list(duration = duration))
    )
  )
}

#' @rdname arc_goto
#' @export
arc_screenshot <- function(proxy, format = "png") {
  check_map_proxy(proxy)
  format <- rlang::arg_match0(format, c("png", "jpg"))
  map_send(proxy, "screenshot", list(format = format))
}

check_map_proxy <- function(proxy, call = rlang::caller_env()) {
  if (S7::S7_inherits(proxy, ArcMapProxy)) {
    return(invisible(proxy))
  }
  cli::cli_abort(
    c(
      "{.arg proxy} must be an {.cls ArcMapProxy}.",
      "i" = "Build one with {.fn arc_map_proxy}."
    ),
    call = call
  )
}

# NULL means every layer, which the client reads off an absent `ids` key.
layer_ids <- function(layer, call = rlang::caller_env()) {
  if (rlang::is_null(layer)) {
    return(NULL)
  }
  if (!is.character(layer)) {
    cli::cli_abort(
      c(
        "{.arg layer} must be the name a layer was added with.",
        "x" = "You supplied {.obj_type_friendly {layer}}."
      ),
      call = call
    )
  }
  as.list(layer)
}

drop_null <- function(x) {
  x[!vapply(x, rlang::is_null, logical(1))]
}

# Shiny would serialize with jsonlite, which sends layerDefinition$fields
# columnar and breaks Field.fromJSON. The client parses the string instead.
map_send <- function(proxy, method, payload) {
  proxy_send(
    proxy,
    method,
    widget_json(drop_null(payload)),
    handler = "arcgisviz-map"
  )
}

S7::method(print, ArcMapProxy) <- function(x, ...) {
  cli::cli_inform(
    "<ArcMapProxy> for output {.val {x@output_id}}, {.fn arc_update} to send."
  )
  invisible(x)
}
