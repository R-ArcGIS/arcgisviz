library(S7)

#' @export
Color := new_class(
  properties = list(
    r = s7x::class_double,
    g = s7x::class_double,
    b = s7x::class_double,
    a = s7x::class_double
  )
)
