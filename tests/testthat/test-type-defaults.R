# Regression coverage for the s7x default-value bugs fixed during the
# @arcgis/charts-components re-point: bare Enum properties, bare
# property_scalar() presets, and property_union() properties without an
# explicit NULL member all used to error on omission instead of defaulting
# to NA. See CLAUDE.md / the arcgis-spec-types skill for the "NA already
# satisfies optional scalar/enum properties" convention this verifies.

test_that("a bare enum property defaults to NA when omitted", {
  expect_true(is.na(IFontStyle()@value))

  font <- IFont()
  expect_true(is.na(font@style@value))
})

test_that("a bare scalar property defaults to NA when omitted", {
  font <- IFont()
  expect_true(is.na(font@family))
  expect_true(is.na(font@size))
})

test_that("a property_union() without a NULL member derives a working default", {
  symbol <- WebChartTextSymbol(type = "esriTS")
  expect_true(is.na(symbol@xoffset))
  expect_true(is.na(symbol@yoffset))
})

test_that("a minimally-specified WebChart constructs without every property set", {
  chart <- WebChart(
    version = "25.1.0",
    type = "chart",
    series = list(
      WebChartBarChartSeries(
        type = "barSeries",
        id = "s1",
        name = "Series 1",
        x = "category",
        y = "value"
      )
    )
  )

  expect_true(S7::S7_inherits(chart, WebChart))
  expect_length(chart@series, 1)
  expect_true(S7::S7_inherits(chart@series[[1]], WebChartBarChartSeries))
})
