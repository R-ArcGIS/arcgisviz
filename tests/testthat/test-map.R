test_points <- function() {
  skip_if_not_installed("sf")
  df <- data.frame(
    x = c(-80, -81, -82),
    y = c(35, 36, 37),
    value = c(1, 5, 3),
    group = c("a", "b", "a")
  )
  sf::st_as_sf(df, coords = c("x", "y"), crs = 4326)
}

# The browser reads the serialized form, so that is what these assert on.
sent_layer <- function(map, i = 1) {
  s7x::as_vector(as_widget(map)$x$layers[[i]])
}

sent_definition <- function(map, i = 1) {
  sent_layer(map, i)$featureCollection$layers[[1]]$layerDefinition
}

sent_renderer <- function(map, i = 1) {
  sent_definition(map, i)$drawingInfo$renderer
}

test_that("a map layer is an IFeatureLayer carrying a feature collection", {
  layer <- sent_layer(add_layer(arc_map(), test_points()))

  expect_identical(layer$layerType, "ArcGISFeatureLayer")
  expect_identical(layer$id, "arcgisviz-layer-1")

  collection <- layer$featureCollection$layers[[1]]
  expect_identical(collection$layerDefinition$objectIdField, "object_id")
  expect_identical(collection$layerDefinition$geometryType, "esriGeometryPoint")
  expect_identical(collection$featureSet$geometryType, "esriGeometryPoint")
  expect_length(collection$featureSet$features, 3)

  # fields must stay an array of objects; the browser maps Field.fromJSON.
  expect_s3_class(collection$layerDefinition$fields, "data.frame")
})

test_that("colour picks the renderer from the column's type", {
  renderer <- sent_renderer(add_layer(arc_map(), test_points(), color = value))

  expect_identical(renderer$type, "simple")
  expect_identical(renderer$visualVariables[[1]]$type, "colorInfo")
  expect_identical(renderer$visualVariables[[1]]$field, "value")

  # A map resolves uniqueValue natively, unlike the scatter chart path.
  renderer <- sent_renderer(add_layer(arc_map(), test_points(), color = group))

  expect_identical(renderer$type, "uniqueValue")
  expect_identical(renderer$field1, "group")
  expect_identical(
    vapply(renderer$uniqueValueInfos, function(i) i$value, character(1)),
    c("a", "b")
  )
})

test_that("palette without a column is the layer's own colour", {
  renderer <- sent_renderer(add_layer(
    arc_map(),
    test_points(),
    palette = "red"
  ))

  expect_identical(renderer$type, "simple")
  expect_identical(renderer$symbol$color, c(255, 0, 0, 255))
  expect_null(renderer$visualVariables)
})

test_that("an unset renderer property is dropped, not sent as null", {
  renderer <- sent_renderer(add_layer(arc_map(), test_points()))

  expect_false("label" %in% names(renderer))
  expect_false("rotationType" %in% names(renderer))
})

test_that("size reaches the symbol for every renderer branch", {
  plain <- sent_renderer(add_layer(arc_map(), test_points(), size = 12))
  graded <- sent_renderer(add_layer(arc_map(), test_points(), value, size = 12))
  grouped <- sent_renderer(add_layer(
    arc_map(),
    test_points(),
    group,
    size = 12
  ))

  expect_identical(plain$symbol$size, 12)
  expect_identical(graded$symbol$size, 12)
  expect_identical(grouped$uniqueValueInfos[[1]]$symbol$size, 12)
})

test_that("the geometry type decides the symbol", {
  skip_if_not_installed("sf")
  poly <- sf::st_sf(
    id = 1,
    geometry = sf::st_sfc(
      sf::st_polygon(list(cbind(c(0, 1, 1, 0, 0), c(0, 0, 1, 1, 0)))),
      crs = 4326
    )
  )

  symbol <- sent_renderer(add_layer(arc_map(), poly))$symbol

  expect_identical(symbol$type, "esriSFS")
  expect_identical(symbol$style, "esriSFSSolid")
})

test_that("opacity and visibility ride on the layer, not the definition", {
  layer <- sent_layer(add_layer(arc_map(), test_points(), opacity = 0.5))

  expect_identical(layer$opacity, 0.5)
  expect_true(layer$visibility)

  # Unset opacity is dropped rather than sent as null.
  expect_false(
    "opacity" %in% names(sent_layer(add_layer(arc_map(), test_points())))
  )
})

test_that("the view is only sent when it is set", {
  framed <- as_widget(add_layer(arc_map(), test_points()))
  expect_null(framed$x$center)
  expect_null(framed$x$zoom)

  placed <- arc_map() |>
    add_layer(test_points()) |>
    set_view(center = c(-80, 35), zoom = 7) |>
    as_widget()

  expect_identical(placed$x$center, list(-80, 35))
  expect_identical(placed$x$zoom, 7)
})

test_that("a map refuses what it cannot draw", {
  expect_error(as_widget(arc_map()), "no layers")
  expect_error(arc_map("moon"), "must be one of")
  expect_error(set_basemap(arc_map(), "moon"), "must be one of")
  expect_error(set_view(arc_map(), center = 1), "two numbers")
  expect_error(add_layer(arc_map(), test_points(), missing), "not found")
  expect_error(set_basemap("not a map", "osm"), "must be an")

  # A plain data frame has no geometry to place.
  expect_error(
    as_widget(add_layer(arc_map(), data.frame(a = 1))),
    "must have geometry"
  )
})
