#' @include types-feature-layer.R
NULL

# @arcgis/core's ParquetLayer (layers/ParquetLayer.d.ts). No web map spec
# object exists for it, so the properties are the constructor's own; the
# renderer and popupInfo are REST JSON the client converts with fromJSON().

library(S7)

# layers/support/GeometryEncodingWkb.d.ts. The only encoding written here:
# the other one, "location", covers points stored as x/y columns.
GeometryEncodingWkb := new_class(
  properties = list(
    type = s7x::property_scalar(class_character, default = "wkb"),
    field = s7x::class_string
  )
)

# `file` is the local .parquet path. It never reaches the browser: the file
# travels as a widget attachment, and `as_vector()` sends its name instead.
ParquetLayer := new_class(
  properties = list(
    id = s7x::class_string,
    title = s7x::class_string,
    opacity = s7x::property_range(0, 1),
    visible = s7x::class_boolean,
    geometryType = s7x::class_string,
    geometryEncoding = GeometryEncodingWkb,
    spatialReference = class_any,
    renderer = class_any,
    popupInfo = class_any,
    file = s7x::class_string
  )
)
