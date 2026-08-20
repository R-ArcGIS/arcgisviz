test_df <- function() {
  data.frame(category = c("a", "b", "c"), value = c(1, 5, 3))
}

# Captures what proxy_send() would put on the wire.
fake_session <- function() {
  sent <- list()
  list(
    sendCustomMessage = function(type, message) {
      sent[[length(sent) + 1]] <<- list(type = type, message = message)
      invisible(NULL)
    },
    sent = function() sent
  )
}

fake_proxy <- function(chart = arc_col(test_df(), category, value)) {
  session <- fake_session()
  proxy <- arc_proxy("chart", chart, session = session)
  list(proxy = proxy, session = session)
}

test_that("a proxy inherits ArcChart, so every set_*() works on it", {
  p <- fake_proxy()$proxy

  expect_true(S7::S7_inherits(p, ArcChart))
  expect_s3_class(set_x(p, value), "arcgisviz::ArcProxy")

  # The mapping really changes, and the output id survives the round trip.
  updated <- p |> set_x(value) |> set_flipped()
  expect_identical(updated@x, "value")
  expect_true(updated@flipped)
  expect_identical(updated@output_id, "chart")
})

test_that("arc_update() sends the rebuilt config and nothing else", {
  f <- fake_proxy()
  f$proxy |> set_labs(title = "Hi") |> arc_update()

  msg <- f$session$sent()[[1]]
  expect_identical(msg$type, "arcgisviz-chart")
  expect_identical(msg$message$method, "config")
  expect_identical(msg$message$id, "chart")
  expect_identical(msg$message$payload$config$title$content$text, "Hi")

  # The layer is never resent; that is the whole point of a proxy.
  expect_null(msg$message$payload$iLayer)
})

test_that("set_filter() goes to the element, not the model", {
  f <- fake_proxy()
  set_filter(f$proxy, "value > 2")

  msg <- f$session$sent()[[1]]$message
  expect_identical(msg$method, "element")
  expect_identical(msg$payload$runtimeDataFilters$where, "value > 2")

  expect_error(set_filter(f$proxy, where = 1), "single SQL clause")
})

test_that("a blank filter keeps the key so Shiny sends a JSON null", {
  # Shiny drops an absent key but serializes a NULL-valued one to null, and
  # null is what clears a filter client-side.
  for (blank in list(NULL, NA, NA_character_, "")) {
    f <- fake_proxy()
    set_filter(f$proxy, blank)

    filters <- f$session$sent()[[1]]$message$payload$runtimeDataFilters
    expect_named(filters, c("where", "objectIds"))
    expect_null(filters$where)
  }
})

test_that("object ids clear on an empty vector", {
  f <- fake_proxy()
  set_filter(f$proxy, object_ids = c(1, 2))
  expect_identical(
    f$session$sent()[[1]]$message$payload$runtimeDataFilters$objectIds,
    list(1L, 2L)
  )

  set_filter(f$proxy, object_ids = integer())
  expect_null(
    f$session$sent()[[2]]$message$payload$runtimeDataFilters$objectIds
  )
})

test_that("set_legend() writes model accessors", {
  f <- fake_proxy()
  set_legend(f$proxy, visible = TRUE, position = "bottom", title = "Key")

  msg <- f$session$sent()[[1]]$message
  expect_identical(msg$method, "model")
  expect_true(msg$payload$legendVisibility)
  expect_identical(msg$payload$legendPosition, "bottom")
  expect_identical(msg$payload$legendTitleText, "Key")

  expect_error(set_legend(f$proxy, position = "sideways"), "must be one of")
})

test_that("the method wrappers send a call with their arguments", {
  f <- fake_proxy()
  arc_reset_zoom(f$proxy)
  arc_export_image(f$proxy, "svg")
  set_selection(f$proxy, c(1, 2))

  sent <- f$session$sent()
  expect_identical(sent[[1]]$message$payload$method, "resetZoom")
  expect_identical(sent[[2]]$message$payload$method, "exportAsImage")
  expect_identical(sent[[2]]$message$payload$args, list("svg"))

  # An empty selection is a clear, not an empty selection payload.
  expect_identical(
    sent[[3]]$message$payload$selectionData$selectionOIDs,
    list(1L, 2L)
  )
  set_selection(f$proxy, integer())
  expect_identical(
    f$session$sent()[[4]]$message$payload$method,
    "clearSelection"
  )

  expect_error(arc_export_image(f$proxy, "gif"), "must be one of")
})

test_that("the proxy functions refuse a plain chart", {
  chart <- arc_col(test_df(), category, value)

  expect_error(arc_update(chart), "must be an")
  expect_error(set_filter(chart, "x > 1"), "must be an")
  expect_error(arc_proxy("chart", "not a chart"), "must be an")
})
