# arc_proxy() updates a chart that is already rendered, without resending
# the data, and the chart reports back what the reader did to it.
devtools::load_all()
library(shiny)


ui <- fluidPage(
  titlePanel("arcgisviz in Shiny"),
  sidebarLayout(
    sidebarPanel(
      selectInput("x", "Group by", c("species", "island", "sex")),
      selectInput("stat", "Statistic", c("count", "mean", "max")),
      selectInput("position", "Position", c("dodge", "stack", "fill")),
      checkboxInput("flipped", "Flip axes"),
      textInput("where", "Filter", placeholder = "body_mass > 4000"),
      actionButton("png", "Download PNG")
    ),
    mainPanel(
      arcgisChartOutput("chart", height = "420px"),
      h4("Selection"),
      verbatimTextOutput("selection")
    )
  )
)

server <- function(input, output, session) {
  # Rendered once. Everything after this goes through the proxy, so the
  # penguins data crosses the wire exactly one time.
  output$chart <- renderArcgisChart({
    arc_bar(penguins, species) |>
      set_stat("count") |>
      set_color(island) |>
      as_widget()
  })

  chart <- reactive({
    arc_bar(penguins, !!rlang::sym(input$x)) |>
      set_y(body_mass) |>
      set_stat(input$stat) |>
      set_color(island) |>
      set_position(input$position) |>
      set_flipped(input$flipped)
  })

  # One message per flush, however many set_*() calls went into it.
  observeEvent(chart(), {
    arc_proxy("chart", chart()) |> arc_update()
  })

  # A filter never rebuilds the model - the chart requeries what it holds.
  observeEvent(input$where, {
    arc_proxy("chart", chart()) |>
      set_filter(input$where)
  })

  observeEvent(input$png, {
    arc_proxy("chart", chart()) |> arc_export_image("png")
  })

  # Click or brush the chart and the object ids arrive here.
  output$selection <- renderPrint(input$chart_selection)
}

shinyApp(ui, server)
