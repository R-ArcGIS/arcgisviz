# Enums for ArcGIS Charts spec types with no shared WebChart*/Intl* name
# prefix. Source of truth is the spec bundled inside @arcgis/charts-components
# (not the standalone, stale @arcgis/charts-model/@arcgis/charts-spec
# packages - see CLAUDE.md):
# node_modules/@arcgis/charts-components/dist/spec/rest-js-types.d.ts,
# .../dist/spec/rest-js-object-literals.d.ts.
#
# Dropped from the old (charts-spec) version of this file because nothing in
# the current WebChart config type tree references them: RESTStatisticType
# (IStatisticDefinition.statisticType actually uses its own, differently
# scoped inline union - see IStatisticDefinitionStatisticType below),
# FieldType, DomainType (IField/domain modeling isn't referenced by
# WebChart), LegendItemVisibilityOverlayType (that's part of the
# <arcgis-chart> *event payload* spec - events.d.ts's OverlayTerms - not
# the WebChart config shape at all).

# Renamed from WebChartDataFiltersUnits (an invented name for a previously
# anonymous inline type) - the current spec exports this directly as
# RESTUnits (rest-js-object-literals.d.ts), used by WebChartQuery.units and
# therefore WebChartDataFilters.units. @deprecated since 5.1 in the spec
# itself but still the current property type, so still modeled.
#' @export
RESTUnits <- s7x::new_enum(
  "RESTUnits",
  c(
    "feet",
    "kilometers",
    "meters",
    "miles",
    "nautical-miles",
    "us-nautical-miles"
  )
)

# Renamed from ISimpleLineSymbolStyle - rest-js-types.d.ts exports this
# without an `I`-prefix (`SimpleLineSymbolStyle`); that's the literal type
# of ISimpleLineSymbol$style itself.
#' @export
SimpleLineSymbolStyle <- s7x::new_enum(
  "SimpleLineSymbolStyle",
  c(
    "esriSLSDash",
    "esriSLSDashDot",
    "esriSLSDashDotDot",
    "esriSLSDot",
    "esriSLSNull",
    "esriSLSSolid"
  )
)

# Renamed from ISimpleFillSymbolStyle - see SimpleLineSymbolStyle above.
#' @export
SimpleFillSymbolStyle <- s7x::new_enum(
  "SimpleFillSymbolStyle",
  c(
    "esriSFSBackwardDiagonal",
    "esriSFSCross",
    "esriSFSDiagonalCross",
    "esriSFSForwardDiagonal",
    "esriSFSHorizontal",
    "esriSFSNull",
    "esriSFSSolid",
    "esriSFSVertical"
  )
)

# Renamed from ISimpleMarkerSymbolStyle - see SimpleLineSymbolStyle above.
#' @export
SimpleMarkerSymbolStyle <- s7x::new_enum(
  "SimpleMarkerSymbolStyle",
  c(
    "esriSMSCircle",
    "esriSMSCross",
    "esriSMSDiamond",
    "esriSMSSquare",
    "esriSMSTriangle",
    "esriSMSX"
  )
)

# Renamed from SizePolicyScaleType (singular) - chart-object-literals.d.ts
# exports the plural SizePolicyScaleTypes.
#' @export
SizePolicyScaleTypes <- s7x::new_enum(
  "SizePolicyScaleTypes",
  c("linear", "logarithmic")
)

#' @export
IFontStyle <- s7x::new_enum(
  "IFontStyle",
  c("italic", "normal", "oblique")
)

#' @export
IFontWeight <- s7x::new_enum(
  "IFontWeight",
  c("bold", "bolder", "lighter", "normal")
)

#' @export
IFontDecoration <- s7x::new_enum(
  "IFontDecoration",
  c("line-through", "none", "underline")
)

# NOTE: values changed from the old charts-spec version - the current
# rest-js-types.d.ts inline union spells these "percentile-continuous"/
# "percentile-discrete" (hyphenated words), not "percentile_cont"/
# "percentile_disc". Also this is NOT the same set as chart-object-literals'
# WebChartStatisticType (13 values incl. "no_aggregation") - that exported
# const isn't what IStatisticDefinition$statisticType actually uses.
#' @export
IStatisticDefinitionStatisticType <- s7x::new_enum(
  "IStatisticDefinitionStatisticType",
  c(
    "avg",
    "centroid-aggregate",
    "convex-hull-aggregate",
    "count",
    "envelope-aggregate",
    "max",
    "min",
    "percentile-continuous",
    "percentile-discrete",
    "stddev",
    "sum",
    "var"
  )
)

# NOTE: distinct from WebChartSortOrderKinds ("ASC"/"DESC") - this one is
# lowercase in the spec, so it's a different set of literal string values,
# not a duplicate.
#' @export
IStatisticDefinitionStatisticParametersOrderBy <- s7x::new_enum(
  "IStatisticDefinitionStatisticParametersOrderBy",
  c("asc", "desc")
)
