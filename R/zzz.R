#' @include arcgis-chart-widget.R
NULL

# Required because R/arc-data.R adds methods to s7x's `as_vector()` generic.
# Without this they are registered at build time and lost on install.
.onLoad <- function(libname, pkgname) {
  S7::methods_register()
}
