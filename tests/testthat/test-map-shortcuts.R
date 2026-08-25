specs_of <- function(map) {
  map_widget_specs(map@widgets)
}

# Each shortcut has to be add_widget() and nothing more, or the two surfaces
# drift apart.
test_that("a shortcut builds exactly what add_widget() builds", {
  pairs <- list(
    list(add_legend(arc_map()), add_widget(arc_map(), "legend")),
    list(
      add_layer_list(arc_map(), show_filter = TRUE),
      add_widget(arc_map(), "layer-list", show_filter = TRUE)
    ),
    list(
      add_basemap_gallery(arc_map(), expand = TRUE),
      add_widget(arc_map(), "basemap-gallery", expand = TRUE)
    ),
    list(
      add_scale_bar(arc_map(), unit = "dual", position = "bottom-right"),
      add_widget(
        arc_map(),
        "scale-bar",
        position = "bottom-right",
        unit = "dual"
      )
    ),
    list(
      add_zoom(arc_map(), layout = "horizontal"),
      add_widget(arc_map(), "zoom", layout = "horizontal")
    ),
    list(
      add_editor(arc_map(), sync_view_selection = TRUE),
      add_widget(arc_map(), "editor", sync_view_selection = TRUE)
    )
  )

  for (pair in pairs) {
    expect_identical(specs_of(pair[[1]]), specs_of(pair[[2]]))
  }
})

test_that("an argument left unset never reaches the component", {
  props <- specs_of(add_search(arc_map()))[[1]]$props
  expect_identical(props, list())

  set <- specs_of(add_search(arc_map(), max_results = 3))[[1]]$props
  expect_identical(set, list(maxResults = 3))
})

test_that("sketch renames availableCreateTools and keeps it an array", {
  props <- specs_of(add_sketch(arc_map(), tools = "polygon"))[[1]]$props
  expect_identical(props$availableCreateTools, list("polygon"))
})

test_that("add_measurement() picks its component from type", {
  expect_identical(
    specs_of(add_measurement(arc_map()))[[1]]$component,
    "arcgis-area-measurement-2d"
  )
  expect_identical(
    specs_of(add_measurement(arc_map(), "distance"))[[1]]$component,
    "arcgis-distance-measurement-2d"
  )
  expect_error(add_measurement(arc_map(), "volume"), "type")

  # One of each is two widgets, since they are different components.
  both <- arc_map() |>
    add_measurement("area") |>
    add_measurement("distance")
  expect_length(specs_of(both), 2)
})

test_that("a shortcut blames itself, not the function it calls", {
  err <- rlang::catch_cnd(add_legend(arc_map(), nope = 1))

  expect_match(conditionMessage(err), "no property")
  expect_identical(rlang::call_name(conditionCall(err)), "add_legend")
})

test_that("every shortcut names a widget the registry knows", {
  shortcuts <- c(
    "add_legend",
    "add_layer_list",
    "add_basemap_gallery",
    "add_basemap_toggle",
    "add_search",
    "add_bookmarks",
    "add_scale_bar",
    "add_coordinate_conversion",
    "add_zoom",
    "add_home",
    "add_compass",
    "add_fullscreen",
    "add_locate",
    "add_track",
    "add_sketch",
    "add_editor",
    "add_measurement"
  )

  for (fn in shortcuts) {
    map <- do.call(fn, list(arc_map()))
    expect_length(specs_of(map), 1)
  }

  # Every widget in the registry is reachable by a shortcut.
  reached <- vapply(
    shortcuts,
    function(fn) specs_of(do.call(fn, list(arc_map())))[[1]]$component,
    character(1)
  )
  components <- vapply(map_widget_map, function(x) x$component, character(1))
  expect_setequal(
    setdiff(components, reached),
    "arcgis-distance-measurement-2d"
  )
})
