# Package index

## Charts

Start a chart. Each shortcut is the equivalent pipeline of `set_*()`
calls, ready to pipe further.

- [`arc_chart()`](http://r.esri.com/arcgisviz/reference/arc_chart.md) :
  Start a chart
- [`arc_bar()`](http://r.esri.com/arcgisviz/reference/arc_bar.md) : Bar
  chart
- [`arc_col()`](http://r.esri.com/arcgisviz/reference/arc_col.md) :
  Column chart
- [`arc_scatter()`](http://r.esri.com/arcgisviz/reference/arc_scatter.md)
  : Scatterplot
- [`arc_line()`](http://r.esri.com/arcgisviz/reference/arc_line.md) :
  Line chart
- [`ArcChart()`](http://r.esri.com/arcgisviz/reference/ArcChart.md) : A
  chart specification

## Mapping

Bind columns and text to a chart.

- [`set_type()`](http://r.esri.com/arcgisviz/reference/set_type.md) :
  Set a chart's type
- [`set_x()`](http://r.esri.com/arcgisviz/reference/set_x.md)
  [`set_y()`](http://r.esri.com/arcgisviz/reference/set_x.md) : Map a
  column to a chart's x or y field
- [`set_stat()`](http://r.esri.com/arcgisviz/reference/set_stat.md) :
  Set a chart's statistical transformation
- [`set_color()`](http://r.esri.com/arcgisviz/reference/set_color.md) :
  Map a column to colour
- [`set_labs()`](http://r.esri.com/arcgisviz/reference/set_labs.md) :
  Set a chart's labels

## Scales and orientation

How the axes are scaled and which way the chart is drawn.

- [`set_axis()`](http://r.esri.com/arcgisviz/reference/set_axis.md) :
  Set an axis
- [`set_flipped()`](http://r.esri.com/arcgisviz/reference/set_flipped.md)
  : Swap a chart's axes

## Rendering

Turn a chart into an htmlwidget, in a document or in Shiny.

- [`as_widget()`](http://r.esri.com/arcgisviz/reference/as_widget.md) :
  Convert a chart to an htmlwidget
- [`as_chart_layer()`](http://r.esri.com/arcgisviz/reference/as_chart_layer.md)
  : Build a feature layer from a data frame
- [`arcgis_chart()`](http://r.esri.com/arcgisviz/reference/arcgis_chart.md)
  : Render an ArcGIS chart
- [`arcgisChartOutput()`](http://r.esri.com/arcgisviz/reference/arcgisChartOutput.md)
  [`renderArcgisChart()`](http://r.esri.com/arcgisviz/reference/arcgisChartOutput.md)
  : Shiny bindings for arcgis_chart

## Chart configuration

S7 classes mirroring the `WebChart` JSON the Maps SDK consumes. Built
for you by the functions above.

- [`WebChart()`](http://r.esri.com/arcgisviz/reference/WebChart.md) :
  WebChart
- [`WebChartAxis()`](http://r.esri.com/arcgisviz/reference/WebChartAxis.md)
  : WebChartAxis
- [`WebChartAxisScrollBar()`](http://r.esri.com/arcgisviz/reference/WebChartAxisScrollBar.md)
  : WebChartAxisScrollBar
- [`WebChartCursorCrosshair()`](http://r.esri.com/arcgisviz/reference/WebChartCursorCrosshair.md)
  : WebChartCursorCrosshair
- [`WebChartDataFilters()`](http://r.esri.com/arcgisviz/reference/WebChartDataFilters.md)
  : WebChartDataFilters
- [`WebChartGuide()`](http://r.esri.com/arcgisviz/reference/WebChartGuide.md)
  : WebChartGuide
- [`WebChartLegend()`](http://r.esri.com/arcgisviz/reference/WebChartLegend.md)
  : WebChartLegend
- [`WebChartNullCategory()`](http://r.esri.com/arcgisviz/reference/WebChartNullCategory.md)
  : WebChartNullCategory
- [`WebChartOverlay()`](http://r.esri.com/arcgisviz/reference/WebChartOverlay.md)
  : WebChartOverlay
- [`WebChartText()`](http://r.esri.com/arcgisviz/reference/WebChartText.md)
  : WebChartText
- [`WebChartTextSymbol()`](http://r.esri.com/arcgisviz/reference/WebChartTextSymbol.md)
  : WebChartTextSymbol

## Ordering

How a chart sorts its data and its series.

- [`WebChartOrderOptions()`](http://r.esri.com/arcgisviz/reference/WebChartOrderOptions.md)
  : WebChartOrderOptions
- [`WebChartDirectionalDataOrder()`](http://r.esri.com/arcgisviz/reference/WebChartDirectionalDataOrder.md)
  : WebChartDirectionalDataOrder
- [`WebChartMultiAxesDataOrder()`](http://r.esri.com/arcgisviz/reference/WebChartMultiAxesDataOrder.md)
  : WebChartMultiAxesDataOrder
- [`WebChartPredefinedLabelsDataOrder()`](http://r.esri.com/arcgisviz/reference/WebChartPredefinedLabelsDataOrder.md)
  : WebChartPredefinedLabelsDataOrder
- [`WebChartOrderSeriesBy()`](http://r.esri.com/arcgisviz/reference/WebChartOrderSeriesBy.md)
  : WebChartOrderSeriesBy

## Series

One class per chart type, plus the query that feeds it.

- [`WebChartBarChartSeries()`](http://r.esri.com/arcgisviz/reference/WebChartBarChartSeries.md)
  : WebChartBarChartSeries
- [`WebChartLineChartSeries()`](http://r.esri.com/arcgisviz/reference/WebChartLineChartSeries.md)
  : WebChartLineChartSeries
- [`WebChartScatterplotSeries()`](http://r.esri.com/arcgisviz/reference/WebChartScatterplotSeries.md)
  : WebChartScatterplotSeries
- [`WebChartSeriesQuery()`](http://r.esri.com/arcgisviz/reference/WebChartSeriesQuery.md)
  : WebChartSeriesQuery
- [`WebChartTemporalBinning()`](http://r.esri.com/arcgisviz/reference/WebChartTemporalBinning.md)
  : WebChartTemporalBinning
- [`WebChartTemporalBinningOffset()`](http://r.esri.com/arcgisviz/reference/WebChartTemporalBinningOffset.md)
  : WebChartTemporalBinningOffset
- [`ScatterplotOverlays()`](http://r.esri.com/arcgisviz/reference/ScatterplotOverlays.md)
  : ScatterplotOverlays
- [`SizePolicy()`](http://r.esri.com/arcgisviz/reference/SizePolicy.md)
  : SizePolicy

## Renderers

Data driven styling. A simple renderer carries visual variables for
continuous colour and a unique value renderer covers categories.

- [`ISimpleRenderer`](http://r.esri.com/arcgisviz/reference/ISimpleRenderer.md)
  : ISimpleRenderer
- [`IColorVisualVariable`](http://r.esri.com/arcgisviz/reference/IColorVisualVariable.md)
  : IColorVisualVariable
- [`IColorStop`](http://r.esri.com/arcgisviz/reference/IColorStop.md) :
  IColorStop
- [`IUniqueValueRenderer`](http://r.esri.com/arcgisviz/reference/IUniqueValueRenderer.md)
  : IUniqueValueRenderer
- [`IUniqueValueInfo`](http://r.esri.com/arcgisviz/reference/IUniqueValueInfo.md)
  : IUniqueValueInfo

## Symbols and colour

How individual marks are drawn.

- [`Color()`](http://r.esri.com/arcgisviz/reference/Color.md) : An RGBA
  colour
- [`ISimpleFillSymbol()`](http://r.esri.com/arcgisviz/reference/ISimpleFillSymbol.md)
  : ISimpleFillSymbol
- [`ISimpleLineSymbol()`](http://r.esri.com/arcgisviz/reference/ISimpleLineSymbol.md)
  : ISimpleLineSymbol
- [`ISimpleMarkerSymbol()`](http://r.esri.com/arcgisviz/reference/ISimpleMarkerSymbol.md)
  : ISimpleMarkerSymbol
- [`IFont()`](http://r.esri.com/arcgisviz/reference/IFont.md) : IFont

## Value formatting

How numbers, dates, and categories are rendered as text.

- [`NumberFormatOptions()`](http://r.esri.com/arcgisviz/reference/NumberFormatOptions.md)
  : NumberFormatOptions
- [`DateTimeFormatOptions()`](http://r.esri.com/arcgisviz/reference/DateTimeFormatOptions.md)
  : DateTimeFormatOptions
- [`CategoryFormatOptions()`](http://r.esri.com/arcgisviz/reference/CategoryFormatOptions.md)
  : CategoryFormatOptions
- [`WebChartDateTimeUnitFormatOptions()`](http://r.esri.com/arcgisviz/reference/WebChartDateTimeUnitFormatOptions.md)
  : WebChartDateTimeUnitFormatOptions
- [`IntlDateTimeFormatOptions()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatOptions.md)
  : IntlDateTimeFormatOptions
- [`IntlNumberFormatOptions()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptions.md)
  : IntlNumberFormatOptions
- [`TimeIntervalInfo()`](http://r.esri.com/arcgisviz/reference/TimeIntervalInfo.md)
  : TimeIntervalInfo

## Statistics

Server side aggregation applied before the chart is drawn.

- [`IStatisticDefinition()`](http://r.esri.com/arcgisviz/reference/IStatisticDefinition.md)
  : IStatisticDefinition
- [`IStatisticDefinitionStatisticParameters()`](http://r.esri.com/arcgisviz/reference/IStatisticDefinitionStatisticParameters.md)
  : IStatisticDefinitionStatisticParameters

## Enumerations

Scalar values drawn from a fixed set of variants. Each one validates a
single property of the classes above.

- [`ModelTypes()`](http://r.esri.com/arcgisviz/reference/ModelTypes.md)
  : ModelTypes
- [`RESTUnits()`](http://r.esri.com/arcgisviz/reference/RESTUnits.md) :
  RESTUnits
- [`IFontDecoration()`](http://r.esri.com/arcgisviz/reference/IFontDecoration.md)
  : IFontDecoration
- [`IFontStyle()`](http://r.esri.com/arcgisviz/reference/IFontStyle.md)
  : IFontStyle
- [`IFontWeight()`](http://r.esri.com/arcgisviz/reference/IFontWeight.md)
  : IFontWeight
- [`IRendererRotationType()`](http://r.esri.com/arcgisviz/reference/IRendererRotationType.md)
  : IRendererRotationType
- [`IStatisticDefinitionStatisticType()`](http://r.esri.com/arcgisviz/reference/IStatisticDefinitionStatisticType.md)
  : IStatisticDefinitionStatisticType
- [`IStatisticDefinitionStatisticParametersOrderBy()`](http://r.esri.com/arcgisviz/reference/IStatisticDefinitionStatisticParametersOrderBy.md)
  : IStatisticDefinitionStatisticParametersOrderBy
- [`SimpleFillSymbolStyle()`](http://r.esri.com/arcgisviz/reference/SimpleFillSymbolStyle.md)
  : SimpleFillSymbolStyle
- [`SimpleLineSymbolStyle()`](http://r.esri.com/arcgisviz/reference/SimpleLineSymbolStyle.md)
  : SimpleLineSymbolStyle
- [`SimpleMarkerSymbolStyle()`](http://r.esri.com/arcgisviz/reference/SimpleMarkerSymbolStyle.md)
  : SimpleMarkerSymbolStyle
- [`SizePolicyScaleTypes()`](http://r.esri.com/arcgisviz/reference/SizePolicyScaleTypes.md)
  : SizePolicyScaleTypes
- [`WebChartDirectionalDataOrderOrderType()`](http://r.esri.com/arcgisviz/reference/WebChartDirectionalDataOrderOrderType.md)
  : WebChartDirectionalDataOrderOrderType
- [`WebChartLabelBehavior()`](http://r.esri.com/arcgisviz/reference/WebChartLabelBehavior.md)
  : WebChartLabelBehavior
- [`WebChartLegendPositions()`](http://r.esri.com/arcgisviz/reference/WebChartLegendPositions.md)
  : WebChartLegendPositions
- [`WebChartNullPolicyTypes()`](http://r.esri.com/arcgisviz/reference/WebChartNullPolicyTypes.md)
  : WebChartNullPolicyTypes
- [`WebChartQuerySpatialRelationship()`](http://r.esri.com/arcgisviz/reference/WebChartQuerySpatialRelationship.md)
  : WebChartQuerySpatialRelationship
- [`WebChartSortOrderKinds()`](http://r.esri.com/arcgisviz/reference/WebChartSortOrderKinds.md)
  : WebChartSortOrderKinds
- [`WebChartStackedKinds()`](http://r.esri.com/arcgisviz/reference/WebChartStackedKinds.md)
  : WebChartStackedKinds
- [`WebChartTemporalBinningUnits()`](http://r.esri.com/arcgisviz/reference/WebChartTemporalBinningUnits.md)
  : WebChartTemporalBinningUnits
- [`WebChartTextSymbolHorizontalAlignment()`](http://r.esri.com/arcgisviz/reference/WebChartTextSymbolHorizontalAlignment.md)
  : WebChartTextSymbolHorizontalAlignment
- [`WebChartTextSymbolVerticalAlignment()`](http://r.esri.com/arcgisviz/reference/WebChartTextSymbolVerticalAlignment.md)
  : WebChartTextSymbolVerticalAlignment
- [`WebChartTimeAggregationTypes()`](http://r.esri.com/arcgisviz/reference/WebChartTimeAggregationTypes.md)
  : WebChartTimeAggregationTypes
- [`IntlDateTimeDigitStyle()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeDigitStyle.md)
  : IntlDateTimeDigitStyle
- [`IntlDateTimeFormatLength()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatLength.md)
  : IntlDateTimeFormatLength
- [`IntlFormatWidth()`](http://r.esri.com/arcgisviz/reference/IntlFormatWidth.md)
  : IntlFormatWidth
- [`IntlLocaleMatcher()`](http://r.esri.com/arcgisviz/reference/IntlLocaleMatcher.md)
  : IntlLocaleMatcher
- [`IntlDateTimeFormatOptionsFormatMatcher()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatOptionsFormatMatcher.md)
  : IntlDateTimeFormatOptionsFormatMatcher
- [`IntlDateTimeFormatOptionsHourCycle()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatOptionsHourCycle.md)
  : IntlDateTimeFormatOptionsHourCycle
- [`IntlDateTimeFormatOptionsMonth()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatOptionsMonth.md)
  : IntlDateTimeFormatOptionsMonth
- [`IntlDateTimeFormatOptionsTimeZoneName()`](http://r.esri.com/arcgisviz/reference/IntlDateTimeFormatOptionsTimeZoneName.md)
  : IntlDateTimeFormatOptionsTimeZoneName
- [`IntlNumberFormatOptionsCompactDisplay()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsCompactDisplay.md)
  : IntlNumberFormatOptionsCompactDisplay
- [`IntlNumberFormatOptionsCurrencyDisplay()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsCurrencyDisplay.md)
  : IntlNumberFormatOptionsCurrencyDisplay
- [`IntlNumberFormatOptionsCurrencySign()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsCurrencySign.md)
  : IntlNumberFormatOptionsCurrencySign
- [`IntlNumberFormatOptionsNotation()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsNotation.md)
  : IntlNumberFormatOptionsNotation
- [`IntlNumberFormatOptionsSignDisplay()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsSignDisplay.md)
  : IntlNumberFormatOptionsSignDisplay
- [`IntlNumberFormatOptionsStyle()`](http://r.esri.com/arcgisviz/reference/IntlNumberFormatOptionsStyle.md)
  : IntlNumberFormatOptionsStyle
