esri_palettes <- function() {
  .x <- tibble::tibble(
    palette = names(esri_color_ramps),
    tags = unname(lapply(esri_color_ramps, \(.x) .x$tags))
  )

  color_mode <- vapply(
    esri_color_ramps,
    \(.x) {
      if ("light" %in% .x$tags) {
        "light"
      } else if ("dark" %in% .x$tags) {
        "dark"
      } else {
        NA_character_
      }
    },
    character(1),
    USE.NAMES = FALSE
  )

  arcgisutils::data_frame(cbind(.x, color_mode = color_mode))[c(
    "palette",
    "color_mode",
    "tags"
  )]
}

# table(unlist(.x$tags)) |>
#   sort(TRUE)
