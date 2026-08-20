# Extracts the Esri smart-mapping colour ramps into R/sysdata.rda.
#
# Source: node_modules/@arcgis/core/smartMapping/symbology/support/colors.js -
# the module @arcgis/charts-components resolves its ramps from, via
# smartMapping/symbology/support/colorRamps.js. Every single-part ramp carries
# a `stops`/`tags`/`name` triple in that order (521 of them, all names
# unique). The 33 multipart "relationship-*" ramps have no `stops` key at all,
# so they drop out on their own - the same ones colorRamps.all() skips.
#
# Run: R -q -f data-raw/color-palettes.R

js_path <- "node_modules/@arcgis/core/smartMapping/symbology/support/colors.js"
js <- readChar(js_path, file.size(js_path), useBytes = TRUE)

blocks <- regmatches(
  js,
  gregexpr('stops:\\[[^]]*\\],tags:\\[[^]]*\\],name:"[^"]*"', js)
)[[1]]

if (length(blocks) == 0L) {
  stop("no ramps matched - has colors.js changed shape?")
}

# The quoted strings inside one `key:[...]` section of a block.
section_values <- function(block, key) {
  section <- regmatches(block, regexpr(paste0(key, ":\\[[^]]*\\]"), block))
  values <- regmatches(section, gregexpr('"[^"]*"', section))[[1]]
  substr(values, 2L, nchar(values) - 1L)
}

# Stops come as "#rrggbb", "rgb(r, g, b)", or "rgba(r, g, b, a)" - the alpha
# is 0-1 in the last form only.
parse_stop <- function(x) {
  if (startsWith(x, "#")) {
    return(c(as.integer(grDevices::col2rgb(x)), 255L))
  }
  parts <- as.numeric(strsplit(gsub("rgba?\\(|\\)", "", x), ",")[[1]])
  alpha <- if (length(parts) == 4L) round(parts[[4]] * 255) else 255
  c(as.integer(parts[1:3]), as.integer(alpha))
}

esri_color_ramps <- lapply(blocks, function(block) {
  list(
    tags = section_values(block, "tags"),
    stops = do.call(rbind, lapply(section_values(block, "stops"), parse_stop))
  )
})

ramp_names <- regmatches(blocks, regexpr('name:"[^"]*"$', blocks))
names(esri_color_ramps) <- substr(ramp_names, 7L, nchar(ramp_names) - 1L)

if (anyDuplicated(names(esri_color_ramps))) {
  stop("duplicate ramp names")
}

# The default series palette, for discrete colour: ColorBrewer Paired-10, from
# `ee` at @arcgis/charts-components/dist/chunks/index.js:45. `y()` (:93) cycles
# it with `colorIndex % length`, which is what we reproduce with `%%`.
esri_series_palette <- matrix(
  c(
    31,
    120,
    180,
    255,
    166,
    206,
    227,
    255,
    51,
    160,
    44,
    255,
    178,
    223,
    138,
    255,
    227,
    26,
    28,
    255,
    251,
    154,
    153,
    255,
    255,
    127,
    0,
    255,
    253,
    191,
    111,
    255,
    106,
    61,
    154,
    255,
    202,
    178,
    214,
    255
  ),
  ncol = 4L,
  byrow = TRUE,
  dimnames = list(NULL, c("r", "g", "b", "a"))
)

# The SDK's own continuous default: defaultColorRampForCharts, which is
# colorRamps.byName("Blue 3") (dist/chunks/class-breaks.js:475).
esri_default_ramp <- "Blue 3"

if (!esri_default_ramp %in% names(esri_color_ramps)) {
  stop("the default ramp is missing from the catalogue")
}

usethis::use_data(
  esri_color_ramps,
  esri_series_palette,
  esri_default_ramp,
  internal = TRUE,
  overwrite = TRUE
)
