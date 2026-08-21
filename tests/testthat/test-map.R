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

test_that("tooltip fields ride as popupInfo, the spec's own shape", {
  layer <- sent_layer(add_layer(
    arc_map(),
    test_points(),
    tooltip = c(Group = group, value),
    name = "Points"
  ))

  info <- layer$featureCollection$layers[[1]]$popupInfo
  expect_identical(info$title, "Points")
  expect_identical(
    vapply(info$fieldInfos, function(f) f$fieldName, character(1)),
    c("group", "value")
  )

  # A bare column labels itself; a named one takes the name.
  expect_identical(
    vapply(info$fieldInfos, function(f) f$label, character(1)),
    c("Group", "value")
  )

  # A named layer is identified by its name so a proxy can refer to it.
  expect_identical(layer$id, "Points")
})

test_that("a layer without a tooltip carries no popupInfo", {
  layer <- sent_layer(add_layer(arc_map(), test_points()))
  expect_null(layer$featureCollection$layers[[1]]$popupInfo)
})

test_that("a date tooltip column stays an Esri date field", {
  skip_if_not_installed("sf")
  # Added after the geometry column on purpose: that ordering used to be
  # mis-indexed by arcgisutils::as_featureset().
  dated <- test_points()
  dated$when <- as.Date(c("2020-01-01", "2021-06-05", "2022-03-09"))

  layer <- sent_layer(add_layer(arc_map(), dated, tooltip = when))
  fields <- layer$featureCollection$layers[[1]]$layerDefinition$fields
  expect_identical(fields$type[fields$name == "when"], "esriFieldTypeDate")

  # Milliseconds from the epoch, which is what the browser has to reformat.
  attrs <- layer$featureCollection$layers[[1]]$featureSet$features[[1]]$attributes
  expect_identical(attrs$when, arcgisutils::date_to_ms(dated$when[[1]]))
})

test_that("a REST discriminator defaults rather than being restated", {
  # A renderer built by hand and handed to add_layer() would otherwise
  # serialize without the `type` jsonUtils.fromJSON() dispatches on.
  expect_identical(s7x::as_vector(ISimpleRenderer())$type, "simple")
  expect_identical(s7x::as_vector(IUniqueValueRenderer())$type, "uniqueValue")
  expect_identical(s7x::as_vector(IColorVisualVariable())$type, "colorInfo")
  expect_identical(s7x::as_vector(ISimpleMarkerSymbol())$type, "esriSMS")
  expect_identical(s7x::as_vector(ISimpleFillSymbol())$type, "esriSFS")
  expect_identical(s7x::as_vector(ISimpleLineSymbol())$type, "esriSLS")
})

test_that("new_renderer() takes a friendly type and emits the spec one", {
  simple <- s7x::as_vector(new_renderer("simple", label = "All"))
  expect_identical(simple$type, "simple")
  expect_identical(simple$label, "All")

  grouped <- s7x::as_vector(new_renderer("unique-value", field1 = "group"))
  expect_identical(grouped$type, "uniqueValue")
  expect_identical(grouped$field1, "group")

  # The default is the common case, so `type` can be left off entirely.
  expect_identical(s7x::as_vector(new_renderer())$type, "simple")
})

test_that("new_renderer() refuses arguments that would misbuild it", {
  expect_error(new_renderer("fancy"), "must be one of")
  expect_error(new_renderer("simple", field1 = "x"), "not a property")

  # Unnamed, a value would land on `type` and replace the discriminator.
  expect_error(
    new_renderer("simple", ISimpleMarkerSymbol()),
    "must be named"
  )
})

test_that("new_symbol() takes colours and styles the way users write them", {
  marker <- s7x::as_vector(new_symbol("marker", color = "steelblue", size = 8))
  expect_identical(marker$type, "esriSMS")
  expect_identical(marker$color, c(70, 130, 180, 255))
  expect_identical(marker$size, 8)

  # style defaults per family: a marker has no "solid", its styles are shapes.
  expect_identical(marker$style, "esriSMSCircle")
  expect_identical(s7x::as_vector(new_symbol("fill"))$style, "esriSFSSolid")
  expect_identical(s7x::as_vector(new_symbol("line"))$style, "esriSLSSolid")

  # Friendly kebab-case in, esri-prefixed enum value out.
  expect_identical(
    s7x::as_vector(new_symbol("fill", style = "backward-diagonal"))$style,
    "esriSFSBackwardDiagonal"
  )

  # Hex with alpha, and a nested symbol, both survive.
  fill <- s7x::as_vector(new_symbol(
    "fill",
    color = "#b8282899",
    outline = new_symbol("line", color = "white", width = 0.5)
  ))
  expect_identical(fill$color, c(184, 40, 40, 153))
  expect_identical(fill$outline$type, "esriSLS")
})

test_that("new_symbol() refuses arguments that would misbuild it", {
  expect_error(new_symbol("blob"), "must be one of")
  expect_error(new_symbol("marker", style = "solid"), "must be one of")
  expect_error(new_symbol("marker", width = 2), "not a property")
  expect_error(new_symbol("marker", color = "nosuchcolour"), "valid colours")
})

test_that("add_layer() dispatches on a prebuilt IFeatureLayer", {
  layer <- as_feature_layer(test_points()) |>
    add_renderer(ISimpleRenderer(
      symbol = ISimpleMarkerSymbol(size = 11),
      visualVariables = list(IColorVisualVariable(field = "value"))
    ))

  map <- add_layer(arc_map(), layer, name = "Points", opacity = 0.5)
  sent <- sent_layer(map)

  expect_identical(sent$id, "Points")
  expect_identical(sent$opacity, 0.5)

  renderer <- sent$featureCollection$layers[[1]]$layerDefinition$drawingInfo$renderer
  expect_identical(renderer$type, "simple")
  expect_identical(renderer$symbol$size, 11)
  expect_identical(renderer$visualVariables[[1]]$field, "value")
})

test_that("a prebuilt layer keeps an id its builder chose", {
  layer <- as_feature_layer(test_points(), id = "mine")
  expect_identical(sent_layer(add_layer(arc_map(), layer))$id, "mine")

  # An untouched default is positional instead, so two cannot collide.
  plain <- as_feature_layer(test_points())
  expect_identical(
    sent_layer(add_layer(arc_map(), plain))$id,
    "arcgisviz-layer-1"
  )
})

test_that("a prebuilt layer already answers the aesthetic arguments", {
  layer <- as_feature_layer(test_points())

  expect_error(add_layer(arc_map(), layer, color = value), "must be empty")
  expect_error(add_renderer(test_points(), ISimpleRenderer()), "IFeatureLayer")
  expect_error(add_renderer(layer, "nope"), "ISimpleRenderer")
})

test_that("a map refuses what it cannot draw", {
  expect_error(as_widget(arc_map()), "no layers")
  expect_error(arc_map("moon"), "must be one of")
  expect_error(set_basemap(arc_map(), "moon"), "must be one of")
  expect_error(set_view(arc_map(), center = 1), "two numbers")
  expect_error(add_layer(arc_map(), test_points(), missing), "not found")
  expect_error(set_basemap("not a map", "osm"), "must be an")
  expect_error(
    add_layer(arc_map(), test_points(), tooltip = c(group, nope)),
    "not found"
  )
  expect_error(
    add_layer(arc_map(), test_points(), tooltip = c(group + 1)),
    "bare column names"
  )

  # A plain data frame has no geometry to place.
  expect_error(
    as_widget(add_layer(arc_map(), data.frame(a = 1))),
    "must have geometry"
  )
})

test_that("a geometry only layer gets a real message, not an internal one", {
  skip_if_not_installed("sf")
  bare <- sf::st_as_sf(
    data.frame(x = -80, y = 35),
    coords = c("x", "y"),
    crs = 4326
  )

  expect_error(
    as_widget(add_layer(arc_map(), bare)),
    "at least one column besides its geometry"
  )
})

test_that("legendOptions is a typed class, not a bare list", {
  opts <- new_legend_options(title = "Births, 1974", order = "descending")

  expect_true(S7::S7_inherits(opts, ILegendOptions))
  expect_identical(s7x::as_vector(opts)$title, "Births, 1974")

  # Friendly name in, the spec's camelCase value out.
  expect_identical(s7x::as_vector(opts)$order, "descendingValues")
  expect_error(new_legend_options(order = "sideways"), "must be one of")
})

test_that("a colour ramp and a unique value renderer can both be titled", {
  ramp <- new_renderer(
    "simple",
    visualVariables = list(IColorVisualVariable(
      field = "value",
      legendOptions = new_legend_options(title = "Births")
    ))
  )
  vv <- s7x::as_vector(ramp)$visualVariables[[1]]
  expect_identical(vv$legendOptions$title, "Births")

  # Nested in a renderer, unset options compact away rather than send null.
  expect_named(vv$legendOptions, "title")

  grouped <- new_renderer(
    "unique-value",
    field1 = "group",
    legendOptions = new_legend_options(title = "Region")
  )
  expect_identical(s7x::as_vector(grouped)$legendOptions$title, "Region")
})
