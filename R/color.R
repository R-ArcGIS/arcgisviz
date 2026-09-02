library(S7)

#' An RGBA colour
#'
#' Holds a colour as separate `r`, `g`, `b`, and `a` components, each on a 0
#' to 255 scale. Serialization converts it back to the tuple the spec uses.
#'
#' @examples
#' s7x::as_vector(Color(r = 70, g = 130, b = 180, a = 255))
#' @name Color
#' @export
Color <- new_class(
  "Color",
  properties = list(
    r = s7x::class_float,
    g = s7x::class_float,
    b = s7x::class_float,
    a = s7x::class_float
  )
)

rgba_color <- function(rgba) {
  rgba <- as.double(rgba)
  Color(r = rgba[[1]], g = rgba[[2]], b = rgba[[3]], a = rgba[[4]])
}

# grDevices::col2rgb() already covers R colour names, "#rrggbb" and
# "#rrggbbaa", and returns its rows in Color's own r/g/b/a order. Its own
# error is a bare "invalid color name 'x'" with no context.
color_rgba <- function(x, arg = "colour", call = rlang::caller_env()) {
  if (!rlang::is_character(x) || rlang::is_empty(x)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be a character vector of colours.",
        "x" = "You supplied {.obj_type_friendly {x}}."
      ),
      call = call
    )
  }

  rgba <- try(grDevices::col2rgb(x, alpha = TRUE), silent = TRUE)
  if (inherits(rgba, "try-error")) {
    bad <- x[is.na(match(x, grDevices::colors())) & !grepl("^#", x)]
    cli::cli_abort(
      c(
        "{.arg {arg}} must contain only valid colours.",
        "x" = "{.val {bad}} {?is/are} not {?a/} recognized colour{?s}.",
        "i" = "Use a hex string like {.val #4682B4} or a name from
               {.run grDevices::colors()}."
      ),
      call = call
    )
  }

  t(rgba)
}

# HighlightOptions takes a CSS colour rather than the spec's [r,g,b,a] tuple,
# so this is the one place a colour leaves R as a string.
hex_color <- function(x, arg = "color", call = rlang::caller_env()) {
  rgba <- color_rgba(x, arg = arg, call = call)
  grDevices::rgb(
    rgba[, 1],
    rgba[, 2],
    rgba[, 3],
    rgba[, 4],
    maxColorValue = 255
  )
}

#' Parse colours into `Color` objects
#'
#' @param x A character vector of R colour names or hex strings.
#' @return A list of [Color()] objects, one per element of `x`.
#' @noRd
parse_color <- function(x, arg = "colour", call = rlang::caller_env()) {
  rgba <- color_rgba(x, arg = arg, call = call)
  lapply(seq_len(nrow(rgba)), function(i) rgba_color(rgba[i, ]))
}

# A palette is either the name of an Esri smart-mapping ramp or a vector of R
# colours. Returns the ramp's own stops as an n x 4 RGBA matrix - the client
# interpolates between them, so there is nothing to expand here.
palette_stops <- function(
  palette,
  arg = "palette",
  call = rlang::caller_env()
) {
  if (rlang::is_string(palette) && palette %in% names(esri_color_ramps)) {
    return(esri_color_ramps[[palette]]$stops)
  }

  color_rgba(palette, arg = arg, call = call)
}

# 0-1 onto the spec's 0-255 alpha channel. NA leaves a colour opaque.
alpha_channel <- function(alpha) {
  if (is.na(alpha)) 255 else round(255 * alpha)
}

# Alpha overrides the stops rather than the resolved colours, so it reaches the
# default ramps too - those are only picked once the renderer knows the
# column's type.
alpha_stops <- function(stops, alpha) {
  if (is.na(alpha)) {
    return(stops)
  }
  stops[, 4] <- alpha_channel(alpha)
  stops
}

# n colours from resolved stops. Unset cycles the SDK's own series palette as
# y() does (index.js:93); stops are interpolated linearly in RGB, which is what
# the SDK does too (class-breaks.js:225).
discrete_colors <- function(stops, n, alpha = NA_real_) {
  if (rlang::is_null(stops)) {
    rows <- (seq_len(n) - 1L) %% nrow(esri_series_palette) + 1L
    rgba <- alpha_stops(esri_series_palette[rows, , drop = FALSE], alpha)
    return(lapply(seq_len(n), function(i) rgba_color(rgba[i, ])))
  }

  hex <- grDevices::rgb(
    stops[, 1],
    stops[, 2],
    stops[, 3],
    stops[, 4],
    maxColorValue = 255
  )

  at <- if (n == 1L) 0 else seq(0, 1, length.out = n)
  rgba <- round(grDevices::colorRamp(hex, alpha = TRUE)(at))
  rgba <- alpha_stops(rgba, alpha)
  lapply(seq_len(nrow(rgba)), function(i) rgba_color(rgba[i, ]))
}
