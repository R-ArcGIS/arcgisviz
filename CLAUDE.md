# arcgisviz

An R package binding to the ArcGIS Maps SDK Charts capabilities
(`@arcgis/charts-model`, `@arcgis/charts-spec`, `@arcgis/charts-components`).
Two halves: an S7 type layer in R that mirrors the JS chart config JSON
shape, and an htmlwidget that renders `<arcgis-chart>` in the browser from
that config plus a data source.

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

- **`arcgis-spec-types`** - the full `data-raw/` pipeline: turning
  `@arcgis/charts-model`'s `.d.ts` files and `@arcgis/charts-spec`'s JSON
  Schema into `data-raw/<model>.json`, `spec-type-registry.json`,
  `enums.json`, and finally the `s7x`-based S7 classes in `R/`. Load this
  before adding a new chart model or touching any `R/types-*.R` /
  `R/enums-*.R` / `R/color.R` file.
- **`arcgis-js-widget`** - the htmlwidget: `srcjs/`, webpack config,
  `R/arcgis-chart-widget.R`, the `createModel`/`<arcgis-chart>` contract.
  Load this before touching anything JS-side or the R widget wrapper.

Both skills point to more detail: `docs/js-widget-architecture.md` for the
full JS/data-flow writeup.

## Current state, in one paragraph

Bar chart (`BarChartModel`) and scatter plot (`ScatterPlotModel`) both
have complete, schema-verified S7 type stacks (config classes + enums) and
documented imperative-API JSON files. The htmlwidget (`arcgis_chart()`)
renders a chart client-side from an `iLayer` feature-collection JSON (via
`arcgisutils::as_layer()`) + `chart_type` + `x_field`/`y_field` - verified
to build and produce correct HTML output, but **not yet visually confirmed
in a real browser** (no browser automation available in this environment).

## Deliberately deferred (don't "fix" these without asking)

- **Serialization.** No `to_json()`/`from_json()` yet for the S7 config
  classes (`WebChart`, `WebChartBarChartSeries`, etc.). Planned:
  `s7x` generics backed by `yyjsonr`. Until then the widget only sets
  `xField`/`yField` via the model's documented setters, not a full config.
- **FeatureLayer/FeatureCollection beyond the simple case.** `IFeatureLayer`,
  `__esri.FeatureLayer`, `ILayerDefinition`, and friends are excluded from
  the type registry (`data-raw/resolve-spec-types.R` `deferred_types`) -
  these get dedicated treatment later. Only `arcgisutils::as_layer()`'s
  `type: "featureCollection"` output is wired through today.
- **Geometry types** (`IPoint`/`IPolygon`/etc.) - handled elsewhere, not
  modeled in this package's type registry.
- **Other chart types' series shapes** (line, pie, gauge, histogram, box
  plot, radar) show up as dependencies while resolving bar/scatter but are
  explicitly deferred to their own future `data-raw/<type>-model.json`
  pass.

## Conventions worth knowing before editing `R/`

- S7 classes: `Foo := new_class(properties = list(...))` - no name string
  as the first arg (breaks `:=`'s inference, silently binds to `parent`
  instead and errors). `s7x::` is always fully-qualified in package code.
- Optional properties: `NA` already satisfies `s7x::class_string`/
  `class_double`/`class_boolean`/`Enum` (has `allow_na = TRUE`) - no
  wrapping needed. Only optional *object-typed* properties need
  `s7x::property_union(Type, NULL, default = NULL)`.
- `Color` (`R/color.R`) is `r`/`g`/`b`/`a` (four `class_double`), not the
  raw `[r,g,b,a]` tuple the spec uses - a deliberate exception, keep it.
- `DESCRIPTION`'s `Collate:` field is load-bearing - `R/` files have real
  cross-file dependencies. Add new files to it in dependency order or
  `load_all()` breaks with "object not found".
- After writing/editing any S7 class, diff its property names against
  `data-raw/spec-type-registry.json` programmatically (see the
  `arcgis-spec-types` skill for the snippet) - don't eyeball it, this has
  caught real drift before.

## Standing rule from global config

Never write/run ad-hoc inline scripts (`python -c`, `node -e`, etc.) for
file operations or data manipulation, even read-only checks - this
project has been burned by that before. Data-generating R scripts live
under `data-raw/` as real files, reviewed, then run with
`R -q -f data-raw/whatever.R`. One-off `R -q -e` inspection/verification
snippets are fine.
