# arcgisviz

An R package binding to the ArcGIS Maps SDK Charts capabilities
(`@arcgis/charts-components`). Two halves: an S7 type layer in R that
mirrors the JS chart config JSON shape, and an htmlwidget that renders
`<arcgis-chart>` in the browser from that config plus a data source.

**Source of truth for types is `@arcgis/charts-components`'s own bundled
spec**, not a separate package. `@arcgis/charts-model`/`@arcgis/charts-spec`
(the packages this project originally generated types from) are on an
independent, stalled version line (`4.32.15`, the latest published, with no
newer release) that has diverged from what `@arcgis/charts-components`
(tracking SDK `5.1.x`) actually ships and runs - confirmed by real
divergence (`subTitle` renamed to `subtitle`, `WebChartScatterPlotSeries`
renamed to `WebChartScatterplotSeries`, temporal binning restructured, etc).
Both packages were removed from `package.json`/`node_modules` for this
reason. Read types from:
- `node_modules/@arcgis/charts-components/dist/spec/web-chart.d.ts` - the
  WebChart config shape (all `WebChart*`/series/axis/query interfaces, one
  file).
- `.../dist/spec/chart-object-literals.d.ts` - `WebChart*` enums (as const
  objects + derived types).
- `.../dist/spec/rest-js-types.d.ts` - `Color`, `IFont`, `ISimpleFillSymbol`/
  `ISimpleLineSymbol`/`ISimpleMarkerSymbol`/`ITextSymbol`,
  `IStatisticDefinition`.
- `.../dist/spec/rest-js-object-literals.d.ts` - `RESTUnits` and REST-prefixed
  symbol-style consts (mostly unused directly - the non-REST-prefixed
  versions in rest-js-types.d.ts are what properties actually reference).
- `.../dist/spec/data-source.d.ts` - `TimeIntervalInfo`, `RGBObject`.

There is **no JSON Schema anymore** - `@arcgis/charts-components` only ships
`.d.ts` declarations, no runtime-extractable schema object (checked; not
worth re-deriving one). `data-raw/resolve-spec-types.R` and
`data-raw/spec-type-registry.json` (the old JSON-Schema-driven pipeline) are
**stale/archival** - don't treat them as current, and don't mechanically
regenerate `R/types-*.R`/`R/enums-*.R` from them. Types are now hand-written
directly against the `.d.ts` files above, same as the imperative-API
`data-raw/<model>.json` docs always were (those are separately stale too -
they came from the removed `@arcgis/charts-model` package's method-level
`.d.ts` files, describing the `createModel()`/JS-wiring path, which is not
current work - see `arcgis-js-widget` skill).

## Commands

Use `just` (see `justfile`), not raw `Rscript`/`bun` calls:

```sh
just fmt          # air format R/ + tests/
just lint         # jarl check + air format --check
just test         # devtools::test()
just js-install   # bun install
just bundle-dev   # rebuild the JS widget bundle (dev, unminified)
just bundle       # rebuild the JS widget bundle (production, minified)
just watch        # rebuild JS on every srcjs/ change
```

## Two skills, load them for the relevant work

- **`arcgis-spec-types`** - hand-writing `s7x`-based S7 classes in `R/`
  directly from `@arcgis/charts-components`'s bundled `.d.ts` spec (see
  above - no JSON Schema, no mechanical resolver anymore). Load this before
  adding a new chart type or touching any `R/types-*.R` / `R/enums-*.R` /
  `R/color.R` file.
- **`arcgis-js-widget`** - the htmlwidget: `srcjs/`, webpack config,
  `R/arcgis-chart-widget.R`, the `createModel`/`<arcgis-chart>` contract.
  Load this before touching anything JS-side or the R widget wrapper.

Both skills point to more detail: `dev-docs/js-widget-architecture.md` for the
full JS/data-flow writeup.

## Current state, in one paragraph

Bar chart, scatterplot, and line chart (incl. combo bar-line, which needs
zero new code since `WebChart$series` is an untyped `class_list`) have
complete S7 type stacks (config classes + enums), rebuilt against
`@arcgis/charts-components`'s bundled spec (see above) and verified to
construct end-to-end with realistic, minimally-specified data (see
`tests/testthat/test-type-defaults.R`). The htmlwidget (`arcgis_chart()`)
is unverified/known-broken right now (`srcjs/widgets/arcgisChart.js`) and
not current work. Box plot, pie, gauge, histogram, and radar chart types
are not yet modeled.

## Serialization

`s7x::to_json(x, ..., pretty = FALSE)` works out of the box for any S7 config
class in this package (`WebChart`, `WebChartBarChartSeries`, etc.) - it's a
generic `S7_object` method in `s7x` (`as_vector(x)` +
`yyjsonr::write_json_str(auto_unbox = TRUE, ...)`), not something
`arcgisviz` implements itself. No extra code needed here; regression
coverage lives in `s7x`, not this package's test suite. `from_json()` (JSON
-> S7 object) doesn't exist yet - harder problem, needs to know which class
to construct into.

## Deliberately deferred (don't "fix" these without asking)

- **Live FeatureLayer / non-featureCollection layer types.** `WebChart$iLayer`
  is `IFeatureLayer | IImageServiceLayer | ITiledImageServiceLayer | IWCSLayer`
  in the spec but stays `class_any` here - charts are built from a
  `type: "featureCollection"` JSON blob via `arcgisutils::as_layer()`, not a
  live layer reference. Don't model the live-layer types.
- **Geometry types** (`IPoint`/`IPolygon`/etc.) - handled elsewhere, not
  modeled in this package's type registry. `WebChartDataFilters$geometry`
  stays `class_any`.
- **Other chart types' series shapes** (pie, gauge, histogram, box plot,
  radar, heat) - `web-chart.d.ts` has all of these in one file now (no
  per-chart-type `.d.ts` sprawl to resolve), so adding one is just reading
  the relevant interface(s) there and following the `arcgis-spec-types`
  skill's conventions - not fundamentally blocked on anything, just not
  done yet.

## Conventions worth knowing before editing `R/`

- S7 classes: `Foo := new_class(properties = list(...))` - no name string
  as the first arg (breaks `:=`'s inference, silently binds to `parent`
  instead and errors). `s7x::` is always fully-qualified in package code.
- Optional properties: `NA` already satisfies `s7x::class_string`/
  `class_double`/`class_boolean`/`Enum` (has `allow_na = TRUE`) - no
  wrapping needed, **including when the property is simply omitted from a
  constructor call** (verified by `tests/testthat/test-type-defaults.R`;
  this used to be false and broke on omission until a round of `s7x` fixes
  to `new_enum()`/`property_scalar()`/`property_range()`/`property_union()`
  default-value handling). Only optional *object-typed* properties need
  `s7x::property_union(Type, NULL, default = NULL)` - and that literal
  `NULL` really is respected on omission now (`property_union()` used to
  conflate "no `default` arg supplied" with "`default = NULL` supplied
  explicitly" and would deep-default into `Type` instead; fixed).
- `Color` (`R/color.R`) is `r`/`g`/`b`/`a` (four `class_double`), not the
  raw `[r,g,b,a]` tuple the spec uses - a deliberate exception, keep it.
- `DESCRIPTION`'s `Collate:` field is load-bearing - `R/` files have real
  cross-file dependencies. Add new files to it in dependency order or
  `load_all()` breaks with "object not found".
- After writing/editing any S7 class, diff its property names against the
  relevant `@arcgis/charts-components` `.d.ts` interface by hand (see
  "Source of truth" above) - `data-raw/spec-type-registry.json` is stale,
  don't diff against it anymore.
- roxygen2 doesn't recognize `:=` as an assignment operator, so a bare
  `#' @export` above `Foo := new_class(...)` is silently dropped - no
  NAMESPACE entry, no Rd file, no error. Every `:=`-defined class needs an
  explicit `#' @name Foo` (with at least a one-line title) alongside
  `@export` or it never gets exported. Run `just document` twice when
  adding new cross-references between doc blocks (`[Foo()]` links) - the
  first `devtools::document()` pass can report a stale "could not resolve
  link" warning for a topic documented in the same run; it clears on the
  second pass once the new Rd file is on disk.

## Standing rule from global config

Never write/run ad-hoc inline scripts (`python -c`, `node -e`, etc.) for
file operations or data manipulation, even read-only checks - this
project has been burned by that before. Data-generating R scripts live
under `data-raw/` as real files, reviewed, then run with
`R -q -f data-raw/whatever.R`. One-off `R -q -e` inspection/verification
snippets are fine.
