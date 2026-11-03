#' @include types-parquet-layer.R arc-data.R
NULL

# A layer sent as a GeoParquet file rather than as Esri JSON: WKB geometry,
# written by nanoparquet, read in the browser by @arcgis/core's ParquetLayer.

esri_parquet_geometry <- c(
  esriGeometryPoint = "point",
  esriGeometryMultipoint = "multipoint",
  esriGeometryPolyline = "polyline",
  esriGeometryPolygon = "polygon"
)

as_parquet_layer <- function(
  .data,
  geometry,
  title,
  id,
  renderer = NULL,
  opacity = NULL,
  visibility = NULL,
  popup_info = NULL
) {
  column <- geometry_column(.data)
  ParquetLayer(
    id = id,
    title = title,
    opacity = if (rlang::is_null(opacity)) NA_real_ else as.double(opacity),
    visible = if (rlang::is_null(visibility)) NA else visibility,
    geometryType = esri_parquet_geometry[[geometry]],
    geometryEncoding = GeometryEncodingWkb(field = column),
    spatialReference = list(wkid = 4326L),
    renderer = renderer,
    popupInfo = popup_info,
    file = write_geoparquet(.data, column)
  )
}

# The file rides as a dependency of the rendered widget, and a proxy message
# has nowhere to carry one yet.
check_parquet_layer <- function(map, .data, call) {
  if (S7::S7_inherits(map, ArcMapProxy)) {
    cli::cli_abort(
      "{.code format = \"parquet\"} is not yet supported on an
       {.cls ArcMapProxy}.",
      call = call
    )
  }
  rlang::check_installed(
    c("nanoparquet", "wk"),
    "to send a layer as GeoParquet.",
    call = call
  )
  invisible(wk_geometry_type(.data, call))
}

# Any column wk can read: sfc, geoarrow_vctr, wk_wkb, wk_wkt. An sf object
# names its own; otherwise there must be exactly one.
geometry_column <- function(.data, call = rlang::caller_env()) {
  if (inherits(.data, "sf")) {
    return(attr(.data, "sf_column"))
  }
  given <- .data
  found <- names(given)[vapply(given, wk::is_handleable, logical(1))]
  if (length(found) != 1L) {
    cli::cli_abort(
      c(
        "{.arg .data} must have exactly one geometry column.",
        "x" = if (rlang::is_empty(found)) {
          "Found none."
        } else {
          "Found {.field {found}}."
        },
        "i" = "A geometry column is anything {.pkg wk} can read, such as
               {.cls sfc} or {.cls geoarrow_vctr}."
      ),
      call = call
    )
  }
  found
}

# wk_meta() codes, as sf_geometry_type() names them. WKB carries no vector
# level type, so it is read per feature.
wk_esri_geometry <- c(
  "1" = "esriGeometryPoint",
  "2" = "esriGeometryPolyline",
  "3" = "esriGeometryPolygon",
  "4" = "esriGeometryMultipoint",
  "5" = "esriGeometryPolyline",
  "6" = "esriGeometryPolygon"
)

wk_geometry_type <- function(.data, call = rlang::caller_env()) {
  geom <- .data[[geometry_column(.data, call)]]
  code <- wk::wk_vector_meta(geom)$geometry_type
  if (code == 0L) {
    code <- unique(wk::wk_meta(geom)$geometry_type)
    code <- code[!is.na(code)]
  }
  esri <- unique(unname(wk_esri_geometry[as.character(code)]))

  if (length(esri) != 1L || is.na(esri)) {
    cli::cli_abort(
      c(
        "{.arg .data} must hold one supported geometry type.",
        "i" = "Points, lines, and polygons can each be multi-part, but not
               mixed with one another."
      ),
      call = call
    )
  }
  esri
}

# ParquetLayer reads WKB only in WGS84 or Web Mercator. A missing CRS is taken
# as longitude/latitude; any other is reprojected, which needs sf.
lonlat_geometry <- function(geom) {
  crs <- wk::wk_crs(geom)
  # sf spells a missing CRS as a `crs` object that is.na(), not as NULL.
  missing <- rlang::is_null(crs) || (inherits(crs, "crs") && is.na(crs))
  if (missing || wk::wk_crs_equal(crs, wk::wk_crs_longlat())) {
    return(geom)
  }
  rlang::check_installed("sf", "to reproject a layer to longitude/latitude.")
  if (!inherits(geom, "sfc")) {
    geom <- sf::st_as_sfc(geom)
  }
  sf::st_transform(geom, 4326)
}

# GeoParquet's default CRS is OGC:CRS84, so `crs` is omitted.
write_geoparquet <- function(.data, column) {
  df <- as.data.frame(.data)
  df[[column]] <- unclass(wk::as_wkb(lonlat_geometry(.data[[column]])))

  geo <- list(
    version = "1.1.0",
    primary_column = column,
    columns = rlang::set_names(
      list(list(encoding = "WKB", geometry_types = list())),
      column
    )
  )

  dir <- tempfile("arcgisviz-parquet-")
  dir.create(dir)
  path <- file.path(dir, "layer.parquet")
  nanoparquet::write_parquet(
    df,
    path,
    metadata = c(geo = yyjsonr::write_json_str(geo, auto_unbox = TRUE))
  )
  path
}

# Named after the file's own unique directory, not the layer id: htmltools
# keeps one dependency per name, so two maps sharing an id would share data.
parquet_attachment <- function(layer) {
  basename(dirname(layer@file))
}

parquet_dependency <- function(layer) {
  htmltools::htmlDependency(
    name = parquet_attachment(layer),
    version = "1.0.0",
    src = dirname(layer@file),
    attachment = list(data = basename(layer@file)),
    all_files = FALSE
  )
}

S7::method(as_vector, ParquetLayer) <- function(x, ...) {
  out <- as_vector(S7::super(x, S7::S7_object), ...)
  out$file <- NULL
  out$type <- "parquet"
  out$attachment <- parquet_attachment(x)
  out[!vapply(out, is_unset, logical(1))]
}
