# The ramp catalogue in R/sysdata.rda, and the frame built over it. Counts
# come from @arcgis/core's own colors.js, so a bump to the SDK should fail
# these rather than silently change what set_color() accepts.

test_that("esri_palettes() describes every ramp exactly once", {
  all <- esri_palettes()

  expect_identical(nrow(all), length(esri_color_ramps))
  expect_identical(all$palette, names(esri_color_ramps))
  expect_identical(
    names(all),
    c(
      "palette",
      "type",
      "color_mode",
      "colorblind_friendly",
      "n_stops",
      "hues",
      "tags"
    )
  )

  # Every ramp is drawn for exactly one background, so the column never
  # falls back to NA.
  expect_setequal(all$color_mode, c("light", "dark"))
  expect_false(anyNA(all$color_mode))

  # A ramp carries at most one type tag, which is what makes it a scalar.
  expect_setequal(
    stats::na.omit(all$type),
    c("sequential", "diverging", "categorical")
  )
  expect_true(anyNA(all$type))
})

test_that("esri_palettes() narrows on each argument", {
  diverging <- esri_palettes(type = "diverging")
  expect_true(all(diverging$type == "diverging"))

  dark <- esri_palettes(color_mode = "dark")
  expect_true(all(dark$color_mode == "dark"))

  # `hue` keeps a ramp drawing on any of the families named.
  warm <- esri_palettes(hue = c("reds", "oranges"))
  expect_true(all(vapply(
    warm$hues,
    function(h) any(c("reds", "oranges") %in% h),
    logical(1)
  )))

  # `tag` keeps only ramps carrying all of them.
  both <- esri_palettes(tag = c("heatmap", "colorblind-friendly"))
  expect_true(all(vapply(
    both$tags,
    function(t) all(c("heatmap", "colorblind-friendly") %in% t),
    logical(1)
  )))
  expect_lt(nrow(both), nrow(esri_palettes(tag = "heatmap")))

  # Arguments compose, and row names do not carry the gaps over.
  narrow <- esri_palettes(type = "sequential", color_mode = "light")
  expect_true(all(narrow$type == "sequential" & narrow$color_mode == "light"))
  expect_identical(row.names(narrow), as.character(seq_len(nrow(narrow))))
})

test_that("esri_palettes() rejects a tag it does not know", {
  expect_error(esri_palettes(type = "nope"), "must be one of")
  expect_error(esri_palettes(color_mode = "grey"), "must be one of")
  expect_error(esri_palettes(hue = "teal"), "must be one of")
  expect_error(esri_palettes(tag = "nope"), "must be one of")
})

test_that("the ramps set_color() leans on are all present", {
  # Named in the docs and in R/arc-chart.R's own defaults.
  expect_true(all(
    c("Blue 3", "Heatmap 3", "Purple 1", "Red 1") %in% esri_palettes()$palette
  ))

  # Ramps tagged heatmap are the ones a heat chart should reach for.
  expect_gt(nrow(esri_palettes(tag = "heatmap")), 0)

  expect_true(all(c("heatmap", "colorblind-friendly") %in% palette_tags()))
  expect_false(is.unsorted(palette_tags()))
})
