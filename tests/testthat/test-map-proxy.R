map_points <- function() {
  skip_if_not_installed("sf")
  df <- data.frame(
    x = c(-80, -81, -82),
    y = c(35, 36, 37),
    value = c(1, 5, 3),
    group = c("a", "b", "a")
  )
  sf::st_as_sf(df, coords = c("x", "y"), crs = 4326)
}

fake_map_session <- function() {
  sent <- list()
  list(
    sendCustomMessage = function(type, message) {
      sent[[length(sent) + 1]] <<- list(type = type, message = message)
      invisible(NULL)
    },
    sent = function() sent
  )
}

fake_map_proxy <- function() {
  session <- fake_map_session()
  list(proxy = arc_map_proxy("map", session = session), session = session)
}

# The browser parses the payload string, so that is what these assert on.
# Arrays stay lists: simplifying them to a data frame would hide the shape
# the client actually reads.
sent_payload <- function(session, i = 1) {
  yyjsonr::read_json_str(
    session$sent()[[i]]$message$payload,
    opts = yyjsonr::opts_read_json(arr_of_objs_to_df = FALSE)
  )
}

# Reading the payload back simplifies a one-element array to a scalar, which
# is exactly the distinction some of these tests are about.
sent_json <- function(session, i = 1) {
  session$sent()[[i]]$message$payload
}

test_that("a map proxy inherits ArcMap, so every set_*() works on it", {
  p <- fake_map_proxy()$proxy

  expect_true(S7::S7_inherits(p, ArcMap))
  expect_s3_class(set_basemap(p, "satellite"), "arcgisviz::ArcMapProxy")

  updated <- p |> set_basemap("satellite") |> set_view(zoom = 6)
  expect_identical(updated@basemap, "satellite")
  expect_identical(updated@zoom, 6)
  expect_identical(updated@output_id, "map")
})

test_that("arc_update() sends only what was set", {
  f <- fake_map_proxy()
  f$proxy |> set_basemap("satellite") |> arc_update()

  msg <- f$session$sent()[[1]]
  expect_identical(msg$type, "arcgisviz-map")
  expect_identical(msg$message$method, "update")
  expect_identical(msg$message$id, "map")

  payload <- sent_payload(f$session)
  expect_identical(payload$basemap, "satellite")
  expect_false("center" %in% names(payload))
  expect_false("zoom" %in% names(payload))
})

test_that("a layer added through a proxy travels as an IFeatureLayer", {
  f <- fake_map_proxy()
  f$proxy |>
    add_layer(map_points(), color = value, name = "Points") |>
    arc_update()

  layer <- sent_payload(f$session)$layers[[1]]
  expect_identical(layer$id, "Points")
  expect_identical(layer$layerType, "ArcGISFeatureLayer")

  # fields must stay an array of objects; the browser maps Field.fromJSON.
  # jsonlite would have sent it columnar, which is why map_send() serializes.
  fields <- layer$featureCollection$layers[[1]]$layerDefinition$fields
  expect_true(rlang::is_list(fields))
  expect_named(
    fields[[1]],
    c("name", "type", "alias", "length", "editable", "nullable")
  )
  expect_true("value" %in% vapply(fields, function(f) f$name, character(1)))
})

test_that("a proxy layer must be named, since the name is its handle", {
  f <- fake_map_proxy()

  expect_error(add_layer(f$proxy, map_points()), "is required")
  expect_silent(add_layer(f$proxy, map_points(), name = "Points"))
})

test_that("layer targeting is by name, and NULL means every layer", {
  f <- fake_map_proxy()
  f$proxy |> set_filter("value > 2", layer = "Points")
  f$proxy |> set_filter("value > 2")
  f$proxy |> set_layer("Points", visible = FALSE, opacity = 0.5)
  f$proxy |> remove_layer()

  expect_identical(sent_payload(f$session, 1)$ids, "Points")
  expect_identical(sent_payload(f$session, 1)$where, "value > 2")

  # An absent `ids` key is how the client reads "all of them".
  expect_false("ids" %in% names(sent_payload(f$session, 2)))

  props <- sent_payload(f$session, 3)$props
  expect_false(props$visible)
  expect_identical(props$opacity, 0.5)

  expect_identical(f$session$sent()[[4]]$message$method, "remove")
})

test_that("a cleared filter or selection sends no value at all", {
  f <- fake_map_proxy()
  f$proxy |> set_filter(NULL)
  f$proxy |> set_selection(integer())

  expect_false("where" %in% names(sent_payload(f$session, 1)))
  expect_false("objectIds" %in% names(sent_payload(f$session, 2)))
})

test_that("set_selection() selects by object id", {
  f <- fake_map_proxy()
  f$proxy |> set_selection(c(1, 2), layer = "Points")

  msg <- f$session$sent()[[1]]$message
  expect_identical(msg$method, "select")

  payload <- sent_payload(f$session)
  expect_identical(payload$objectIds, c(1L, 2L))
  expect_identical(payload$mode, "replace")
})

# A bare number has no length in JS, so the client would read it as a clear.
test_that("selecting one feature still sends an array", {
  f <- fake_map_proxy()
  f$proxy |> set_selection(7)

  expect_match(sent_json(f$session), '"objectIds":[7]', fixed = TRUE)
})

test_that("set_selection() carries the mode the selection set is changed by", {
  f <- fake_map_proxy()
  f$proxy |> set_selection(3, mode = "toggle")

  expect_identical(sent_payload(f$session)$mode, "toggle")
  expect_error(set_selection(f$proxy, 3, mode = "invert"), "mode")
})

test_that("arc_draw_selection() turns a friendly tool into the two spec properties", {
  f <- fake_map_proxy()
  f$proxy |> arc_draw_selection(tool = "lasso", mode = "add", layer = "Points")

  msg <- f$session$sent()[[1]]$message
  expect_identical(msg$method, "selectBy")

  payload <- sent_payload(f$session)
  expect_identical(payload$createTool, "polygon")
  expect_identical(payload$mode, "freehand")
  expect_identical(payload$type, "add")
  expect_match(sent_json(f$session), '"ids":["Points"]', fixed = TRUE)
})

test_that("arc_draw_selection() sends no draw mode for a tool that has none", {
  f <- fake_map_proxy()
  f$proxy |> arc_draw_selection()

  payload <- sent_payload(f$session)
  expect_identical(payload$createTool, "rectangle")
  expect_false("mode" %in% names(payload))
  expect_error(arc_draw_selection(f$proxy, tool = "freehand"), "tool")
})

test_that("arc_selected() reads the ids out of a selection event", {
  event <- list(
    count = 3,
    layers = list(
      list(layer = "Counties", objectIds = list(1, 2)),
      list(layer = "Seats", objectIds = list(9))
    )
  )

  expect_identical(arc_selected(event), c(1L, 2L, 9L))
  expect_identical(arc_selected(event, layer = "Seats"), 9L)
  expect_identical(arc_selected(list(count = 0, layers = list())), integer())
})

test_that("a selectable layer and a highlight style ride on the update", {
  f <- fake_map_proxy()
  f$proxy |>
    add_layer(map_points(), name = "Points", selectable = TRUE) |>
    set_highlight(color = "orange", fill_opacity = 0.4) |>
    arc_update()

  payload <- sent_payload(f$session)
  expect_match(sent_json(f$session), '"selectable":["Points"]', fixed = TRUE)
  expect_identical(payload$highlight[[1]]$name, "default")
  expect_identical(payload$highlight[[1]]$color, "#FFA500FF")
  expect_identical(payload$highlight[[1]]$fillOpacity, 0.4)
  expect_false("haloOpacity" %in% names(payload$highlight[[1]]))
})

test_that("arc_goto() drops what it was not given", {
  f <- fake_map_proxy()
  f$proxy |> arc_goto(center = c(-79, 35), duration = 800)

  target <- sent_payload(f$session)$target
  expect_identical(target$center, c(-79, 35))
  expect_false("zoom" %in% names(target))
  expect_identical(sent_payload(f$session)$options$duration, 800)
})

test_that("a map proxy refuses what it cannot do", {
  f <- fake_map_proxy()

  expect_error(arc_goto(f$proxy), "somewhere to go")
  expect_error(set_filter(f$proxy, where = 1), "single SQL clause")
  expect_error(arc_screenshot(f$proxy, "gif"), "must be one of")
  expect_error(set_layer(f$proxy, 1), "must be the name")
  expect_error(set_layer(arc_map(), "Points"), "must be an")

  # A plain map is not a proxy, and the message has to say so.
  expect_error(arc_update(arc_map()), "must be an")
  expect_error(set_filter(arc_map(), "x > 1"), "must be an")
})
