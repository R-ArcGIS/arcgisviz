parquet_points <- function(crs = 4326) {
  skip_if_not_installed("sf")
  skip_if_not_installed("nanoparquet")
  skip_if_not_installed("wk")
  df <- data.frame(x = c(-80, -81, -82), y = c(35, 36, 37), value = c(1, 5, 3))
  sf::st_transform(sf::st_as_sf(df, coords = c("x", "y"), crs = 4326), crs)
}

# The browser parses the widget payload, so that is what these assert on.
parquet_payload <- function(widget) {
  yyjsonr::read_json_str(
    widget_json(widget$x),
    opts = yyjsonr::opts_read_json(arr_of_objs_to_df = FALSE)
  )$layers[[1]]
}

# nanoparquet reads a BYTE_ARRAY back as a blob, which wk will not take.
parquet_coords <- function(geometry) {
  wk::wk_coords(wk::new_wk_wkb(lapply(geometry, identity)))
}

parquet_path <- function(widget) {
  dep <- widget$dependencies[[1]]
  file.path(dep$src$file, dep$attachment$data)
}

test_that("a parquet layer sends the ParquetLayer shape and no features", {
  widget <- as_widget(add_layer(
    arc_map(),
    parquet_points(),
    color = value,
    format = "parquet"
  ))
  layer <- parquet_payload(widget)

  expect_identical(layer$type, "parquet")
  expect_identical(layer$geometryType, "point")
  expect_identical(
    layer$geometryEncoding,
    list(type = "wkb", field = "geometry")
  )
  expect_identical(layer$spatialReference$wkid, 4326L)
  expect_identical(layer$renderer$visualVariables[[1]]$field, "value")
  # The local path must never reach the page; the attachment names the file.
  expect_null(layer$file)
  expect_null(layer$featureCollection)
  expect_identical(layer$attachment, widget$dependencies[[1]]$name)
})

test_that("the attached file is GeoParquet with a WKB geometry column", {
  widget <- as_widget(add_layer(
    arc_map(),
    parquet_points(),
    format = "parquet"
  ))
  path <- parquet_path(widget)

  schema <- nanoparquet::read_parquet_schema(path)
  expect_identical(schema$type[schema$name == "geometry"], "BYTE_ARRAY")

  meta <- nanoparquet::read_parquet_metadata(path)$file_meta_data
  kv <- meta$key_value_metadata[[1]]
  geo <- yyjsonr::read_json_str(kv$value[kv$key == "geo"])
  expect_identical(geo$primary_column, "geometry")
  expect_identical(geo$columns$geometry$encoding, "WKB")

  data <- nanoparquet::read_parquet(path)
  expect_identical(data$value, c(1, 5, 3))
  coords <- parquet_coords(data$geometry)
  expect_equal(coords$x, c(-80, -81, -82))
})

test_that("a projected layer is written in longitude and latitude", {
  widget <- as_widget(add_layer(
    arc_map(),
    parquet_points(crs = 3857),
    format = "parquet"
  ))
  data <- nanoparquet::read_parquet(parquet_path(widget))
  coords <- parquet_coords(data$geometry)
  expect_equal(coords$y, c(35, 36, 37))
})

test_that("any column wk can read is a geometry, not just sf", {
  skip_if_not_installed("nanoparquet")
  skip_if_not_installed("wk")
  df <- data.frame(value = c(1, 2))
  df$points <- wk::as_wkb(wk::xy(c(-80, -81), c(35, 36)))

  widget <- as_widget(add_layer(arc_map(), df, format = "parquet"))
  layer <- parquet_payload(widget)
  expect_identical(layer$geometryEncoding$field, "points")
  expect_identical(layer$geometryType, "point")
})

test_that("a parquet layer needs exactly one geometry column", {
  skip_if_not_installed("nanoparquet")
  skip_if_not_installed("wk")
  expect_snapshot(
    add_layer(arc_map(), data.frame(a = 1), format = "parquet"),
    error = TRUE
  )

  two <- data.frame(a = 1)
  two$here <- wk::as_wkb(wk::xy(0, 0))
  two$there <- wk::as_wkb(wk::xy(1, 1))
  expect_snapshot(add_layer(arc_map(), two, format = "parquet"), error = TRUE)
})

test_that("a parquet layer refuses mixed geometry types", {
  skip_if_not_installed("nanoparquet")
  skip_if_not_installed("wk")
  mixed <- data.frame(a = 1:2)
  mixed$geometry <- wk::as_wkb(wk::wkt(c(
    "POINT (0 0)",
    "LINESTRING (0 0, 1 1)"
  )))
  expect_snapshot(add_layer(arc_map(), mixed, format = "parquet"), error = TRUE)
})

test_that("two maps never share a parquet file", {
  # htmltools keeps one dependency per name, and both layers get the same id.
  one <- as_widget(add_layer(arc_map(), parquet_points(), format = "parquet"))
  two <- as_widget(add_layer(arc_map(), parquet_points(), format = "parquet"))
  expect_false(identical(
    one$dependencies[[1]]$name,
    two$dependencies[[1]]$name
  ))
})

test_that("a parquet layer is not yet available on a proxy", {
  session <- list(sendCustomMessage = function(...) invisible(NULL))
  proxy <- arc_map_proxy("map", session = session)
  expect_snapshot(
    add_layer(proxy, parquet_points(), name = "pts", format = "parquet"),
    error = TRUE
  )
})
