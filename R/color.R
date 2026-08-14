library(S7)

#' Color
#'
#' An RGBA color, as `r`/`g`/`b`/`a` components rather than the spec's raw
#' `[r,g,b,a]` tuple.
#'
#' @name Color
#' @export
Color := new_class(
  properties = list(
    r = s7x::class_double,
    g = s7x::class_double,
    b = s7x::class_double,
    a = s7x::class_double
  )
)
