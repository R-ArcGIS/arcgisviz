#' @include arcgis-chart-widget.R
NULL

# The tag vocabulary the ramps ship with, split into the parts that earn their
# own column. Every ramp carries exactly one colour mode and at most one type,
# so both collapse to a scalar. Everything else stays in `tags`.
palette_types <- c("sequential", "diverging", "categorical")

palette_modes <- c("light", "dark")

palette_hues <- c(
  "blues",
  "browns",
  "grays",
  "greens",
  "oranges",
  "pinks",
  "purples",
  "reds",
  "yellows"
)

tag_one <- function(tags, set) {
  hit <- intersect(set, tags)
  if (rlang::is_empty(hit)) NA_character_ else hit[[1]]
}

#' Browse the Esri colour ramps
#'
#' Lists every ramp [set_color()] accepts by name, with the tags the ArcGIS
#' SDK ships alongside them. Call it with no arguments for all of them, or
#' narrow it with any combination of the arguments below.
#'
#' The result has one row per ramp and these columns.
#'
#' \describe{
#'   \item{palette}{The name to pass to [set_color()].}
#'   \item{type}{`"sequential"`, `"diverging"`, `"categorical"`, or `NA`.}
#'   \item{color_mode}{`"light"` or `"dark"`, the background the ramp is
#'     drawn for.}
#'   \item{colorblind_friendly}{Whether Esri tags the ramp as such.}
#'   \item{n_stops}{How many colours the ramp defines.}
#'   \item{hues}{The colour families the ramp draws on.}
#'   \item{tags}{Every tag, including the ones above.}
#' }
#'
#' @param type default `NULL`. Keeps only ramps of these types, any of
#'   `"sequential"`, `"diverging"`, or `"categorical"`.
#' @param color_mode default `NULL`. Keeps only ramps drawn for a `"light"`
#'   or `"dark"` background.
#' @param hue default `NULL`. Keeps ramps drawing on any of these colour
#'   families, such as `"blues"` or `"reds"`.
#' @param tag default `NULL`. Keeps ramps carrying all of these tags, such as
#'   `"heatmap"` or `"colorblind-friendly"`.
#' @return A data frame of ramps, one row each.
#' @examples
#' esri_palettes(type = "diverging", color_mode = "dark")
#' @export
esri_palettes <- function(
  type = NULL,
  color_mode = NULL,
  hue = NULL,
  tag = NULL
) {
  tags <- unname(lapply(esri_color_ramps, function(ramp) ramp$tags))

  out <- arcgisutils::data_frame(data.frame(
    palette = names(esri_color_ramps),
    type = vapply(tags, tag_one, character(1), set = palette_types),
    color_mode = vapply(tags, tag_one, character(1), set = palette_modes),
    colorblind_friendly = vapply(
      tags,
      function(t) "colorblind-friendly" %in% t,
      logical(1)
    ),
    n_stops = vapply(
      esri_color_ramps,
      function(ramp) nrow(ramp$stops),
      integer(1),
      USE.NAMES = FALSE
    ),
    hues = I(lapply(tags, function(t) intersect(palette_hues, t))),
    tags = I(tags),
    row.names = NULL,
    stringsAsFactors = FALSE
  ))

  keep <- rep(TRUE, nrow(out))
  if (!rlang::is_null(type)) {
    type <- rlang::arg_match(type, palette_types, multiple = TRUE)
    keep <- keep & out$type %in% type
  }
  if (!rlang::is_null(color_mode)) {
    color_mode <- rlang::arg_match(color_mode, palette_modes, multiple = TRUE)
    keep <- keep & out$color_mode %in% color_mode
  }
  if (!rlang::is_null(hue)) {
    hue <- rlang::arg_match(hue, palette_hues, multiple = TRUE)
    keep <- keep & vapply(out$hues, function(h) any(hue %in% h), logical(1))
  }
  if (!rlang::is_null(tag)) {
    tag <- rlang::arg_match(tag, palette_tags(), multiple = TRUE)
    keep <- keep & vapply(out$tags, function(t) all(tag %in% t), logical(1))
  }

  out <- out[keep, , drop = FALSE]
  row.names(out) <- NULL
  out
}

#' The tags the Esri ramps are labelled with
#'
#' Every distinct tag across all ramps, sorted. These are what
#' [esri_palettes()]'s `tag` argument accepts.
#'
#' @return A character vector of tags.
#' @examples
#' palette_tags()
#' @export
palette_tags <- function() {
  sort(unique(unlist(lapply(esri_color_ramps, function(ramp) ramp$tags))))
}
