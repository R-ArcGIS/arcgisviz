library(arcgisviz)
library(dplyr)

aq <- airquality[complete.cases(airquality), ]
features <- c("Solar.R", "Wind", "Temp", "Month")

set.seed(123)
model <- xgboost::xgboost(
  x = aq[features],
  y = aq$Ozone,
  nround = 20,
  verbosity = 0
)

# Every row is explained, the training rows included.
explanation <- shapr::explain(
  model = model,
  x_explain = aq[features],
  x_train = aq[features],
  approach = "empirical",
  phi0 = mean(aq$Ozone),
  seed = 1
)

shap <- explanation$shapley_values_est |>
  as_tibble() |>
  mutate(month = month.name[aq$Month[explain_id]]) |>
  tidyr::pivot_longer(
    all_of(features),
    names_to = "feature",
    values_to = "shap"
  ) |>
  mutate(impact = abs(shap))

# One radial scale for every month, so the shapes can be compared.
top <- shap |>
  summarise(impact = mean(impact), .by = c(month, feature)) |>
  pull(impact) |>
  max() |>
  ceiling()

month_colors <- c(
  May = "#8e44ad",
  June = "#45a29e",
  July = "#e09f3e",
  August = "#5b7aa8",
  September = "#6ab04c"
)

# Colouring by month makes the month the series, so it takes that colour.
month_radar <- function(name) {
  shap |>
    filter(month == name) |>
    arc_radar(feature, impact, area = TRUE, point_size = 8) |>
    set_stat("mean") |>
    set_color(month, palette = month_colors[[name]]) |>
    set_axis("y", limits = c(0, top)) |>
    set_labs(title = name) |>
    as_widget(width = "100%", height = "320px")
}

htmltools::browsable(
  htmltools::div(
    style = "display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.2rem;",
    lapply(names(month_colors), month_radar)
  )
)

# The same months layered on one radar. A factor keeps them in calendar order.
shap |>
  mutate(month = factor(month, levels = names(month_colors))) |>
  arc_radar(feature, impact, area = TRUE, point_size = 8) |>
  set_stat("mean") |>
  set_color(month, palette = unname(month_colors)) |>
  set_axis("y", limits = c(0, top)) |>
  set_legend(title = "Month", position = "bottom") |>
  set_labs(title = "Airquality Model", subtitle = "Average SHAP value by month")
