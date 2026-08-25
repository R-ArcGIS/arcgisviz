as_widget_specs <- function(map) {
  map_widget_specs(map@widgets)
}

widget_points <- function() {
  skip_if_not_installed("sf")
  df <- data.frame(x = c(-80, -81), y = c(35, 36), value = c(1, 5))
  sf::st_as_sf(df, coords = c("x", "y"), crs = 4326)
}

test_that("a widget travels as its component, corner, and properties", {
  map <- add_widget(arc_map(), "legend")
  spec <- as_widget_specs(map)[[1]]

  expect_identical(spec$component, "arcgis-legend")
  expect_identical(spec$position, "bottom-left")
  expect_identical(spec$props, list())
})

test_that("position overrides the widget's own default corner", {
  map <- add_widget(arc_map(), "legend", position = "top-right")

  expect_identical(as_widget_specs(map)[[1]]$position, "top-right")
  expect_error(add_widget(arc_map(), "legend", position = "middle"), "position")
})

test_that("properties are written snake_case and sent camelCase", {
  map <- add_widget(
    arc_map(),
    "layer-list",
    show_filter = TRUE,
    filterText = "county"
  )

  props <- as_widget_specs(map)[[1]]$props
  expect_identical(props, list(showFilter = TRUE, filterText = "county"))
})

test_that("a widget refuses what its component cannot take", {
  expect_error(add_widget(arc_map(), "legends"), "widget")
  expect_error(
    add_widget(arc_map(), "legend", show_filter = TRUE),
    "no property"
  )
  expect_error(
    add_widget(
      arc_map(),
      "legend",
      position = "top-left",
      expand = FALSE,
      TRUE
    ),
    "must be named"
  )

  # The error names the properties it does take.
  expect_error(add_widget(arc_map(), "zoom", nope = 1), "layout")
})

test_that("adding a widget twice replaces it rather than stacking", {
  map <- arc_map() |>
    add_widget("legend", position = "top-left") |>
    add_widget("legend", position = "bottom-right")

  specs <- as_widget_specs(map)
  expect_length(specs, 1)
  expect_identical(specs[[1]]$position, "bottom-right")
})

test_that("widgets reach the rendered payload and only when there are any", {
  skip_if_not_installed("sf")
  map <- arc_map() |>
    add_layer(widget_points()) |>
    add_widget("legend") |>
    add_widget("search", max_results = 3)

  widgets <- as_widget(map)$x$widgets
  expect_length(widgets, 2)
  expect_identical(widgets[[2]]$props$maxResults, 3)

  plain <- add_layer(arc_map(), widget_points())
  expect_false("widgets" %in% names(as_widget(plain)$x))
})

test_that("map_widgets() lists every widget with what it takes", {
  widgets <- map_widgets()

  expect_true(all(c("widget", "component", "position") %in% names(widgets)))
  expect_true(all(startsWith(widgets$component, "arcgis-")))
  expect_true(all(widgets$position %in% map_positions))
  expect_true("legend" %in% widgets$widget)
  expect_true("legendStyle" %in% widgets$properties[[1]])
})

test_that("an array property stays an array with one element", {
  map <- add_widget(arc_map(), "sketch", available_create_tools = "polygon")

  props <- as_widget_specs(map)[[1]]$props
  expect_identical(props$availableCreateTools, list("polygon"))

  # A scalar property is left alone.
  expect_identical(
    as_widget_specs(add_widget(arc_map(), "sketch", layout = "vertical"))[[
      1
    ]]$props$layout,
    "vertical"
  )
})

test_that("the tools are widgets like any other", {
  widgets <- map_widgets()
  tools <- c("sketch", "editor", "area-measurement", "distance-measurement")

  expect_true(all(tools %in% widgets$widget))
  expect_identical(
    as_widget_specs(add_widget(arc_map(), "editor"))[[1]]$component,
    "arcgis-editor"
  )
})

test_that("arc_sf() reads an event's features and shrugs at an empty one", {
  skip_if_not_installed("sf")
  event <- list(
    action = "create",
    count = 1,
    features = paste0(
      '{"geometryType":"esriGeometryPoint",',
      '"spatialReference":{"wkid":4326},',
      '"features":[{"geometry":{"x":-80,"y":35},',
      '"attributes":{"object_id":1}}]}'
    )
  )

  drawn <- arc_sf(event)
  expect_s3_class(drawn, "sf")
  expect_identical(nrow(drawn), 1L)
  expect_identical(drawn$object_id, 1L)

  expect_null(arc_sf(list(action = "delete", count = 0, features = NULL)))
  expect_null(arc_sf(list()))
})

test_that("expand wraps a widget and is only sent when asked for", {
  plain <- as_widget_specs(add_widget(arc_map(), "basemap-gallery"))[[1]]
  expect_false("expand" %in% names(plain))

  collapsed <- as_widget_specs(
    add_widget(arc_map(), "basemap-gallery", expand = TRUE)
  )[[1]]
  expect_true(collapsed$expand)

  expect_error(
    add_widget(arc_map(), "legend", expand = "yes"),
    "must be .*TRUE"
  )
})

test_that("a collapsed widget survives the proxy path too", {
  skip_if_not_installed("shiny")
  sent <- list()
  session <- list(
    sendCustomMessage = function(type, message) {
      sent[[length(sent) + 1]] <<- message
      invisible(NULL)
    }
  )

  arc_map_proxy("map", session = session) |>
    add_widget("basemap-gallery", expand = TRUE) |>
    arc_update()

  payload <- yyjsonr::read_json_str(
    sent[[1]]$payload,
    opts = yyjsonr::opts_read_json(arr_of_objs_to_df = FALSE)
  )
  expect_true(payload$widgets[[1]]$expand)
})
