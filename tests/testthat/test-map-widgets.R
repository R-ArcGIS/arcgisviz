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
    add_widget(arc_map(), "legend", position = "top-left", TRUE),
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
