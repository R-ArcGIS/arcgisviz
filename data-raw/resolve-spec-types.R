# Resolves named type definitions from the ArcGIS Charts JSON Schema
# (node_modules/@arcgis/charts-spec/dist/json-schema/index.json) into a
# normalized registry: enum variants, nullability, numeric bounds/defaults,
# object shape, array/tuple shape, union alternatives.
#
# Design:
# - $ref found inside `allOf` is resolved and merged in (that's how the
#   spec composes e.g. WebChartTextSymbol from Omit<ITextSymbol,...> + extra
#   properties) so the merged type is self-contained.
# - $ref found as a plain property value or inside `anyOf`/`oneOf` is left
#   as a reference (kind = "ref", ref = "<TypeName>") rather than inlined,
#   so the registry stays flat. Anything referenced this way that isn't
#   already one of `target_types` is collected into `dependencies.json` so
#   we can decide, deliberately, whether to pull each one in next.
#
# Output:
# - data-raw/spec-type-registry.json  (normalized shape per target type)
# - data-raw/spec-type-dependencies.json (referenced-but-unresolved type names)

library(jsonlite)

schema <- jsonlite::read_json(
  "node_modules/@arcgis/charts-spec/dist/json-schema/index.json"
)
defs <- schema$definitions

# Types referenced by data-raw/bar-chart-model.json that live in
# @arcgis/charts-spec (i.e. actually present in this schema file). Types
# from @arcgis/charts-shared-utils (ChartConfig, ChartTypes,
# SerialChartTypes, XYChartTypes, ChartSubType, SupportedChartSeries),
# types local to @arcgis/charts-model (LayerInfo, ModelParams,
# SerialChartDataSortingKinds, GuideOrientation), and Color (a plain TS
# tuple alias from charts-shared-utils, inlined at each use site rather
# than named in this schema) are out of scope here.
#
# This list also includes the chart-styling second-level dependencies
# discovered from the first resolver pass (WebChartAxis, WebChartText,
# WebChartLegend, etc.) plus their own cheap leaf dependencies
# (FieldType, DomainType, IFont). Deliberately excluded: FeatureLayer /
# FeatureCollection layer-definition types and raw geometry types — see
# `deferred_types` below.
target_types <- c(
  "WebChart",
  "WebChartBarChartSeries",
  "WebChartTextSymbol",
  "LegendItemVisibility",
  "SupportedLayer",
  "RESTStatisticType",
  "WebChartDataFilters",
  "WebChartStackedKinds",
  "CategoryFormatOptions",
  "DateTimeFormatOptions",
  "NumberFormatOptions",
  "WebChartAxisScrollBar",
  "ISimpleLineSymbol",
  "ISimpleFillSymbol",
  "WebChartLegendPositions",
  "WebChartTimeIntervalUnits",
  "WebChartTimeAggregationTypes",
  "WebChartNullPolicyTypes",
  "IField",
  "WebChartAxis",
  "WebChartText",
  "WebChartLegend",
  "WebChartPieChartLegend",
  "WebChartCursorCrosshair",
  "WebChartDataItem",
  "WebChartSeriesQuery",
  "WebChartSeriesType",
  "WebChartDateTimeUnitFormatOptions",
  "WebChartDirectionalDataOrder",
  "WebChartOrderSeriesBy",
  "WebChartPredefinedLabelsDataOrder",
  "Intl.DateTimeFormatOptions",
  "Intl.NumberFormatOptions",
  "FieldType",
  "DomainType",
  "IFont",
  "WebChartGuide",
  "IStatisticDefinition",
  "WebChartOrderDataByTypes",
  "WebChartSortOrderKinds",
  # scatter-plot-model.json additions
  "WebChartScatterPlotSeries",
  "ISimpleMarkerSymbol",
  "SizePolicy",
  "ScatterPlotOverlays",
  "WebChartOverlay"
)

# TODO: give these dedicated attention later. FeatureLayer/FeatureCollection
# layer-definition types are the most important part of the eventual R
# binding surface but are out of scope while we focus on the chart model
# itself. Geometry types are handled separately elsewhere already. The
# other WebChart*Series types only show up because WebChart.series /
# WebChartSeriesType is a union across every chart type the spec
# supports; they belong to their own future model files (line, pie,
# gauge, histogram, box plot, radar), not bar-chart-model or
# scatter-plot-model.
deferred_types <- c(
  # FeatureLayer / FeatureCollection definition types
  "IFeatureLayer",
  "__esri.FeatureLayer",
  "__esri.SubtypeSublayer",
  "ILayerDefinition",
  "IDefinitionEditor",
  "IPopupInfo",
  # geometry types (handled separately)
  "IPoint",
  "IPolygon",
  "IPolygonWithCurves",
  "IPolyline",
  "IEnvelope",
  "IExtent",
  # other chart types' series shapes, out of scope for bar-chart-model
  "WebChartBoxPlotSeries",
  "WebChartGaugeSeries",
  "WebChartHistogramSeries",
  "WebChartLineChartSeries",
  "WebChartPieChartSeries",
  "WebChartRadarChartSeries"
)

ref_name <- function(ref) sub("^#/definitions/", "", ref)

is_nullable <- function(type) {
  # jsonlite::read_json() uses simplifyVector = FALSE, so a JSON array
  # like `["null","number"]` parses as a list of length-1 strings rather
  # than an atomic character vector. unlist() first so the character/%in%
  # checks below actually see it as a vector instead of silently no-op'ing.
  type <- unlist(type)
  is.character(type) && length(type) > 1 && "null" %in% type
}

non_null_type <- function(type) {
  type <- unlist(type)
  if (is.character(type) && length(type) > 1) setdiff(type, "null") else type
}

resolve_property <- function(prop) {
  if (!is.null(prop[["$ref"]])) {
    return(list(
      kind = "ref",
      ref = ref_name(prop[["$ref"]]),
      description = prop$description
    ))
  }

  union_key <- if (!is.null(prop$anyOf)) {
    "anyOf"
  } else if (!is.null(prop$oneOf)) {
    "oneOf"
  } else {
    NULL
  }
  if (!is.null(union_key)) {
    alts <- lapply(prop[[union_key]], function(a) {
      if (!is.null(a[["$ref"]])) {
        list(kind = "ref", ref = ref_name(a[["$ref"]]))
      } else {
        resolve_property(a)
      }
    })
    return(list(
      kind = union_key,
      alternatives = alts,
      description = prop$description
    ))
  }

  if (!is.null(prop$enum)) {
    return(list(
      kind = "enum",
      values = prop$enum,
      nullable = is_nullable(prop$type),
      description = prop$description
    ))
  }

  if (!is.null(prop$const)) {
    return(list(
      kind = "const",
      value = prop$const,
      description = prop$description
    ))
  }

  type <- prop$type
  nnt <- non_null_type(type)

  if (!is.null(type) && "object" %in% nnt && !is.null(prop$properties)) {
    return(list(
      kind = "object",
      properties = lapply(prop$properties, resolve_property),
      required = prop$required,
      nullable = is_nullable(type),
      description = prop$description
    ))
  }

  # `{"type": "object"}` with no `properties` key: a legitimate, spec-level
  # open/untyped bag (e.g. WebChartDataItem), not an unrecognized shape.
  if (!is.null(type) && identical(nnt, "object") && is.null(prop$properties)) {
    return(list(
      kind = "open_object",
      nullable = is_nullable(type),
      description = prop$description
    ))
  }

  if (!is.null(type) && "array" %in% nnt) {
    items <- prop$items
    is_tuple <- !is.null(items) && is.null(names(items))
    if (is_tuple) {
      return(list(
        kind = "tuple",
        items = lapply(items, resolve_property),
        minItems = prop$minItems,
        maxItems = prop$maxItems,
        nullable = is_nullable(type),
        description = prop$description
      ))
    }
    return(list(
      kind = "array",
      items = if (!is.null(items)) resolve_property(items) else NULL,
      minItems = prop$minItems,
      maxItems = prop$maxItems,
      nullable = is_nullable(type),
      description = prop$description
    ))
  }

  if (!is.null(type) && any(c("number", "string", "boolean") %in% nnt)) {
    return(list(
      kind = "primitive",
      type = nnt,
      nullable = is_nullable(type),
      minimum = prop$minimum,
      maximum = prop$maximum,
      multipleOf = prop$multipleOf,
      default = prop$default,
      pattern = prop$pattern,
      format = prop$format,
      description = prop$description
    ))
  }

  list(kind = "unknown", raw = prop)
}

resolve_type <- function(name, defs) {
  def <- defs[[name]]
  if (is.null(def)) {
    return(list(kind = "not_found"))
  }

  if (!is.null(def$allOf)) {
    merged_props <- list()
    merged_required <- character(0)
    for (part in def$allOf) {
      part_resolved <- if (!is.null(part[["$ref"]])) {
        resolve_type(ref_name(part[["$ref"]]), defs)
      } else {
        resolve_property(part)
      }
      if (!is.null(part_resolved$properties)) {
        merged_props <- utils::modifyList(
          merged_props,
          part_resolved$properties
        )
      }
      if (!is.null(part_resolved$required)) {
        merged_required <- union(merged_required, part_resolved$required)
      }
    }
    return(list(
      kind = "object",
      title = name,
      properties = merged_props,
      required = if (length(merged_required)) merged_required else NULL,
      description = def$description
    ))
  }

  resolved <- resolve_property(def)
  resolved$title <- name
  resolved
}

# Walk a resolved type's structure and collect every `ref` name it points to.
collect_refs <- function(x, out = character(0)) {
  if (is.list(x)) {
    if (!is.null(x$kind) && identical(x$kind, "ref") && !is.null(x$ref)) {
      out <- c(out, x$ref)
    }
    for (el in x) {
      out <- collect_refs(el, out)
    }
  }
  out
}

registry <- setNames(
  lapply(target_types, resolve_type, defs = defs),
  target_types
)

all_refs <- unique(unlist(lapply(registry, collect_refs), use.names = FALSE))
dependencies <- sort(setdiff(all_refs, c(target_types, deferred_types)))
deferred_hits <- sort(intersect(all_refs, deferred_types))

write_json(
  registry,
  "data-raw/spec-type-registry.json",
  auto_unbox = TRUE,
  pretty = TRUE,
  null = "null"
)
write_json(
  dependencies,
  "data-raw/spec-type-dependencies.json",
  auto_unbox = TRUE,
  pretty = TRUE
)
write_json(
  deferred_hits,
  "data-raw/spec-type-deferred.json",
  auto_unbox = TRUE,
  pretty = TRUE
)

cat("Resolved", length(target_types), "target types.\n")
cat(
  "Found",
  length(dependencies),
  "unresolved referenced type names -> data-raw/spec-type-dependencies.json\n"
)
cat(
  "Hit",
  length(deferred_hits),
  "deliberately-deferred type names (FeatureLayer/geometry) -> data-raw/spec-type-deferred.json\n"
)
not_found <- names(Filter(function(r) identical(r$kind, "not_found"), registry))
if (length(not_found)) {
  cat("NOT FOUND in schema:", paste(not_found, collapse = ", "), "\n")
}
