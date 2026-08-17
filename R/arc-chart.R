#' @include types-line-chart.R
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
    axes = class_list,
    flipped = s7x::class_boolean,
    webchart = S7::new_property(getter = function(self) build_webchart(self))
  )
)

# friendly kebab/plain type name -> {model_type (ModelTypes value, used to
# build the client-side defaults), series_type (the series' own `type`
# discriminator), series_class (which WebChart*Series S7 class to build),
# aggregates (whether the series honours `stat` at all), symbol_* (the symbol
# a chartRenderer carries for this chart type - see color_renderer())}
chart_type_map <- list(
  bar = list(
    model_type = "barChart",
    series_type = "barSeries",
    series_class = WebChartBarChartSeries,
    aggregates = TRUE,
    symbol_class = ISimpleFillSymbol,
    symbol_type = "esriSFS",
    symbol_style = SimpleFillSymbolStyle("esriSFSSolid")
  ),
  scatter = list(
    model_type = "scatterplot",
    series_type = "scatterSeries",
    series_class = WebChartScatterplotSeries,
    aggregates = FALSE,
    symbol_class = ISimpleMarkerSymbol,
    symbol_type = "esriSMS",
    symbol_style = SimpleMarkerSymbolStyle("esriSMSCircle")
  ),
  line = list(
    model_type = "lineChart",
    series_type = "lineSeries",
    series_class = WebChartLineChartSeries,
    aggregates = TRUE,
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
#'   `"scatter"`, or `"line"`.
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
series_aggregation <- function(chart, stat, call = rlang::caller_env()) {
  if (identical(stat, "count")) {
    on_field <- oid_field
  } else {
    if (is.na(chart@y)) {
      cli::cli_abort(
        c(
          "{.fn set_y} is required when {.arg stat} is {.val {stat}}.",
          "i" = "{.val count} is the only stat that needs no {.arg y}."
        ),
        call = call
      )
    }
    on_field <- chart@y
  }
  out_field <- toupper(sprintf("%s_%s_0", stat_map[[stat]], on_field))

  list(
    y = out_field,
    query = WebChartSeriesQuery(
      # I() keeps the spec's string[] - auto_unbox would emit a bare string.
      groupByFieldsForStatistics = I(chart@x),
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
chart_axis <- function(text, opts) {
  args <- opts
  title <- axis_title(text)
  if (!rlang::is_null(title)) {
    args$title <- title
  }
  rlang::exec(WebChartAxis, !!!args)
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

#' Map a column to colour
#'
#' Colours each mark by the value of a column. A numeric column becomes a
#' continuous gradient and a character or factor column gets one colour per
#' distinct value.
#'
#' @param chart Defines which chart to modify.
#' @param color Defines which column the colours are drawn from.
#' @param palette default `NULL`. Defines which colours to use, either the
#'   name of an Esri ramp such as `"Blue 3"` or a vector of R colours. `NULL`
#'   uses the ramp the ArcGIS SDK itself defaults to.
#' @return `chart`, with its colour mapping set.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass) |>
#'   set_color(mass, palette = "Red 1")
#' @export
set_color <- function(chart, color, palette = NULL) {
  check_chart_type_set(chart)
  col <- rlang::as_string(rlang::ensym(color))
  check_column(chart, col, "color")

  # Resolved here, not at render, so a bad palette blames this call. NULL
  # means "whichever default suits the column's type".
  stops <- if (rlang::is_null(palette)) {
    NULL
  } else {
    palette_stops(palette, call = rlang::caller_env())
  }

  chart@color <- list(field = col, stops = stops)
  chart
}

# Mirrors the SDK's own class-break symbols (class-breaks.js:414).
renderer_symbol <- function(spec, color = NULL) {
  args <- list(
    type = spec$symbol_type,
    style = spec$symbol_style,
    outline = ISimpleLineSymbol(
      type = "esriSLS",
      style = SimpleLineSymbolStyle("esriSLSSolid"),
      color = Color(r = 50, g = 50, b = 50, a = 255),
      width = 0.5
    )
  )
  if (identical(spec$symbol_type, "esriSMS")) {
    args$size <- 6
  }
  # A line symbol has no outline of its own.
  if (identical(spec$symbol_type, "esriSLS")) {
    args$outline <- NULL
    args$width <- 2
  }
  if (!rlang::is_null(color)) {
    args$color <- color
  }
  rlang::exec(spec$symbol_class, !!!args)
}

# The client interpolates between stops (index2.js:1612), so the ramp's own
# stops go over untouched, spread across the column's range.
continuous_renderer <- function(field, values, stops, spec, call) {
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

  # A constant column can't span a gradient; colour it with the ramp's end.
  if (rng[[1]] == rng[[2]]) {
    return(ISimpleRenderer(
      type = "simple",
      symbol = renderer_symbol(spec, rgba_color(stops[nrow(stops), ]))
    ))
  }

  # as.double(): seq() returns an integer vector for integer endpoints.
  at <- as.double(seq(rng[[1]], rng[[2]], length.out = nrow(stops)))
  ISimpleRenderer(
    type = "simple",
    symbol = renderer_symbol(spec),
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

# Under aggregation the query returns only the group-by field and the
# statistics, so a derived code column never comes back - but the grouped
# column itself does, and uniqueValue resolves against it (index2.js:1436).
unique_value_renderer <- function(field, levels, colors, spec) {
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
          symbol = renderer_symbol(spec, color)
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

  colors <- discrete_colors(stops, length(levels))

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
    return(unique_value_renderer(field, levels, colors, spec))
  }

  ISimpleRenderer(
    type = "simple",
    symbol = renderer_symbol(spec),
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

# Numeric -> gradient, everything else -> one colour per value, the same split
# ggplot2 makes between continuous and discrete scales.
color_renderer <- function(chart, spec, call = rlang::caller_env()) {
  color <- chart@color
  if (rlang::is_empty(color)) {
    return(NULL)
  }

  values <- chart@data[[color$field]]
  if (is.numeric(values)) {
    return(continuous_renderer(color$field, values, color$stops, spec, call))
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
  if (is.numeric(values) || chart_aggregates(chart)) {
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

  agg <- if (aggregating) {
    series_aggregation(chart, stat)
  } else {
    list(y = chart@y, query = NULL)
  }

  y_label <- if (!aggregating) {
    chart@y
  } else if (identical(stat, "count")) {
    "count"
  } else {
    sprintf("%s(%s)", stat, chart@y)
  }

  labs <- chart@labs
  axis_lab <- function(lab, mapped) if (rlang::is_null(lab)) mapped else lab

  renderer <- color_renderer(chart, spec)

  WebChart(
    version = "25.1.0",
    type = "chart",
    title = chart_titled(labs$title),
    subtitle = chart_titled(labs$subtitle),
    footer = chart_titled(labs$caption),
    chartRenderer = renderer,
    colorMatch = if (rlang::is_null(renderer)) NA else TRUE,
    rotated = chart@flipped,
    axes = list(
      chart_axis(axis_lab(labs$x, chart@x), chart@axes$x),
      chart_axis(axis_lab(labs$y, y_label), chart@axes$y)
    ),
    series = list(
      spec$series_class(
        type = spec$series_type,
        id = "series1",
        name = "series1",
        x = chart@x,
        y = agg$y,
        query = agg$query
      )
    )
  )
}

#' Bar chart
#'
#' Counts rows per `x`. Use [arc_col()] for values you have already summarised
#' or [set_stat()] for any other aggregation.
#'
#' @inheritParams arc_chart
#' @param x Defines which column the bars are grouped by.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "a", "b"), mass = c(1, 5, 3))
#'
#' arc_bar(df, species)
#' @export
arc_bar <- function(.data, x) {
  arc_chart(.data) |> set_type("bar") |> set_x({{ x }}) |> set_stat("count")
}

#' Column chart
#'
#' Plots `y` verbatim, one bar per row. Use [arc_bar()] to count rows instead.
#'
#' @inheritParams arc_chart
#' @param x,y Defines which columns supply the bar positions and heights.
#' @return An `ArcChart`.
#' @examples
#' df <- data.frame(species = c("a", "b", "c"), mass = c(1, 5, 3))
#'
#' arc_col(df, species, mass)
#' @export
arc_col <- function(.data, x, y) {
  arc_chart(.data) |> set_type("bar") |> set_x({{ x }}) |> set_y({{ y }})
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
arc_line <- function(.data, x, y) {
  arc_chart(.data) |> set_type("line") |> set_x({{ x }}) |> set_y({{ y }})
}
