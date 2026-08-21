---
name: arcgis-spec-types
description: Use when adding a new ArcGIS chart type (e.g. box plot, pie, gauge, histogram, radar, heat) to this package, or when building/reviewing the S7 classes and enums in R/ that back the WebChart config shape. Covers reading @arcgis/charts-components' bundled .d.ts spec directly and the S7/s7x conventions for turning it into R/ classes.
---

# ArcGIS chart spec -> S7 types

This package builds S7 classes in R that exactly mirror the JSON config
shape (`WebChart` + a series type) that `@arcgis/charts-components`
consumes. Types are hand-written directly against that package's bundled
`.d.ts` spec files. A JSON Schema does ship in the dist
(`dist/chunks/index4.js:14`) but carries no detail the declarations lack, and
there is no mechanical resolver anymore.

**Do not use `@arcgis/charts-model`/`@arcgis/charts-spec`** as a source, and
don't try to reinstall them. They're on an independent, stalled npm version
line (`4.32.15`, confirmed latest, no newer release) that has diverged from
what `@arcgis/charts-components` (tracking the current SDK version) actually
ships - real, confirmed divergence includes `WebChart$subTitle` renamed to
`subtitle`, `WebChartScatterPlotSeries` renamed to `WebChartScatterplotSeries`,
and series-level temporal binning fields restructured into a nested
`temporalBinning` object. Both packages were removed from this project's
`package.json`/`node_modules` for this reason. `data-raw/resolve-spec-types.R`,
`data-raw/spec-type-registry.json`, and the `data-raw/<model>.json`
imperative-API docs are **stale/archival** - don't regenerate from them, don't
diff against them.

## Renderers are the exception - they are not in this spec

`IDrawingInfo$renderer` is `any` here, so **the renderer classes
(`R/types-renderer.R`) come from the web map specification instead**, and
where that spec and `@arcgis/core` disagree the spec wins. They do disagree:
`legendOptions` is one shared 7-property object in the spec, but two split
classes in core. Everything about typing those - `class_any` vs a real
class, pruning by renderer family, discriminator defaults, and the
`new_*()` constructor family in `R/constructors.R` - is written up under
"Typing a property" in `CLAUDE.md`. Read that before touching
`R/types-renderer.R`, `R/types-simple.R`, or `R/constructors.R`; the
`arcgis-map-widget` skill has the map-side context.

## Where the types actually live

All inside `node_modules/@arcgis/charts-components/dist/spec/`:

- **`web-chart.d.ts`** - the whole `WebChart` config shape in one file: every
  `WebChart*` interface, every chart type's series interface
  (`WebChartBarChartSeries`, `WebChartScatterplotSeries`,
  `WebChartLineChartSeries`, `WebChartBoxPlotSeries`, `WebChartPieChartSeries`,
  `WebChartGaugeSeries`, `WebChartHistogramSeries`, `WebChartHeatChartSeries`,
  `WebChartRadarChartSeries`), axis/legend/guide/query types, and each
  chart-type's own `WebChart` subtype (`WebGaugeChart`, `WebBoxPlot`,
  `WebRadarChart`, `WebHeatChart`). Start here for any new chart type.
- **`chart-object-literals.d.ts`** - `WebChart*`-prefixed enums, as
  `export const Foo = {...} as const` + a derived `export type Foo = ...`.
  Some exported consts here are never actually referenced as a property type
  anywhere in `web-chart.d.ts` (e.g. `WebChartOrderDataByTypes`) - check
  before modeling one; dead exports aren't worth adding.
- **`rest-js-types.d.ts`** - `Color` (`[number,number,number,number]` tuple),
  `IFont`, `ISimpleFillSymbol`/`ISimpleLineSymbol`/`ISimpleMarkerSymbol`/
  `ITextSymbol`, `IStatisticDefinition`, and the non-`REST`-prefixed style
  enums (`SimpleLineSymbolStyle` etc.) that those symbol types actually use.
- **`rest-js-object-literals.d.ts`** - `RESTUnits` and `REST`-prefixed
  duplicates of the style enums above (same values, but not what
  `web-chart.d.ts` actually imports/references - skip these unless you find
  a real reference).
- **`data-source.d.ts`** - `TimeIntervalInfo`, `RGBObject` and friends.

Inline anonymous types (an object or literal-union with no exported name,
e.g. `WebChartTemporalBinning$offset: { unit: ...; size: number }`, or
`IStatisticDefinition$statisticParameters`) get hoisted into a named R class
using a `ParentType` + `propertyPath` PascalCase name, same convention as
before (e.g. `WebChartTemporalBinningOffset`,
`IStatisticDefinitionStatisticParameters`).

## Workflow for a new chart type

1. Read the chart type's series interface(s) and its `WebChart` subtype (if
   any) in `web-chart.d.ts` in full.
2. Trace every referenced type back to its source file above; check whether
   it's already modeled in `R/` before adding a duplicate.
3. Write/extend the `s7x::new_enum()` calls first (grouped by file - see
   below), then the S7 classes in dependency order (a class can only
   reference an already-defined class/enum/`Color`).
4. Add the deferred types this project doesn't model to the same
   `class_any`/skip treatment already established: live-layer types
   (`IFeatureLayer`/`IImageServiceLayer`/etc. - `WebChart$iLayer` stays
   `class_any`) and geometry types (`IPoint`/`IPolygon`/etc.).
5. A new `R/` file needs an `#' @include <predecessor>.R` / `NULL` block at
   the top. `Collate:` is generated by roxygen's `collate` roclet from those
   tags alone, so a file without one sorts alphabetically and breaks
   `load_all()`. The files form one linear chain, `color.R` first.
6. `just document`, `just fmt`, `just lint`, `just test`.

## Property-type mapping (TS interface -> S7 property)

- `string`/`number`/`boolean` -> `s7x::class_string`/`class_double`/
  `class_boolean`.
- A named or inline literal-union type (`"a" | "b" | "c"`, or a const object
  exported from `chart-object-literals.d.ts`/`rest-js-types.d.ts`) -> the
  matching `s7x::new_enum()`-built class.
- `Color` (the 4-number tuple) -> the `Color` class (`R/color.R`), **not** a
  raw 4-element vector - see below.
- A reference to another interface -> that class.
- A TS union of object/class types (`A | B`) -> `s7x::property_union(A, B)`.
- A numeric literal union used as a value range (e.g.
  `fractionalSecondDigits?: 1 | 2 | 3`) -> `s7x::property_range_discrete(min, max)`,
  **not** an enum (`Enum` values are scalar character).
- An array with no need for per-element type enforcement -> `S7::class_character`
  (string array) or `S7::class_list` (array of objects/mixed).
- A generic/untyped bag (`Record<string, ...>`, e.g. `WebChartDataItem`) or a
  deliberately deferred type (`WebChart$iLayer`, geometry) -> `S7::class_any`.
- `WebChart$chartRenderer` is typed (`R/types-renderer.R`) even though the
  spec calls it `any`. Its classes come from the **web map** specification,
  not the charts spec and not the web scene spec. See CLAUDE.md's colour
  section before touching them.
- **Optionality** (TS `?`): a property NOT marked `?` stays strictly typed
  with no union. A `?`-marked scalar/enum property needs **no wrapping** -
  `NA` (`NA_character_`/`NA_real_`/`NA`) already satisfies `class_string`/
  `class_double`/`class_boolean`/`Enum`, including when the property is
  simply *omitted* from a constructor call (verified in
  `tests/testthat/test-type-defaults.R`; this used to silently break on
  omission until a round of `s7x` default-value fixes - see CLAUDE.md). A
  `?`-marked object-typed property needs
  `s7x::property_union(Type, NULL, default = NULL)` - that literal `NULL` is
  correctly respected on omission now too.

`Color` (`R/color.R`) is a deliberate one-off exception: the spec's raw
`[r,g,b,a]` tuple becomes an `r`/`g`/`b`/`a` (`class_double` each) S7 class,
not a length-4 vector, per explicit instruction - don't "fix" this to match
the raw tuple shape.

## Verifying property names match exactly

After writing/editing any S7 class, open the corresponding `.d.ts` interface
side by side and diff by hand:

```r
library(S7); library(s7x)
devtools::load_all(quiet = TRUE)
names(SomeClass@properties)
```

Compare that list against the interface's own property names (including
inherited/mixed-in ones - `WebChartSeries`, `WebChartTemporalSeries`, etc.
are flattened into each concrete series class, not modeled as separate
parent classes). This has caught real naming/shape drift before (the
`subTitle`/`subtitle` rename, the temporal-binning restructuring) - always
check, don't skip it because "it looks right."

## Enum file grouping

Same grouping as before: `R/enums-web-chart.R` (`WebChart*`-prefixed),
`R/enums-intl-date-time.R` (`Intl.DateTimeFormatOptions`/
`Intl.NumberFormatOptions` fields - native TS lib types, untouched by the
`@arcgis/charts-components` migration), `R/enums-others.R` (everything else -
`REST`/`Simple*SymbolStyle`/`IFont*`/`IStatisticDefinition*`). One
`new_enum("Name", c(...))` call per enum, `#' @export` above each (bare
`#' @export` works for `<-`-assigned enums - see the `:=` caveat below for
why classes need more).

## S7 class definition style

Use the `Foo := new_class(properties = list(...))` form (no explicit name
string as the first positional arg - `:=` infers it from the assignment
target; passing a name string there gets bound to `new_class()`'s `parent`
argument instead and errors confusingly). `library(S7)` at the top of each
file that uses `:=`. `s7x::` functions are always fully-qualified (no
`library(s7x)` in package R files) since `s7x` isn't formally wired into
`Imports`/`NAMESPACE` via roxygen yet.

**Exporting `:=`-defined classes**: roxygen2's static parser doesn't
recognize `:=` as an assignment, so a bare `#' @export` above `Foo :=
new_class(...)` is silently dropped - no NAMESPACE entry, no error. Always
pair it with an explicit `#' @name Foo` and at least a one-line title:

```r
#' Foo
#' @name Foo
#' @export
Foo := new_class(properties = list(...))
```

Run `just document` (wraps `devtools::document()`) after adding classes,
and run it twice if you add a new `[Foo()]`-style link between doc blocks
- the first pass can report a stale "could not resolve link to topic"
warning for a topic documented in that same run; it clears once the Rd
file lands on disk on the second pass.

## File load order

`R/` files have real cross-file dependencies (a type file references
classes/enums from another file). This is declared explicitly via
`Collate:` in `DESCRIPTION` - `devtools::load_all()` and `R CMD build`
both respect it. **Any new `R/` file with cross-file dependencies must be
added to `Collate:` in the correct position**, or `load_all()` will fail
with "object not found" for whatever it references from a
later-sorted-alphabetically file.

## Running R scripts

One-off inspection/verification snippets (checking a class's properties,
test-constructing an object, the property-name diff above) are fine
directly via `R -q -e`. If a task genuinely needs a real, reviewable,
re-runnable script (not the case for the current hand-written-from-.d.ts
workflow, but true of anything under `data-raw/` historically), it's a real
file run with `R -q -f data-raw/whatever.R` - not an inline one-liner.
