# Enums for ArcGIS Charts spec types with no shared WebChart*/Intl* name
# prefix. Generated from data-raw/enums.json (see
# data-raw/resolve-spec-types.R and data-raw/extract-enums.R for
# provenance).

#' @export
RESTStatisticType <- s7x::new_enum(
  "RESTStatisticType",
  c(
    "avg",
    "centroid-aggregate",
    "convex-hull-aggregate",
    "count",
    "envelope-aggregate",
    "max",
    "min",
    "no_aggregation",
    "percentile_cont",
    "percentile_disc",
    "stddev",
    "sum",
    "var"
  )
)

#' @export
FieldType <- s7x::new_enum(
  "FieldType",
  c(
    "esriFieldTypeBlob",
    "esriFieldTypeDate",
    "esriFieldTypeDouble",
    "esriFieldTypeGUID",
    "esriFieldTypeGeometry",
    "esriFieldTypeGlobalID",
    "esriFieldTypeInteger",
    "esriFieldTypeOID",
    "esriFieldTypeRaster",
    "esriFieldTypeSingle",
    "esriFieldTypeSmallInteger",
    "esriFieldTypeString",
    "esriFieldTypeXML"
  )
)

#' @export
DomainType <- s7x::new_enum(
  "DomainType",
  c("codedValue", "inherited", "range")
)

#' @export
LegendItemVisibilityOverlayType <- s7x::new_enum(
  "LegendItemVisibilityOverlayType",
  c("Mean", "Median", "Normal Distribution", "Standard Deviation", "Trendline")
)

#' @export
ISimpleLineSymbolStyle <- s7x::new_enum(
  "ISimpleLineSymbolStyle",
  c(
    "esriSLSDash",
    "esriSLSDashDot",
    "esriSLSDashDotDot",
    "esriSLSDot",
    "esriSLSNull",
    "esriSLSSolid"
  )
)

#' @export
ISimpleFillSymbolStyle <- s7x::new_enum(
  "ISimpleFillSymbolStyle",
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

#' @export
ISimpleMarkerSymbolStyle <- s7x::new_enum(
  "ISimpleMarkerSymbolStyle",
  c(
    "esriSMSCircle",
    "esriSMSCross",
    "esriSMSDiamond",
    "esriSMSSquare",
    "esriSMSTriangle",
    "esriSMSX"
  )
)

#' @export
SizePolicyScaleType <- s7x::new_enum(
  "SizePolicyScaleType",
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
    "percentile_cont",
    "percentile_disc",
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
