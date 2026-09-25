# A layer's featureSet travels as a verbatim JSON string; parse it the way the
# browser does.
parse_features <- function(layer) {
  yyjsonr::read_json_str(
    layer$featureCollection$layers[[1]]$featureSet,
    opts = yyjsonr::opts_read_json(arr_of_objs_to_df = FALSE)
  )
}
