# Spike: does the charts engine honour a `simple` renderer's colorInfo visual
# variable, or only uniqueValue/classBreaks? Render one chart at a time in the
# Viewer. Delete this file once the question is settled.
devtools::load_all()

penguins <- na.omit(
  datasets::penguins[c("species", "bill_len", "bill_dep", "body_mass")]
)

# "Blue 3", the SDK's defaultColorRampForCharts (dist/chunks/class-breaks.js:475)
blue3 <- list(
  c(239, 243, 255),
  c(189, 215, 231),
  c(107, 174, 214),
  c(49, 130, 189),
  c(8, 81, 156)
)

# Paired-10, the default series palette (dist/chunks/index.js:45)
paired <- list(c(31, 120, 180), c(166, 206, 227), c(51, 160, 44))

esri_sms <- function(rgb) {
  list(
    type = "esriSMS",
    style = "esriSMSCircle",
    size = 6,
    color = c(rgb, 255),
    outline = list(
      type = "esriSLS",
      style = "esriSLSSolid",
      color = c(50, 50, 50, 255),
      width = 0.5
    )
  )
}

esri_sfs <- function(rgb) {
  list(
    type = "esriSFS",
    style = "esriSFSSolid",
    color = c(rgb, 255),
    outline = list(
      type = "esriSLS",
      style = "esriSLSSolid",
      color = c(50, 50, 50, 255),
      width = 0.5
    )
  )
}

color_stops <- function(values, colors) {
  Map(
    function(rgb, v) list(value = v, color = c(rgb, 255)),
    colors,
    seq(min(values), max(values), length.out = length(colors))
  )
}

with_renderer <- function(chart, renderer) {
  cfg <- s7x::as_vector(chart@webchart)
  cfg$colorMatch <- TRUE
  cfg$chartRenderer <- renderer
  arcgis_chart(
    i_layer = as_chart_layer(chart@data),
    chart_type = chart_type_map[[chart@chart_type]]$model_type,
    config = cfg
  )
}

# --- 1. continuous: simple renderer + colorInfo visual variable -------------
# The question. Jn() (dist/chunks/index2.js:1687) returns no renderer field
# names for `simple`, so the engine may never fetch body_mass at all - and
# getDisplayedSymbol() is called with no view options, which its own docs say
# are required when visual variables are applied.
vv_renderer <- list(
  type = "simple",
  symbol = esri_sms(c(150, 150, 150)),
  visualVariables = list(list(
    type = "colorInfo",
    field = "body_mass",
    stops = color_stops(penguins$body_mass, blue3)
  ))
)

with_renderer(arc_scatter(penguins, bill_len, bill_dep), vv_renderer)

# --- 1b. same, but force body_mass into the query --------------------------
# If 1 renders flat grey and this one gradients, the problem is field fetching
# rather than visual-variable support.
local({
  chart <- arc_scatter(penguins, bill_len, bill_dep)
  cfg <- s7x::as_vector(chart@webchart)
  cfg$colorMatch <- TRUE
  cfg$chartRenderer <- vv_renderer
  cfg$series[[1]]$additionalTooltipFields <- I("body_mass")
  arcgis_chart(
    i_layer = as_chart_layer(chart@data),
    chart_type = "scatterplot",
    config = cfg
  )
})

# --- 2. discrete: uniqueValue renderer -------------------------------------
# Expected to work - uniqueValue is one of the two types colorMatch handles
# (dist/chunks/index2.js:1436).
species <- as.character(sort(unique(penguins$species)))

uv_renderer <- list(
  type = "uniqueValue",
  field1 = "species",
  fieldDelimiter = ",",
  # unname(): Map() names its result from a character first argument, which
  # would serialize uniqueValueInfos as a JSON object instead of an array.
  uniqueValueInfos = unname(Map(
    function(value, rgb) {
      list(value = value, label = value, symbol = esri_sfs(rgb))
    },
    species,
    paired[seq_along(species)]
  ))
)

with_renderer(arc_bar(penguins, species), uv_renderer)
