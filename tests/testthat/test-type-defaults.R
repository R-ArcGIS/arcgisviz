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

test_that("the histogram, box plot, and heat chart classes construct minimally", {
  expect_true(is.na(WebChartHistogramSeries(type = "histogramSeries")@binCount))
  expect_null(HistogramOverlays(type = "chartOverlays")@mean)
  expect_true(is.na(WebChartBoxPlotSeries(type = "boxPlotSeries")@x))
  expect_true(is.na(WebChartHeatChartSeries(type = "heatSeries")@y))

  expect_null(WebChartHeatChartGradient()@outsideRangeLowerColor)
  expect_true(is.na(WebChartHeatChartHeatClassBreaks()@breaksCount))
  expect_true(is.na(WebChartHeatChartEmptyCell()@text))
  expect_true(is.na(WebChartCalendarDatePartsBinning()@unit@value))
})

test_that("the WebChart subtypes inherit their parent's properties and methods", {
  box <- WebBoxPlot(version = "25.1.0", type = "chart", series = list())
  expect_true(S7::S7_inherits(box, WebChart))
  expect_true(is.na(box@showOutliers))

  heat <- WebHeatChart(version = "25.1.0", type = "chart", series = list())
  expect_true(is.na(heat@firstDayOfWeek))
  # The as_vector() method is registered on WebChart, so a subtype has to
  # pick it up by inheritance or unset properties stop being dropped.
  expect_named(s7x::as_vector(heat), c("version", "type", "title"))
})

test_that("the pie, gauge, and radar classes construct minimally", {
  expect_true(is.na(WebChartPieChartSeries(type = "pieSeries")@innerRadius))
  expect_null(WebChartPieChartSeries(type = "pieSeries")@ticks)
  expect_true(is.na(WebChartPieChartTick(type = "pieTick")@visible))
  expect_true(is.na(WebChartPieChartSlice()@label))
  expect_true(is.na(WebChartPieChartGroupSlice()@percentageThreshold))

  expect_true(is.na(WebChartGaugeSeries(type = "gaugeSeries")@featureIndex))
  expect_true(is.na(ValueConversion()@factor))
  expect_true(is.na(WebChartNeedle(type = "gaugeNeedle")@displayPin))
  expect_true(is.na(WebChartGaugeAxisTick(type = "gaugeAxisTick")@visible))
  expect_null(WebChartGaugeFixedProgressBands(type = "fixed")@bands)
  expect_null(WebChartGaugeFixedProgressBandsBands()@target)

  expect_true(is.na(
    WebChartRadarChartAxis(type = "chartAxis")@labelsOrientation@value
  ))
})

test_that("the pie legend and the three new subtypes inherit their parents", {
  # WebChartPieChartLegend extends WebChartLegend (web-chart.d.ts:143), so
  # WebChart$legend takes it without widening the union.
  legend <- WebChartPieChartLegend(
    type = "chartLegend",
    displayPercentage = TRUE
  )
  expect_true(S7::S7_inherits(legend, WebChartLegend))
  expect_true(WebChart(legend = legend)@legend@displayPercentage)

  gauge <- WebGaugeChart(version = "25.1.0", type = "chart", series = list())
  expect_true(S7::S7_inherits(gauge, WebChart))
  expect_true(is.na(gauge@subType@value))
  expect_named(s7x::as_vector(gauge), c("version", "type", "title"))

  radar <- WebRadarChart(version = "25.1.0", type = "chart", series = list())
  expect_true(S7::S7_inherits(radar, WebChart))
  expect_named(s7x::as_vector(radar), c("version", "type", "title"))

  # A gauge axis is a WebChartAxis, so set_axis()'s options apply to it.
  axis <- WebChartGaugeAxis(type = "chartAxis", minimum = 0, maximum = 100)
  expect_true(S7::S7_inherits(axis, WebChartAxis))
  expect_identical(axis@maximum, 100)
})
