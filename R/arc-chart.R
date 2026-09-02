#' @include types-radar-chart.R
NULL

# Public, user-facing chart-building API. Wraps the internal S7 type layer
# (R/types-*.R) - none of those classes, or their s7x::Enum values, are
# meant to be constructed or referenced by users of this package. Friendly
# values here are kebab-case with no spec-internal prefixes ("side-by-side",
# not "sideBySide"; "bar", not "barChart"/"barSeries") and get translated to
# the exact spec values internally.
#
# Core pipe: arc_chart(.data) |> set_type() |> set_x() |> set_y() |> set_stat()
#
# `ArcChart` holds the mapping, not a WebChart: under aggregation the series'
# `y` is the outStatisticFieldName while onStatisticField is the source
# column, so the config can't be built until both are known.

library(S7)

#' A chart specification
#'
#' Holds a data frame and the mapping built up by the `set_*()` functions.
#' The `@webchart` property is computed from that mapping rather than stored,
#' so assigning to it has no effect.
#'
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass)@webchart
#' @name ArcChart
#' @export
ArcChart <- new_class(
  "ArcChart",
  properties = list(
    data = S7::class_any,
    chart_type = s7x::class_string,
    x = s7x::class_string,
    y = s7x::class_string,
    stat = s7x::class_string,
    labs = class_list,
    color = class_list,
    alpha = s7x::property_range(0, 1),
    size = class_list,
    tooltip = S7::class_character,
    axes = class_list,
    legend = class_list,
    flipped = s7x::class_boolean,
    position = s7x::class_string,
    series_opts = class_list,
    config_opts = class_list,
    webchart = S7::new_property(getter = function(self) build_webchart(self))
  )
)

# Per chart type capability flags, read by build_webchart() instead of
# branching on the type name. `tooltip_keys` names what identifies one mark;
# absent means the type has no tooltip hook (web-chart.d.ts:845).
chart_type_map <- list(
  bar = list(
    model_type = "barChart",
    series_type = "barSeries",
    series_class = WebChartBarChartSeries,
    config_class = WebChart,
    aggregates = TRUE,
    has_y = TRUE,
    splits = TRUE,
    stacks = TRUE,
    tooltip_keys = c("series", "x"),
    symbol_property = "fillSymbol",
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  scatter = list(
    model_type = "scatterplot",
    series_type = "scatterSeries",
    series_class = WebChartScatterplotSeries,
    config_class = WebChart,
    aggregates = FALSE,
    has_y = TRUE,
    tooltip_fields = TRUE,
    tooltip_keys = character(),
    sizes = TRUE,
    symbol_class = ISimpleMarkerSymbol,
    symbol_type = "esriSMS",
    symbol_style = SimpleMarkerSymbolStyle("esriSMSCircle")
  ),
  line = list(
    model_type = "lineChart",
    series_type = "lineSeries",
    series_class = WebChartLineChartSeries,
    config_class = WebChart,
    aggregates = TRUE,
    has_y = TRUE,
    splits = TRUE,
    stacks = TRUE,
    tooltip_keys = c("series", "x"),
    symbol_property = "lineSymbol",
    symbol_class = ISimpleLineSymbol,
    symbol_type = "esriSLS",
    symbol_style = SimpleLineSymbolStyle("esriSLSSolid")
  ),
  histogram = list(
    model_type = "histogram",
    series_type = "histogramSeries",
    series_class = WebChartHistogramSeries,
    config_class = WebChart,
    aggregates = FALSE,
    has_y = FALSE,
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  boxplot = list(
    model_type = "boxPlot",
    series_type = "boxPlotSeries",
    series_class = WebChartBoxPlotSeries,
    config_class = WebBoxPlot,
    aggregates = FALSE,
    has_y = TRUE,
    splits = TRUE,
    symbol_property = "fillSymbol",
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  heat = list(
    model_type = "heatChart",
    series_type = "heatSeries",
    series_class = WebChartHeatChartSeries,
    config_class = WebHeatChart,
    aggregates = FALSE,
    has_y = TRUE,
    tooltip_keys = c("x", "y"),
    # This type's legend is its colour gradient rather than a series list
    # (tf(), components/arcgis-chart/customElement.js:11062), so it is worth
    # drawing without a grouping.
    legend_ramp = TRUE,
    # Without a category valueFormat on both axes the client reads the config
    # as a half-built calendar heat chart and renders a placeholder asking
    # for a date field (Io(), dist/chunks/index2.js:4144).
    axis_defaults = list(
      valueFormat = CategoryFormatOptions(type = "category")
    ),
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  pie = list(
    model_type = "pieChart",
    series_type = "pieSeries",
    series_class = WebChartPieChartSeries,
    config_class = WebChart,
    # ya() (dist/chunks/index2.js:589) reads the same query shape ga() does:
    # no outStatistics is PieNoAggregation, grouped statistics is
    # PieFromCategory. There is no split-by subtype.
    aggregates = TRUE,
    has_y = TRUE,
    # A pie is all slices, so its legend is the only key to them.
    legend_ramp = TRUE,
    # tt() (dist/chunks/index.js:765) is the one default config with no
    # `axes` key at all, so sending axes would add a pair it never had.
    axis_count = 0L,
    symbol_property = "fillSymbol",
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  gauge = list(
    model_type = "gauge",
    series_type = "gaugeSeries",
    series_class = WebChartGaugeSeries,
    config_class = WebGaugeChart,
    aggregates = TRUE,
    # The value rides `x`, and the single reading has no second dimension.
    has_y = FALSE,
    value_on_x = TRUE,
    # ce() (dist/chunks/index.js:463) builds exactly one axis, the one
    # carrying the needle.
    axis_count = 1L,
    axis_class = WebChartGaugeAxis,
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  radar = list(
    model_type = "radarChart",
    series_type = "radarSeries",
    # The spec declares the radar series as WebChartLineChartSeries with a
    # different `type` (web-chart.d.ts:1236), and k() (index2.js:601) routes
    # it through the bar/line subtype detection, so it splits like one too.
    series_class = WebChartLineChartSeries,
    config_class = WebRadarChart,
    aggregates = TRUE,
    has_y = TRUE,
    splits = TRUE,
    tooltip_keys = c("series", "x"),
    # An axis title is centred inside its own axis (k(), chunks/index.js:253),
    # which on a circular one is the middle of the plot.
    untitled_axes = TRUE,
    symbol_property = "lineSymbol",
    symbol_class = ISimpleLineSymbol,
    symbol_type = "esriSLS",
    symbol_style = SimpleLineSymbolStyle("esriSLSSolid")
  )
)

# friendly stat -> IStatisticDefinition$statisticType. "identity" is absent
# on purpose: it means send no outStatistics at all, which is what ga()
# (dist/chunks/index2.js:593) keys BarAndLineNoAggregation off.
stat_map <- c(
  count = "count",
  sum = "sum",
  mean = "avg",
  min = "min",
  max = "max",
  sd = "stddev",
  var = "var"
)

# ggplot2's position adjustments -> WebChart$stackedType. Only meaningful
# once a chart has more than one series, which is what set_color() on a
# column other than `x` produces (see chart_split()).
position_map <- c(
  dodge = "sideBySide",
  stack = "stacked",
  fill = "stacked100"
)

#' Start a chart
#'
#' Creates an empty chart bound to a data frame. Pipe it into [set_type()]
#' before mapping any columns.
#'
#' @param .data Defines which data frame the chart draws its fields from.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_chart(df) |>
#'   set_type("bar") |>
#'   set_x(species) |>
#'   set_y(mass)
#' @export
arc_chart <- function(.data) {
  ArcChart(data = .data)
}

#' Set a chart's type
#'
#' Chooses which kind of series the chart draws. Every other `set_*()`
#' function needs this to have run first.
#'
#' @param chart Defines which chart to modify.
#' @param type Defines which series the chart draws. One of `"bar"`,
#'   `"scatter"`, `"line"`, `"histogram"`, `"boxplot"`, `"heat"`, `"pie"`,
#'   `"radar"`, or `"gauge"`.
#' @return `chart`, with its series type set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_chart(df) |>
#'   set_type("scatter") |>
#'   set_x(mass) |>
#'   set_y(mass)
#' @export
set_type <- function(chart, type) {
  chart@chart_type <- rlang::arg_match0(type, names(chart_type_map))
  chart
}

check_chart_type_set <- function(chart, call = rlang::caller_env()) {
  if (is.na(chart@chart_type)) {
    cli::cli_abort(
      c(
        "{.fn set_type} must be called first.",
        "i" = "It decides which series {.arg x}, {.arg y} and {.arg stat}
               are set on."
      ),
      call = call
    )
  }
}

check_column <- function(chart, col, arg, call = rlang::caller_env()) {
  cols <- names(chart@data)
  if (rlang::is_null(chart@data) || col %in% cols) {
    return(invisible(col))
  }

  cli::cli_abort(
    c(
      "{.arg {arg}} must be a column in {.arg .data}.",
      "x" = "Column {.field {col}} not found.",
      "i" = "{.arg .data} has {length(cols)} column{?s}: {.field {cols}}."
    ),
    call = call
  )
}

#' Map a column to a chart's x or y field
#'
#' Binds a column to one of the chart's positional fields. Both take a bare
#' column name.
#'
#' @param chart Defines which chart to modify.
#' @param x,y Defines which column supplies the field.
#' @return `chart`, with the field mapping set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_chart(df) |>
#'   set_type("bar") |>
#'   set_x(species) |>
#'   set_y(mass)
#' @export
set_x <- function(chart, x) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(x))
  check_column(chart, col, "x")
  chart@x <- col
  chart
}

#' @rdname set_x
#' @export
set_y <- function(chart, y) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(y))
  check_column(chart, col, "y")
  chart@y <- col
  chart
}

#' Set a chart's statistical transformation
#'
#' Chooses how `y` is derived from the data. `"identity"` plots `y` verbatim
#' and every other value aggregates `y` grouped by `x`.
#'
#' @param chart Defines which chart to modify.
#' @param stat Defines how `y` is aggregated. One of `"identity"`, `"count"`,
#'   `"sum"`, `"mean"`, `"min"`, `"max"`, `"sd"`, or `"var"`.
#' @return `chart`, with its stat set.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))
#'
#' arc_chart(df) |>
#'   set_type("bar") |>
#'   set_x(species) |>
#'   set_y(mass) |>
#'   set_stat("mean")
#' @export
set_stat <- function(chart, stat) {
  check_chart_type_set(chart)
  chart@stat <- rlang::arg_match0(stat, c("identity", names(stat_map)))
  chart
}

# The series' `y` has to name the aggregate's output field, not the source
# column - the query engine returns the former. Naming follows the SDK's own
# `${statisticType}_${field}_0` convention (dist/chunks/index.js, $e()).
series_aggregation <- function(
  chart,
  stat,
  suffix = "0",
  field = chart@y,
  group = TRUE,
  call = rlang::caller_env()
) {
  # A gauge aggregates the column `x` names, every other type the one `y`
  # does, so the missing-mapping error has to blame the right setter.
  mapper <- if (identical(field, chart@x)) "set_x" else "set_y"
  if (identical(stat, "count")) {
    on_field <- oid_field
  } else {
    if (is.na(field)) {
      cli::cli_abort(
        c(
          "{.fn {mapper}} is required when {.arg stat} is {.val {stat}}.",
          "i" = "{.val count} is the only stat that needs no column."
        ),
        call = call
      )
    }
    on_field <- field
  }
  # The suffix is only a key, never SQL, so a level name goes in verbatim.
  out_field <- paste0(
    toupper(sprintf("%s_%s", stat_map[[stat]], on_field)),
    "_",
    suffix
  )

  list(
    y = out_field,
    query = WebChartSeriesQuery(
      # A gauge reduces the whole layer to one number, so it groups by
      # nothing (ue(), dist/chunks/gauge-model.js:47).
      # I() keeps the spec's string[] - auto_unbox would emit a bare string.
      groupByFieldsForStatistics = if (group) I(chart@x) else character(),
      outStatistics = list(
        IStatisticDefinition(
          statisticType = IStatisticDefinitionStatisticType(stat_map[[stat]]),
          onStatisticField = on_field,
          outStatisticFieldName = out_field
        )
      )
    )
  )
}

# An omitted label leaves the model's default alone, a string overrides it,
# and NULL removes it. NULL can't be stored in a list without deleting the
# key, so a removed label is held as "" - which is also how it goes over the
# wire, since the client's own empty labels are empty strings.
lab_keep <- structure(list(), class = "arcgisviz_lab_keep")

lab_value <- function(value, arg, call = rlang::caller_env()) {
  if (rlang::is_null(value)) {
    return("")
  }
  if (!rlang::is_string(value)) {
    cli::cli_abort(
      c(
        "{.arg {arg}} must be a single string or {.code NULL}.",
        "x" = "You supplied {.obj_type_friendly {value}}.",
        "i" = "{.code NULL} removes the label; omit {.arg {arg}} to keep the
               default."
      ),
      call = call
    )
  }
  value
}

#' Set a chart's labels
#'
#' Overrides the text a chart labels itself with. Omitting an argument leaves
#' that label alone, a string sets it, and `NULL` removes it.
#'
#' @param chart Defines which chart to modify.
#' @param ... These dots are for future extensions and must be empty.
#' @param title,subtitle,caption Defines the chart-level text. Absent unless
#'   set, and `caption` renders as the chart's footer.
#' @param x,y Defines the axis titles, which also label tooltip values.
#'   Defaults to the mapped column names.
#' @return `chart`, with its labels set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass) |>
#'   set_labs(title = "Mass by species", x = "Species", y = "Mass (g)")
#' @export
set_labs <- function(
  chart,
  ...,
  title = lab_keep,
  subtitle = lab_keep,
  caption = lab_keep,
  x = lab_keep,
  y = lab_keep
) {
  rlang::check_dots_empty()

  supplied <- list(
    title = title,
    subtitle = subtitle,
    caption = caption,
    x = x,
    y = y
  )
  supplied <- supplied[
    !vapply(
      supplied,
      inherits,
      logical(1),
      "arcgisviz_lab_keep"
    )
  ]

  labs <- chart@labs
  for (arg in names(supplied)) {
    labs[[arg]] <- lab_value(supplied[[arg]], arg)
  }
  chart@labs <- labs
  chart
}

chart_text <- function(text) {
  WebChartText(
    type = "chartText",
    content = WebChartTextSymbol(type = "esriTS", text = text)
  )
}

# Chart-level labels are absent by default, so a removed one is just unset -
# as_vector() nulls the title out to delete the client's own default.
chart_titled <- function(text) {
  if (rlang::is_null(text) || !nzchar(text)) {
    return(NULL)
  }
  chart_text(text)
}

# Tooltips label each value with the axis title, falling back to the field
# alias only when that title is empty (customElement.js:10170) - and the
# model's defaults are the localized "X-axis"/"Count", so leaving them in
# place mislabels both the axis and the tooltip.
axis_title <- function(text) {
  # Nothing mapped to title the axis with, so leave that default alone.
  if (is.na(text)) {
    return(NULL)
  }

  # A removed label has to blank the default rather than be dropped, and an
  # invisible title reserves no height (customElement.js:12053).
  if (!nzchar(text)) {
    return(WebChartText(
      type = "chartText",
      visible = FALSE,
      content = WebChartTextSymbol(type = "esriTS", text = "")
    ))
  }

  chart_text(text)
}

# `opts` is already keyed by spec property name, translated in set_axis().
# `type` is required by the spec and also keeps the axis from compacting to
# nothing: deepMerge maps over the source array, so a dropped axis would
# shorten `axes` and delete one of the model's own.
chart_axis <- function(text, opts, class = WebChartAxis) {
  args <- opts
  args$type <- "chartAxis"
  title <- axis_title(text)
  if (!rlang::is_null(title)) {
    args$title <- title
  }
  rlang::exec(class, !!!args)
}

# deepMerge() maps over the source array (arcgisChart.js:24), so the count
# has to match the model's own: two axes for most types, one for a gauge
# (ce(), chunks/index.js:463), and none at all for a pie, whose default
# config omits the key (tt(), chunks/index.js:765).
chart_axes <- function(chart, spec, x_title, y_title) {
  count <- if (rlang::is_null(spec$axis_count)) 2L else spec$axis_count
  if (count == 0L) {
    return(list())
  }
  class <- if (rlang::is_null(spec$axis_class)) {
    WebChartAxis
  } else {
    spec$axis_class
  }

  # A gauge's one axis is the value scale, which set_axis("x") names.
  axes <- list(
    chart_axis(x_title, c(spec$axis_defaults, chart@axes$x), class)
  )
  if (count == 1L) {
    return(axes)
  }
  c(axes, list(chart_axis(y_title, c(spec$axis_defaults, chart@axes$y), class)))
}

check_axis_flag <- function(value, arg, call = rlang::caller_env()) {
  if (
    rlang::is_null(value) || rlang::is_scalar_logical(value) && !is.na(value)
  ) {
    return(invisible(value))
  }
  cli::cli_abort(
    c(
      "{.arg {arg}} must be {.code TRUE} or {.code FALSE}.",
      "x" = "You supplied {.obj_type_friendly {value}}."
    ),
    call = call
  )
}

check_limits <- function(limits, call = rlang::caller_env()) {
  if (rlang::is_null(limits)) {
    return(invisible(limits))
  }
  if (!is.numeric(limits) || length(limits) != 2L) {
    cli::cli_abort(
      c(
        "{.arg limits} must be two numbers.",
        "x" = "You supplied {.obj_type_friendly {limits}}.",
        "i" = "Use {.code NA} for a bound the chart should pick itself."
      ),
      call = call
    )
  }
  if (!anyNA(limits) && limits[[1]] >= limits[[2]]) {
    cli::cli_abort(
      c(
        "{.arg limits} must be increasing.",
        "x" = "{.val {limits[[1]]}} is not below {.val {limits[[2]]}}."
      ),
      call = call
    )
  }
  invisible(limits)
}

#' Set an axis
#'
#' Overrides how one axis is scaled and drawn. Omitted arguments leave that
#' part of the axis as the chart would draw it.
#'
#' @param chart Defines which chart to modify.
#' @param axis Defines which axis to change, either `"x"` or `"y"`.
#' @param ... These dots are for future extensions and must be empty.
#' @param limits default `NULL`. Defines the two values the axis spans, where
#'   `NA` leaves that bound to the chart.
#' @param log default `NULL`. Defines whether the axis is logarithmic.
#' @param zero_line default `NULL`. Defines whether a line is drawn at zero.
#' @param integer_only default `NULL`. Defines whether only whole numbers are
#'   labelled.
#' @param tick_spacing default `NULL`. Defines the smallest gap between ticks,
#'   which the chart may still widen to fit.
#' @param buffer default `NULL`. Defines whether space is added around the
#'   series.
#' @param visible default `NULL`. Defines whether the axis is drawn at all.
#' @return `chart`, with that axis set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass) |>
#'   set_axis("y", limits = c(0, 10), zero_line = TRUE)
#' @export
set_axis <- function(
  chart,
  axis,
  ...,
  limits = NULL,
  log = NULL,
  zero_line = NULL,
  integer_only = NULL,
  tick_spacing = NULL,
  buffer = NULL,
  visible = NULL
) {
  rlang::check_dots_empty()
  axis <- rlang::arg_match0(axis, c("x", "y"))

  check_limits(limits)
  check_axis_flag(log, "log")
  check_axis_flag(zero_line, "zero_line")
  check_axis_flag(integer_only, "integer_only")
  check_axis_flag(buffer, "buffer")
  check_axis_flag(visible, "visible")

  if (!rlang::is_null(tick_spacing)) {
    if (
      !rlang::is_scalar_double(tick_spacing) &&
        !rlang::is_scalar_integer(tick_spacing)
    ) {
      cli::cli_abort(
        "{.arg tick_spacing} must be a single number.",
        call = rlang::caller_env()
      )
    }
    if (tick_spacing < 1) {
      cli::cli_abort(
        c(
          "{.arg tick_spacing} must be at least 1.",
          "x" = "You supplied {.val {tick_spacing}}."
        ),
        call = rlang::caller_env()
      )
    }
  }

  # Stored under spec property names so chart_axis() can splice them straight
  # into WebChartAxis(). An NA bound is left unset, which is what the spec
  # reads as "work it out from the data".
  opts <- list(
    minimum = if (!rlang::is_null(limits) && !is.na(limits[[1]])) limits[[1]],
    maximum = if (!rlang::is_null(limits) && !is.na(limits[[2]])) limits[[2]],
    isLogarithmic = log,
    displayZeroLine = zero_line,
    integerOnlyValues = integer_only,
    tickSpacing = if (!rlang::is_null(tick_spacing)) as.double(tick_spacing),
    buffer = buffer,
    visible = visible
  )
  opts <- opts[!vapply(opts, rlang::is_null, logical(1))]

  stored <- chart@axes[[axis]]
  for (nm in names(opts)) {
    stored[[nm]] <- opts[[nm]]
  }
  chart@axes[[axis]] <- stored
  chart
}

#' Swap a chart's axes
#'
#' Draws the chart on its side, turning vertical bars into horizontal ones.
#' The mapping is untouched, so `x` stays `x`.
#'
#' @param chart Defines which chart to modify.
#' @param flipped default `TRUE`. Defines whether the axes are swapped.
#' @return `chart`, with its orientation set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass) |>
#'   set_flipped()
#' @export
set_flipped <- function(chart, flipped = TRUE) {
  check_axis_flag(flipped, "flipped")
  chart@flipped <- flipped
  chart
}

#' Arrange grouped bars and lines
#'
#' Places the groups that [set_color()] creates beside each other, on top of
#' each other, or stretched to fill the axis. A chart with a single group has
#' nothing to arrange, so this does nothing until a colour column other than
#' `x` splits it.
#'
#' @param chart Defines which chart to modify.
#' @param position default `"dodge"`. Defines how the groups are placed, one
#'   of `"dodge"`, `"stack"`, or `"fill"`.
#' @return `chart`, with its position adjustment set.
#' @examples
#' df <- data.frame(
#'   species = c("a", "a", "b"),
#'   island = c("x", "y", "x")
#' )
#'
#' arc_bar(df, species) |>
#'   set_color(island) |>
#'   set_position("stack")
#' @export
set_position <- function(chart, position = "dodge") {
  check_chart_type_set(chart)
  check_stacks(chart)
  chart@position <- rlang::arg_match0(position, names(position_map))
  chart
}

legend_positions <- c("right", "left", "top", "bottom")

#' Position or hide a chart's legend
#'
#' Moves, titles, or removes the key naming a chart's groups. A legend needs
#' something to name, so a chart only has one once [set_color()] has grouped
#' it, and it is drawn by default from then on. A heat chart is the
#' exception: its legend is the colour gradient, so it always has one.
#'
#' Asking for a legend on a chart that cannot show one is an error rather
#' than a silent no-op - `visible = TRUE` cannot conjure a key out of a
#' single series.
#'
#' @param chart Defines which chart to modify.
#' @param visible default `NULL`. Defines whether the legend is drawn.
#' @param position default `NULL`. Defines where it sits, one of `"right"`,
#'   `"left"`, `"top"`, or `"bottom"`.
#' @param title default `NULL`. Defines the text above the legend.
#' @return `chart`, with its legend set.
#' @examples
#' df <- data.frame(
#'   species = c("a", "a", "b"),
#'   island = c("x", "y", "x")
#' )
#'
#' arc_bar(df, species) |>
#'   set_color(island) |>
#'   set_legend(position = "bottom", title = "Island")
#' @export
set_legend <- function(
  chart,
  visible = NULL,
  position = NULL,
  title = NULL
) {
  if (!rlang::is_null(visible)) {
    check_axis_flag(visible, "visible")
  }
  if (!rlang::is_null(position)) {
    position <- rlang::arg_match0(position, legend_positions)
  }
  if (!rlang::is_null(title) && !rlang::is_string(title)) {
    cli::cli_abort(c(
      "{.arg title} must be a single string.",
      "x" = "You supplied {.obj_type_friendly {title}}."
    ))
  }

  chart@legend <- merge_opts(
    chart@legend,
    list(visible = visible, position = position, title = title)
  )
  chart
}

# Zc() (chunks/index3.js:654) decides whether a chart has anything to key -
# heat and pie always do, bar/line/combo/box plot only past one series - and
# gates the whole legend on it (customElement.js:12080). So the config never
# carries more than what was actually asked for.
chart_legend <- function(chart, split, spec, call = rlang::caller_env()) {
  opts <- chart@legend
  if (isTRUE(opts$visible)) {
    check_legend(chart, split, spec, call = call)
  }
  if (rlang::is_empty(opts)) {
    return(NULL)
  }

  WebChartLegend(
    type = "chartLegend",
    visible = if (rlang::is_null(opts$visible)) NA else opts$visible,
    position = if (rlang::is_null(opts$position)) {
      WebChartLegendPositions()
    } else {
      WebChartLegendPositions(opts$position)
    },
    title = legend_title(opts$title)
  )
}

# The client refuses to draw a legend a chart has no entries for, so asking
# for one would otherwise fail silently.
check_legend <- function(chart, split, spec, call = rlang::caller_env()) {
  if (isTRUE(spec$legend_ramp) || !rlang::is_null(split)) {
    return(invisible(chart))
  }
  cli::cli_abort(
    c(
      "{.arg visible} needs a legend to show, and this chart has none.",
      "x" = "A {chart@chart_type} chart with one series has nothing to key.",
      "i" = "Group it with {.fn set_color} on a column other than
             {.field {chart@x}}."
    ),
    call = call
  )
}

# The default legend title is empty but visible, and the client's own text
# setter leaves `visible` alone (P(), chunks/data-labels-visibility.js:25) -
# so a title built here has to say so itself.
legend_title <- function(text) {
  if (rlang::is_null(text)) {
    return(NULL)
  }
  WebChartText(
    type = "chartText",
    visible = TRUE,
    content = WebChartTextSymbol(type = "esriTS", text = text)
  )
}

# Only bar and line read stackedType. Every other type either has no second
# dimension left to arrange (histogram, heat) or arranges its groups itself
# (box plot), so silently accepting a position would be a lie.
check_stacks <- function(chart, call = rlang::caller_env()) {
  spec <- chart_type_map[[chart@chart_type]]
  if (isTRUE(spec$stacks)) {
    return(invisible(chart))
  }

  stackable <- names(chart_type_map)[vapply(
    chart_type_map,
    function(s) isTRUE(s$stacks),
    logical(1)
  )]
  cli::cli_abort(
    c(
      "{.arg position} does not apply to {chart@chart_type} charts.",
      "i" = "Only {.val {stackable}} charts stack or dodge."
    ),
    call = call
  )
}

# The `position` argument the arc_*() shortcuts share. NULL leaves the
# default alone; anything else routes through set_position()'s validation.
chart_positioned <- function(chart, position, call = rlang::caller_env()) {
  if (rlang::is_null(position)) {
    return(chart)
  }
  check_stacks(chart, call = call)
  chart@position <- rlang::arg_match0(
    position,
    names(position_map),
    arg_nm = "position",
    error_call = call
  )
  chart
}

#' Map a column to marker size
#'
#' Scales each marker by the value of a numeric column, turning a
#' scatterplot into a bubble chart. Only scatterplots draw markers, so this
#' does not apply to the other chart types.
#'
#' @param chart Defines which chart to modify.
#' @param size Defines which numeric column the marker sizes are drawn from.
#' @param range default `NULL`. Defines the smallest and largest marker size
#'   as a length-2 numeric vector. `NULL` keeps the SDK's own 5 to 30.
#' @param scale default `"linear"`. Defines how values map onto that range,
#'   either `"linear"` or `"log"`.
#' @return `chart`, with its marker sizes set.
#' @examples
#' df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6), mass = c(10, 40, 25))
#'
#' arc_scatter(df, len, dep) |>
#'   set_size(mass, range = c(4, 20))
#' @export
set_size <- function(chart, size, range = NULL, scale = "linear") {
  check_chart_type_set(chart)
  spec <- chart_type_map[[chart@chart_type]]
  if (!isTRUE(spec$sizes)) {
    cli::cli_abort(
      c(
        "{.fn set_size} does not apply to {chart@chart_type} charts.",
        "i" = "Only scatterplots draw a marker per row."
      ),
      call = rlang::caller_env()
    )
  }

  col <- rlang::as_string(rlang::ensym(size))
  check_column(chart, col, "size")

  values <- chart@data[[col]]
  if (!rlang::is_null(values) && !is.numeric(values)) {
    cli::cli_abort(
      c(
        "{.arg size} must map a numeric column.",
        "x" = "{.field {col}} is {.cls {class(values)}}."
      ),
      call = rlang::caller_env()
    )
  }

  scale <- rlang::arg_match0(scale, c("linear", "log"))
  range <- check_size_range(range)

  chart@size <- list(field = col, range = range, scale = scale)
  chart
}

check_size_range <- function(range, call = rlang::caller_env()) {
  if (rlang::is_null(range)) {
    return(NULL)
  }
  if (!is.numeric(range) || length(range) != 2 || anyNA(range)) {
    cli::cli_abort(
      c(
        "{.arg range} must be two numbers, the smallest and largest size.",
        "x" = "You supplied {.obj_type_friendly {range}}."
      ),
      call = call
    )
  }
  if (any(range < 1) || range[[1]] > range[[2]]) {
    cli::cli_abort(
      c(
        "{.arg range} must run from small to large, and no smaller than 1.",
        "x" = "You supplied {.val {range}}."
      ),
      call = call
    )
  }
  as.double(range)
}

# The spec calls a log scale "logarithmic"; ggplot2 users write "log".
size_scale_map <- c(linear = "linear", log = "logarithmic")

series_size <- function(chart) {
  size <- chart@size
  if (rlang::is_empty(size)) {
    return(NULL)
  }
  SizePolicy(
    type = "sizeScale",
    field = size$field,
    scaleType = SizePolicyScaleTypes(size_scale_map[[size$scale]]),
    minSize = if (!rlang::is_null(size$range)) size$range[[1]] else NA_real_,
    maxSize = if (!rlang::is_null(size$range)) size$range[[2]] else NA_real_
  )
}

#' Add columns to a chart's tooltip
#'
#' Names extra columns to show when a mark is hovered, alongside `x` and `y`.
#' Name an argument to label it, or pass a bare column name to label it with
#' the column name. A column mapped with [set_color()] is added for you.
#'
#' Every mark on a chart covers a group of rows: a bar covers every row with
#' that `x`, a heat cell every row in that pair of categories. An extra field
#' can only be shown when it takes a single value across that group, so
#' `set_tooltip()` checks that and errors rather than pick one arbitrarily.
#' Histograms are the exception and take no tooltip fields at all, because
#' their bins are computed in the browser.
#'
#' @param chart Defines which chart to modify.
#' @param ... Defines which columns to show, as bare column names. Name an
#'   argument to use that name as the label. Passing none clears whatever is
#'   already set.
#' @return `chart`, with its tooltip fields set.
#' @examples
#' df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6), id = c("a", "b", "c"))
#'
#' arc_scatter(df, len, dep) |>
#'   set_tooltip(Identifier = id)
#' @export
set_tooltip <- function(chart, ...) {
  check_chart_type_set(chart)
  spec <- chart_type_map[[chart@chart_type]]
  if (rlang::is_null(spec$tooltip_keys)) {
    cli::cli_abort(
      c(
        "{.fn set_tooltip} does not apply to {chart@chart_type} charts.",
        "i" = "Their bins are computed in the browser, so there is no row
               to read a field from."
      ),
      call = rlang::caller_env()
    )
  }

  syms <- rlang::ensyms(...)
  cols <- vapply(syms, rlang::as_string, character(1))
  labels <- rlang::names2(syms)
  labels[labels == ""] <- cols[labels == ""]
  for (col in cols) {
    check_column(chart, col, "...")
  }

  chart@tooltip <- rlang::set_names(unname(cols), labels)
  chart
}

# The lookup's outer key when a chart has one series, so the client can fall
# back to it without knowing whether the chart was split.
tooltip_any_series <- "*"

# The client is handed a bar's own x value, so both sides have to stringify a
# key the same way. Dates do not, which is why check_tooltip_keys() blocks
# them.
tooltip_key <- function(x) {
  if (is.numeric(x)) {
    return(format(x, trim = TRUE, scientific = FALSE))
  }
  as.character(x)
}

tooltip_value <- function(x) {
  if (is.numeric(x)) {
    return(format(x, trim = TRUE, scientific = FALSE))
  }
  as.character(x)
}

check_tooltip_keys <- function(chart, spec, call = rlang::caller_env()) {
  cols <- c(chart@x, if ("y" %in% spec$tooltip_keys) chart@y)
  for (col in cols) {
    values <- chart@data[[col]]
    if (inherits(values, "Date") || inherits(values, "POSIXt")) {
      cli::cli_abort(
        c(
          "{.fn set_tooltip} cannot key off the date column {.field {col}}.",
          "i" = "R and the browser format dates differently, so the lookup
                 would never match."
        ),
        call = call
      )
    }
  }
}

# One value per mark or nothing: picking one of several would be a lie about
# which row the reader is looking at.
check_tooltip_unique <- function(values, group, col, label, call) {
  counts <- tapply(values, group, function(v) length(unique(v)))
  bad <- counts[!is.na(counts) & counts > 1]
  if (rlang::is_empty(bad)) {
    return(invisible(NULL))
  }

  n <- max(bad)
  cli::cli_abort(
    c(
      "{.arg {label}} maps {.field {col}}, which is not constant within
       each mark.",
      "x" = "One mark covers {n} different value{?s} of {.field {col}}.",
      "i" = "Aggregate it first, or map it with {.fn set_color} instead."
    ),
    call = call
  )
}

# Scatter reads its own additionalTooltipFields, so only the other types need
# a lookup shipped alongside the config.
tooltip_payload <- function(chart, call = rlang::caller_env()) {
  spec <- chart_type_map[[chart@chart_type]]
  fields <- chart@tooltip
  if (rlang::is_empty(fields) || isTRUE(spec$tooltip_fields)) {
    return(NULL)
  }
  check_tooltip_keys(chart, spec, call = call)

  data <- chart@data
  split <- chart_split(chart, spec)
  outer <- if (rlang::is_null(split)) {
    rep(tooltip_any_series, nrow(data))
  } else {
    tooltip_key(data[[split$field]])
  }
  inner <- if ("y" %in% spec$tooltip_keys) {
    paste(
      tooltip_key(data[[chart@x]]),
      tooltip_key(data[[chart@y]]),
      sep = "\r"
    )
  } else {
    tooltip_key(data[[chart@x]])
  }

  group <- paste(outer, inner, sep = "\r")
  for (i in seq_along(fields)) {
    check_tooltip_unique(
      data[[fields[[i]]]],
      group,
      fields[[i]],
      names(fields)[[i]],
      call
    )
  }

  keep <- !duplicated(group)
  lookup <- list()
  for (row in which(keep)) {
    values <- lapply(fields, function(col) tooltip_value(data[[col]][[row]]))
    lookup[[outer[[row]]]][[inner[[row]]]] <- unname(values)
  }

  list(labels = as.list(names(fields)), lookup = lookup)
}

# The chart renders a field by its alias (_e(), chunks/index3.js:646), so a
# label rides over as one rather than needing a popupTemplate.
tooltip_aliased <- function(layer, fields) {
  if (rlang::is_empty(fields)) {
    return(layer)
  }
  collection <- layer@featureCollection
  defn <- collection$layers[[1]]$layerDefinition
  hit <- match(unname(fields), defn$fields$name)
  defn$fields$alias[hit[!is.na(hit)]] <- names(fields)[!is.na(hit)]
  collection$layers[[1]]$layerDefinition <- defn
  layer@featureCollection <- collection
  layer
}

#' Map a column to colour
#'
#' Colours each mark by the value of a column. A numeric column becomes a
#' continuous gradient and a character or factor column gets one colour per
#' distinct value.
#'
#' On a bar or line chart, colouring by a column other than `x` also groups
#' the chart: it gains one series per distinct value, dodged side by side.
#' Use [set_position()] to stack them instead. Numeric columns are always a
#' gradient and never a group, the same rule as ggplot2.
#'
#' Heat charts shade cells by how many rows fall into each, so there is no
#' column to map. Give them `palette` on its own.
#'
#' @param chart Defines which chart to modify.
#' @param color Defines which column the colours are drawn from. Omitted for
#'   heat charts.
#' @param palette default `NULL`. Defines which colours to use, either the
#'   name of an Esri ramp such as `"Blue 3"` or a vector of R colours. `NULL`
#'   uses the ramp the ArcGIS SDK itself defaults to.
#' @param alpha default `NULL`. Sets how opaque the marks are, from `0` for
#'   invisible to `1` for solid. Overrides whatever opacity the palette
#'   carries, on the marks and their outlines alike. `NULL` leaves them solid.
#' @return `chart`, with its colour set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass) |>
#'   set_color(mass, palette = "Red 1")
#' @export
set_color <- function(chart, color, palette = NULL, alpha = NULL) {
  check_chart_type_set(chart)
  alpha <- check_alpha(alpha)

  # Heat cells are shaded by the series' own heat rules rather than by a
  # chartRenderer, and the value is the cell count, so there is no column to
  # map. A ramp name goes over by name and the client generates the class
  # breaks itself (serial-chart-data.js:487).
  if (identical(chart@chart_type, "heat")) {
    if (!missing(color)) {
      cli::cli_abort(
        c(
          "{.arg color} does not apply to heat charts.",
          "i" = "Cells are shaded by how many rows fall into each, so pass
                 only {.arg palette}."
        ),
        call = rlang::caller_env()
      )
    }
    chart@alpha <- alpha
    chart@series_opts <- merge_opts(
      chart@series_opts,
      heat_color_rules(palette, alpha, call = rlang::caller_env())
    )
    return(chart)
  }

  if (missing(color)) {
    cli::cli_abort(
      "{.arg color} must name a column.",
      call = rlang::caller_env()
    )
  }

  col <- rlang::as_string(rlang::ensym(color))
  check_column(chart, col, "color")

  # Resolved here, not at render, so a bad palette blames this call. NULL
  # means "whichever default suits the column's type".
  stops <- if (rlang::is_null(palette)) {
    NULL
  } else {
    palette_stops(palette, call = rlang::caller_env())
  }

  chart@alpha <- alpha
  chart@color <- list(field = col, stops = stops)
  chart
}

check_alpha <- function(alpha, call = rlang::caller_env()) {
  if (rlang::is_null(alpha)) {
    return(NA_real_)
  }
  if (!rlang::is_scalar_double(alpha) && !rlang::is_scalar_integer(alpha)) {
    cli::cli_abort(
      c(
        "{.arg alpha} must be a single number.",
        "x" = "You supplied {.obj_type_friendly {alpha}}."
      ),
      call = call
    )
  }
  if (is.na(alpha) || alpha < 0 || alpha > 1) {
    cli::cli_abort(
      c(
        "{.arg alpha} must be between 0 and 1.",
        "x" = "You supplied {.val {alpha}}."
      ),
      call = call
    )
  }
  as.double(alpha)
}

# Mirrors the SDK's own class-break symbols (class-breaks.js:414).
renderer_symbol <- function(spec, color = NULL, size = NULL, alpha = NA_real_) {
  args <- list(
    type = spec$symbol_type,
    style = spec$symbol_style,
    # The outline takes the mark's alpha too - an opaque ring around a
    # translucent fill is exactly what overplotting needs to see through.
    outline = ISimpleLineSymbol(
      type = "esriSLS",
      style = SimpleLineSymbolStyle("esriSLSSolid"),
      color = Color(r = 50, g = 50, b = 50, a = alpha_channel(alpha)),
      width = 0.5
    )
  )
  if (identical(spec$symbol_type, "esriSMS")) {
    args$size <- if (rlang::is_null(size)) 6 else size
  }
  # A line symbol has no outline of its own.
  if (identical(spec$symbol_type, "esriSLS")) {
    args$outline <- NULL
    args$width <- if (rlang::is_null(size)) 2 else size
  }
  if (!rlang::is_null(color)) {
    args$color <- color
  }
  rlang::exec(spec$symbol_class, !!!args)
}

# The client interpolates between stops (index2.js:1612), so the ramp's own
# stops go over untouched, spread across the column's range.
continuous_renderer <- function(
  field,
  values,
  stops,
  spec,
  call,
  size = NULL,
  alpha = NA_real_
) {
  rng <- range(values, na.rm = TRUE)
  if (!all(is.finite(rng))) {
    cli::cli_abort(
      c(
        "{.arg color} must map a column with at least one non-missing value.",
        "x" = "{.field {field}} has none."
      ),
      call = call
    )
  }

  if (rlang::is_null(stops)) {
    stops <- palette_stops(esri_default_ramp)
  }
  stops <- alpha_stops(stops, alpha)

  # A constant column can't span a gradient; colour it with the ramp's end.
  if (rng[[1]] == rng[[2]]) {
    return(ISimpleRenderer(
      type = "simple",
      symbol = renderer_symbol(
        spec,
        rgba_color(stops[nrow(stops), ]),
        size,
        alpha
      )
    ))
  }

  # as.double(): seq() returns an integer vector for integer endpoints.
  at <- as.double(seq(rng[[1]], rng[[2]], length.out = nrow(stops)))
  ISimpleRenderer(
    type = "simple",
    symbol = renderer_symbol(spec, size = size, alpha = alpha),
    visualVariables = list(
      IColorVisualVariable(
        type = "colorInfo",
        field = field,
        stops = lapply(seq_len(nrow(stops)), function(i) {
          IColorStop(value = at[[i]], color = rgba_color(stops[i, ]))
        })
      )
    )
  )
}

color_levels <- function(values) {
  out <- if (is.factor(values)) levels(values) else unique(as.character(values))
  sort(out[!is.na(out)])
}

chart_aggregates <- function(chart) {
  spec <- chart_type_map[[chart@chart_type]]
  stat <- if (is.na(chart@stat)) "identity" else chart@stat
  isTRUE(spec$aggregates) && stat != "identity"
}

# Colouring by a column other than `x` splits the chart into one series per
# level, each filtered by its own `where`. That is the only shape the client
# will dodge or stack - ga() (dist/chunks/index2.js:593) reads the where
# clause, not the chart type. Continuous colour stays a scale, as in ggplot2.
chart_split <- function(chart, spec) {
  color <- chart@color
  if (
    rlang::is_empty(color) ||
      !isTRUE(spec$splits) ||
      identical(color$field, chart@x)
  ) {
    return(NULL)
  }

  values <- chart@data[[color$field]]
  if (is.numeric(values)) {
    return(NULL)
  }
  list(field = color$field, levels = color_levels(values))
}

# Groups sit side by side unless asked otherwise. An unsplit chart has one
# series and nothing to arrange, so it sends nothing at all, and neither does
# a chart type the client never stacks.
chart_position <- function(chart, split, spec) {
  if (!isTRUE(spec$stacks)) {
    return(WebChartStackedKinds())
  }
  position <- if (!is.na(chart@position)) {
    chart@position
  } else if (!rlang::is_null(split)) {
    "dodge"
  } else {
    return(WebChartStackedKinds())
  }
  WebChartStackedKinds(position_map[[position]])
}

# Mirrors normalizeWhereClause(): single quotes double. getSplitByField()
# parses the field back out of this, so the `=` form is required.
split_where <- function(field, level) {
  sprintf("%s='%s'", field, gsub("'", "''", level, fixed = TRUE))
}

split_query <- function(query, field, level) {
  where <- split_where(field, level)
  if (rlang::is_null(query)) {
    return(WebChartSeriesQuery(where = where))
  }
  query@where <- where
  query
}

# Each group carries its colour on its own symbol rather than through a
# chartRenderer: with colorMatch off the client takes the symbol straight
# from the config (web-chart.d.ts:1313), so nothing rides on a renderer
# field matching the split. `name` is what the legend shows.
split_series <- function(series, split, chart, spec, stat, aggregating) {
  colors <- discrete_colors(
    chart@color$stops,
    length(split$levels),
    chart@alpha
  )
  unname(Map(
    function(level, color, i) {
      # The where clauses never run: the client folds every series into one
      # query grouped by x and the split field (os(), index2.js:1816), then
      # reshapes the result keyed by each series' outStatisticFieldName
      # (ns(), :1793). Sharing that name makes every series read the same
      # column, so the statistic has to be named per level.
      if (aggregating) {
        agg <- series_aggregation(chart, stat, suffix = level)
        series$y <- agg$y
        series$query <- agg$query
      }
      series$id <- sprintf("series%d", i)
      series$name <- level
      series$query <- split_query(series$query, split$field, level)
      series[[spec$symbol_property]] <- renderer_symbol(
        spec,
        color,
        alpha = chart@alpha
      )
      rlang::exec(spec$series_class, !!!series)
    },
    split$levels,
    colors,
    seq_along(split$levels)
  ))
}

# Under aggregation the query returns only the group-by field and the
# statistics, so a derived code column never comes back - but the grouped
# column itself does, and uniqueValue resolves against it (index2.js:1436).
unique_value_renderer <- function(
  field,
  levels,
  colors,
  spec,
  size = NULL,
  alpha = NA_real_
) {
  IUniqueValueRenderer(
    type = "uniqueValue",
    field1 = field,
    fieldDelimiter = ",",
    # unname(): Map() names its result from a character first argument, which
    # would serialize uniqueValueInfos as a JSON object instead of an array.
    uniqueValueInfos = unname(Map(
      function(value, color) {
        IUniqueValueInfo(
          value = value,
          label = value,
          symbol = renderer_symbol(spec, color, size, alpha)
        )
      },
      levels,
      colors
    ))
  )
}

# A uniqueValue renderer is ignored on the scatter (amCharts5) path, so
# categories otherwise ride a colorInfo visual variable, which every chart type
# honours. A VV needs a numeric field, hence the integer codes from
# chart_data(); one stop per code means no value ever falls between stops, so
# the interpolation never kicks in and the colours come out exact.
discrete_renderer <- function(field, values, stops, spec, call, chart) {
  levels <- color_levels(values)

  if (rlang::is_empty(levels)) {
    cli::cli_abort(
      c(
        "{.arg color} must map a column with at least one non-missing value.",
        "x" = "{.field {field}} has none."
      ),
      call = call
    )
  }

  colors <- discrete_colors(stops, length(levels), chart@alpha)

  if (chart_aggregates(chart)) {
    if (!identical(field, chart@x)) {
      cli::cli_abort(
        c(
          "{.arg color} must map the same column as {.fn set_x} when the chart
           aggregates.",
          "x" = "{.field {field}} is not {.field {chart@x}}.",
          "i" = "An aggregating query only returns {.field {chart@x}} and the
                 statistic, so no other column reaches the chart."
        ),
        call = call
      )
    }
    return(unique_value_renderer(
      field,
      levels,
      colors,
      spec,
      alpha = chart@alpha
    ))
  }

  ISimpleRenderer(
    type = "simple",
    symbol = renderer_symbol(spec, alpha = chart@alpha),
    visualVariables = list(
      IColorVisualVariable(
        type = "colorInfo",
        field = color_code_field,
        stops = unname(Map(
          function(code, color, label) {
            IColorStop(value = as.double(code), color = color, label = label)
          },
          seq_along(levels),
          colors,
          levels
        ))
      )
    )
  )
}

# Numeric -> gradient, everything else -> one colour per value.
color_renderer <- function(chart, spec, call = rlang::caller_env()) {
  color <- chart@color
  if (rlang::is_empty(color)) {
    return(NULL)
  }
  # A gauge draws one reading, so there are no marks for a scale to vary.
  if (isTRUE(spec$value_on_x)) {
    cli::cli_abort(
      c(
        "{.fn set_color} does not apply to {chart@chart_type} charts.",
        "x" = "A {chart@chart_type} draws a single value, so there is nothing
               to colour by."
      ),
      call = call
    )
  }

  values <- chart@data[[color$field]]
  if (is.numeric(values)) {
    # A continuous scale can't split, so an aggregating query would leave the
    # column behind entirely.
    if (chart_aggregates(chart) && !identical(color$field, chart@x)) {
      cli::cli_abort(
        c(
          "{.arg color} must be a grouping column when the chart aggregates.",
          "x" = "{.field {color$field}} is numeric, so it becomes a gradient
                 rather than a group.",
          "i" = "An aggregating query only returns {.field {chart@x}} and the
                 statistic, so no other column reaches the chart."
        ),
        call = call
      )
    }
    return(continuous_renderer(
      color$field,
      values,
      color$stops,
      spec,
      call,
      alpha = chart@alpha
    ))
  }
  discrete_renderer(color$field, values, color$stops, spec, call, chart)
}

# The extra column a categorical mapping needs - see discrete_renderer().
color_code_field <- "arcgisviz_color"

#' The data a chart sends, with any derived columns appended
#' @noRd
chart_data <- function(chart) {
  color <- chart@color
  if (rlang::is_empty(color)) {
    return(chart@data)
  }

  values <- chart@data[[color$field]]
  split <- chart_split(chart, chart_type_map[[chart@chart_type]])
  if (is.numeric(values) || chart_aggregates(chart) || !rlang::is_null(split)) {
    return(chart@data)
  }

  out <- chart@data
  out[[color_code_field]] <- match(
    as.character(values),
    color_levels(values)
  )
  out
}

# NULL until set_type() has run - as_widget() reports that as an error.
build_webchart <- function(chart) {
  if (is.na(chart@chart_type)) {
    return(NULL)
  }
  spec <- chart_type_map[[chart@chart_type]]
  stat <- if (is.na(chart@stat)) "identity" else chart@stat
  aggregating <- spec$aggregates && stat != "identity"

  # A gauge reads its single value off `x`; everything else off `y`.
  value_field <- if (isTRUE(spec$value_on_x)) chart@x else chart@y

  agg <- if (aggregating) {
    series_aggregation(
      chart,
      stat,
      field = value_field,
      group = !isTRUE(spec$value_on_x)
    )
  } else {
    list(y = value_field, query = NULL)
  }

  y_label <- if (!aggregating) {
    value_field
  } else if (identical(stat, "count")) {
    "count"
  } else {
    sprintf("%s(%s)", stat, value_field)
  }

  labs <- chart@labs
  axis_lab <- function(lab, mapped) if (rlang::is_null(lab)) mapped else lab
  # k()/B() (chunks/index.js:243, :222) centre an axis title inside its own
  # axis, which on a circular one is the middle of the plot. A radar's spokes
  # already carry the categories, so it goes untitled unless asked. "" blanks
  # the client's own localized default rather than leaving it in place.
  axis_lab_title <- function(lab, mapped) {
    if (rlang::is_null(lab) && isTRUE(spec$untitled_axes)) {
      ""
    } else {
      axis_lab(lab, mapped)
    }
  }

  # A split chart colours its series directly, so it needs no renderer.
  split <- chart_split(chart, spec)
  renderer <- if (rlang::is_null(split)) color_renderer(chart, spec)

  # A series names itself in the legend, so an unsplit one is named after
  # what it plots. split_series() renames each of its own after its level.
  series <- list(
    type = spec$series_type,
    id = "series1",
    name = axis_lab(labs$y, y_label),
    x = chart@x
  )
  # A histogram bins one field, so it has no `y` and derives its own
  # frequency axis. The rest carry `y`, and only bar and line take a query -
  # everything else keeps whichever one the client's defaults supply.
  if (isTRUE(spec$has_y)) {
    series$y <- agg$y
  }
  # u() (dist/chunks/gauge-model.js:70) reads the gauge's value off `x`, and
  # under aggregation that has to name the statistic's output field.
  if (isTRUE(spec$value_on_x)) {
    series$x <- agg$y
  }
  if (isTRUE(spec$aggregates)) {
    series$query <- agg$query
  }
  # A colour mapping is otherwise invisible on hover, so the coloured column
  # joins whatever set_tooltip() named. These land in the query's outFields
  # too (fu(), dist/chunks/index2.js:7857).
  if (isTRUE(spec$tooltip_fields)) {
    fields <- unique(c(chart@color$field, unname(chart@tooltip)))
    if (!rlang::is_empty(fields)) {
      series$additionalTooltipFields <- fields
    }
  }
  series$sizePolicy <- series_size(chart)
  # Chart-type options, already keyed by spec property name.
  series <- c(series, chart@series_opts)

  series_list <- if (rlang::is_null(split)) {
    list(rlang::exec(spec$series_class, !!!series))
  } else {
    split_series(series, split, chart, spec, stat, aggregating)
  }

  config <- list(
    version = "25.1.0",
    type = "chart",
    title = chart_titled(labs$title),
    subtitle = chart_titled(labs$subtitle),
    footer = chart_titled(labs$caption),
    legend = chart_legend(chart, split, spec),
    chartRenderer = renderer,
    colorMatch = if (rlang::is_null(renderer)) NA else TRUE,
    rotated = chart@flipped,
    stackedType = chart_position(chart, split, spec),
    axes = chart_axes(
      chart,
      spec,
      axis_lab_title(labs$x, if (isTRUE(spec$value_on_x)) y_label else chart@x),
      axis_lab_title(labs$y, y_label)
    ),
    series = series_list
  )

  rlang::exec(spec$config_class, !!!c(config, chart@config_opts))
}

# Unset options leave whatever is already stored, so repeated calls layer
# rather than reset. Same rule as set_labs() and set_axis().
merge_opts <- function(stored, opts) {
  opts <- opts[!vapply(opts, rlang::is_null, logical(1))]
  for (nm in names(opts)) {
    stored[[nm]] <- opts[[nm]]
  }
  stored
}

# An Esri ramp travels by name so the client can build the class breaks with
# its full stop list. Anything else collapses to the two colour gradient the
# spec allows, first stop to last.
heat_color_rules <- function(
  palette,
  alpha = NA_real_,
  call = rlang::caller_env()
) {
  if (rlang::is_null(palette)) {
    cli::cli_abort(
      c(
        "{.arg palette} is required for a heat chart.",
        "i" = "Ramps tagged {.val heatmap} suit these best, such as
               {.val Heatmap 3}."
      ),
      call = call
    )
  }

  if (rlang::is_string(palette) && palette %in% names(esri_color_ramps)) {
    # A named ramp travels by name and the client generates the class breaks
    # itself, so no colour leaves R with an alpha channel to carry.
    if (!is.na(alpha)) {
      cli::cli_abort(
        c(
          "{.arg alpha} does not apply to a named ramp on a heat chart.",
          "i" = "Pass {.arg palette} as a vector of colours instead."
        ),
        call = call
      )
    }
    return(list(
      heatRulesType = WebChartHeatChartHeatRulesTypes("renderer"),
      classBreaksRules = WebChartHeatChartHeatClassBreaks(
        colorRampInfo = WebChartHeatChartHeatClassBreaksColorRampInfo(
          name = palette
        )
      )
    ))
  }

  stops <- alpha_stops(palette_stops(palette, call = call), alpha)
  list(
    heatRulesType = WebChartHeatChartHeatRulesTypes("gradient"),
    gradientRules = WebChartHeatChartGradient(
      colorList = list(
        rgba_color(stops[1, ]),
        rgba_color(stops[nrow(stops), ])
      )
    )
  )
}

check_chart_type_is <- function(chart, type, call = rlang::caller_env()) {
  if (identical(chart@chart_type, type)) {
    return(invisible(chart))
  }
  cli::cli_abort(
    c(
      "This only applies to {.val {type}} charts.",
      "x" = "{.arg chart} is {.val {chart@chart_type}}."
    ),
    call = call
  )
}

# friendly label part -> WebChartPieChartSeries$display*OnDataLabel
pie_label_map <- c(
  category = "displayCategoryOnDataLabel",
  value = "displayNumericValueOnDataLabel",
  percent = "displayPercentageOnDataLabel"
)

# friendly transform -> WebChartDataTransformations
histogram_transform_map <- c(
  none = "none",
  log = "logarithmic",
  sqrt = "squareRoot"
)

check_bins <- function(bins, call = rlang::caller_env()) {
  if (rlang::is_null(bins)) {
    return(invisible(bins))
  }
  if (!rlang::is_scalar_double(bins) && !rlang::is_scalar_integer(bins)) {
    cli::cli_abort(
      c(
        "{.arg bins} must be a single number.",
        "x" = "You supplied {.obj_type_friendly {bins}}."
      ),
      call = call
    )
  }
  if (bins < 1 || bins != round(bins)) {
    cli::cli_abort(
      c(
        "{.arg bins} must be a whole number of at least 1.",
        "x" = "You supplied {.val {bins}}."
      ),
      call = call
    )
  }
  invisible(bins)
}

#' Bar chart
#'
#' Counts rows per `x`. Use [arc_col()] for values you have already summarised
#' or [set_stat()] for any other aggregation.
#'
#' @inheritParams arc_chart
#' @param x Defines which column the bars are grouped by.
#' @param position default `NULL`. Defines how [set_color()] groups are
#'   placed, one of `"dodge"`, `"stack"`, or `"fill"`. See [set_position()].
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))
#'
#' arc_bar(df, species)
#' @export
arc_bar <- function(.data, x, position = NULL) {
  chart <- arc_chart(.data) |>
    set_type("bar") |>
    set_x({{ x }}) |>
    set_stat("count")
  chart_positioned(chart, position)
}

#' Column chart
#'
#' Plots `y` verbatim, one bar per row. Use [arc_bar()] to count rows instead.
#'
#' @inheritParams arc_chart
#' @inheritParams arc_bar
#' @param x,y Defines which columns supply the bar positions and heights.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass)
#' @export
arc_col <- function(.data, x, y, position = NULL) {
  chart <- arc_chart(.data) |>
    set_type("bar") |>
    set_x({{ x }}) |>
    set_y({{ y }})
  chart_positioned(chart, position)
}

#' Scatterplot
#'
#' Plots one marker per row. Scatterplots ignore [set_stat()].
#'
#' @inheritParams arc_col
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(len = c(1, 5, 3), dep = c(2, 4, 6))
#'
#' arc_scatter(df, len, dep)
#' @export
arc_scatter <- function(.data, x, y) {
  arc_chart(.data) |> set_type("scatter") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Histogram
#'
#' Bins one numeric column and plots the frequency of each bin. The frequency
#' axis is derived, so there is no `y` to map.
#'
#' `set_histogram()` reaches the same options later, for charts built with
#' [set_type()] rather than this shortcut.
#'
#' @inheritParams arc_chart
#' @param chart Defines which chart to modify.
#' @param x Defines which numeric column is binned.
#' @param ... These dots are for future extensions and must be empty.
#' @param bins default `NULL`. Defines how many bins to split `x` into, or
#'   `NULL` to let the chart choose.
#' @param transform default `NULL`. Defines which transformation is applied
#'   before binning, one of `"none"`, `"log"`, or `"sqrt"`.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(mass = c(1, 5, 3, 8, 2))
#'
#' arc_histogram(df, mass, bins = 10)
#' @export
arc_histogram <- function(.data, x, bins = NULL, transform = NULL) {
  arc_chart(.data) |>
    set_type("histogram") |>
    set_x({{ x }}) |>
    set_histogram(bins = bins, transform = transform)
}

#' @rdname arc_histogram
#' @export
set_histogram <- function(chart, ..., bins = NULL, transform = NULL) {
  rlang::check_dots_empty()
  check_chart_type_set(chart)
  check_chart_type_is(chart, "histogram")
  check_bins(bins)

  opts <- list(binCount = if (!rlang::is_null(bins)) as.double(bins))
  if (!rlang::is_null(transform)) {
    transform <- rlang::arg_match0(transform, names(histogram_transform_map))
    opts$dataTransformationType <- WebChartDataTransformations(
      histogram_transform_map[[transform]]
    )
  }

  chart@series_opts <- merge_opts(chart@series_opts, opts)
  chart
}

#' Box plot
#'
#' Draws the five number summary of `y` for each value of `x`.
#'
#' `set_boxplot()` reaches the same options later, for charts built with
#' [set_type()] rather than this shortcut.
#'
#' @inheritParams arc_chart
#' @param chart Defines which chart to modify.
#' @param x Defines which column the boxes are grouped by.
#' @param y Defines which numeric column is summarised.
#' @param ... These dots are for future extensions and must be empty.
#' @param outliers default `NULL`. Defines whether points beyond the whiskers
#'   are drawn.
#' @param standardize default `NULL`. Defines whether values are replaced by
#'   their z scores, putting every box on a comparable scale.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))
#'
#' arc_boxplot(df, species, mass, outliers = FALSE)
#' @export
arc_boxplot <- function(.data, x, y, outliers = NULL, standardize = NULL) {
  arc_chart(.data) |>
    set_type("boxplot") |>
    set_x({{ x }}) |>
    set_y({{ y }}) |>
    set_boxplot(outliers = outliers, standardize = standardize)
}

#' @rdname arc_boxplot
#' @export
set_boxplot <- function(chart, ..., outliers = NULL, standardize = NULL) {
  rlang::check_dots_empty()
  check_chart_type_set(chart)
  check_chart_type_is(chart, "boxplot")
  check_axis_flag(outliers, "outliers")
  check_axis_flag(standardize, "standardize")

  chart@config_opts <- merge_opts(
    chart@config_opts,
    list(showOutliers = outliers, standardizeValues = standardize)
  )
  chart
}

#' Heat chart
#'
#' Draws a grid of cells, one per pair of `x` and `y` values, shaded by how
#' many rows fall into each.
#'
#' @inheritParams arc_chart
#' @param x,y Defines which columns form the grid.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), island = c("x", "y", "x"))
#'
#' arc_heat(df, species, island)
#' @export
arc_heat <- function(.data, x, y) {
  arc_chart(.data) |> set_type("heat") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Line chart
#'
#' Joins one point per row in `x` order. Use [set_stat()] to aggregate `y`
#' first.
#'
#' @inheritParams arc_col
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(year = c(2020, 2021, 2022), mass = c(1, 5, 3))
#'
#' arc_line(df, year, mass)
#' @export
arc_line <- function(.data, x, y, position = NULL) {
  chart <- arc_chart(.data) |>
    set_type("line") |>
    set_x({{ x }}) |>
    set_y({{ y }})
  chart_positioned(chart, position)
}

#' Radar chart
#'
#' Draws a line chart on a circular axis, so the first and last `x` values
#' meet. Aggregates and groups exactly as [arc_line()] does.
#'
#' @inheritParams arc_col
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(month = c("jan", "feb", "mar"), rain = c(1, 5, 3))
#'
#' arc_radar(df, month, rain)
#' @export
arc_radar <- function(.data, x, y) {
  arc_chart(.data) |> set_type("radar") |> set_x({{ x }}) |> set_y({{ y }})
}

#' Pie chart
#'
#' Draws one slice per value of `x`, sized by how many rows fall into it. Use
#' [set_stat()] for any other aggregation, or `y` for values you have already
#' summarised.
#'
#' `set_pie()` reaches the same options later, for charts built with
#' [set_type()] rather than this shortcut.
#'
#' @inheritParams arc_chart
#' @param chart Defines which chart to modify.
#' @param x Defines which column the slices are cut from.
#' @param y default `NULL`. Defines which column sizes each slice. Omit it to
#'   count rows instead.
#' @param ... These dots are for future extensions and must be empty.
#' @param hole default `NULL`. Defines the size of the hole in the middle as
#'   a percentage of the radius, turning the pie into a doughnut.
#' @param labels default `NULL`. Defines what each slice's label shows, any
#'   of `"category"`, `"value"`, and `"percent"`.
#' @param inside default `NULL`. Defines whether the labels sit inside the
#'   slices.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))
#'
#' arc_pie(df, species, hole = 60)
#' @export
arc_pie <- function(
  .data,
  x,
  y = NULL,
  hole = NULL,
  labels = NULL,
  inside = NULL
) {
  y <- rlang::enquo(y)
  chart <- arc_chart(.data) |> set_type("pie") |> set_x({{ x }})
  chart <- if (rlang::quo_is_null(y)) {
    set_stat(chart, "count")
  } else {
    set_y(chart, !!y)
  }
  set_pie(chart, hole = hole, labels = labels, inside = inside)
}

#' @rdname arc_pie
#' @export
set_pie <- function(chart, ..., hole = NULL, labels = NULL, inside = NULL) {
  rlang::check_dots_empty()
  check_chart_type_set(chart)
  check_chart_type_is(chart, "pie")
  check_axis_flag(inside, "inside")

  opts <- list(innerRadius = hole, dataLabelsInside = inside)
  if (!rlang::is_null(labels)) {
    labels <- rlang::arg_match(labels, names(pie_label_map), multiple = TRUE)
    # Naming one part means the others are off, so all three go over.
    shown <- as.list(names(pie_label_map) %in% labels)
    names(shown) <- unname(pie_label_map)
    opts <- c(opts, shown)
  }

  chart@series_opts <- merge_opts(chart@series_opts, opts)
  chart
}

#' Gauge
#'
#' Draws a single number on a dial. A gauge reads one value, so `x` names the
#' column it comes from and [set_stat()] decides how the column is reduced to
#' that value - or `feature` picks one row verbatim.
#'
#' `set_gauge()` reaches the same options later, for charts built with
#' [set_type()] rather than this shortcut.
#'
#' @inheritParams arc_chart
#' @param chart Defines which chart to modify.
#' @param x Defines which numeric column the reading comes from.
#' @param stat default `"mean"`. Defines how the column is reduced to one
#'   value. See [set_stat()].
#' @param ... These dots are for future extensions and must be empty.
#' @param feature default `NULL`. Defines which row to read verbatim, by
#'   position. Setting it overrides `stat`.
#' @param hole default `NULL`. Defines the size of the hole in the middle as
#'   a percentage of the radius.
#' @param angles default `NULL`. Defines the dial's start and end angle in
#'   degrees, as `c(start, end)`.
#' @param needle default `NULL`. Defines whether the needle is drawn.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(mass = c(1, 5, 3))
#'
#' arc_gauge(df, mass, stat = "mean")
#' @export
arc_gauge <- function(
  .data,
  x,
  stat = "mean",
  feature = NULL,
  hole = NULL,
  angles = NULL,
  needle = NULL
) {
  chart <- arc_chart(.data) |> set_type("gauge") |> set_x({{ x }})
  if (rlang::is_null(feature)) {
    chart <- set_stat(chart, stat)
  }
  set_gauge(
    chart,
    feature = feature,
    hole = hole,
    angles = angles,
    needle = needle
  )
}

#' @rdname arc_gauge
#' @export
set_gauge <- function(
  chart,
  ...,
  feature = NULL,
  hole = NULL,
  angles = NULL,
  needle = NULL
) {
  rlang::check_dots_empty()
  check_chart_type_set(chart)
  check_chart_type_is(chart, "gauge")
  check_axis_flag(needle, "needle")
  check_angles(angles)

  config <- list(innerRadius = hole)
  if (!rlang::is_null(angles)) {
    config$startAngle <- angles[[1]]
    config$endAngle <- angles[[2]]
  }
  if (!rlang::is_null(feature)) {
    check_feature(feature)
    # R counts rows from one, the spec indexes features from zero.
    chart@series_opts <- merge_opts(
      chart@series_opts,
      list(featureIndex = as.double(feature) - 1)
    )
    chart@stat <- NA_character_
    config$subType <- GaugeChartSubTypes("featureGauge")
  }
  if (!rlang::is_null(needle)) {
    chart@axes$x <- merge_opts(
      chart@axes$x,
      list(needle = WebChartNeedle(type = "gaugeNeedle", visible = needle))
    )
  }

  chart@config_opts <- merge_opts(chart@config_opts, config)
  chart
}

check_feature <- function(feature, call = rlang::caller_env()) {
  if (
    (rlang::is_scalar_double(feature) || rlang::is_scalar_integer(feature)) &&
      feature >= 1 &&
      feature == round(feature)
  ) {
    return(invisible(feature))
  }
  cli::cli_abort(
    c(
      "{.arg feature} must be a single row number, counting from 1.",
      "x" = "You supplied {.obj_type_friendly {feature}}."
    ),
    call = call
  )
}

check_angles <- function(angles, call = rlang::caller_env()) {
  if (rlang::is_null(angles) || (is.numeric(angles) && length(angles) == 2)) {
    return(invisible(angles))
  }
  cli::cli_abort(
    c(
      "{.arg angles} must be two numbers, {.code c(start, end)}.",
      "x" = "You supplied {.obj_type_friendly {angles}}."
    ),
    call = call
  )
}
