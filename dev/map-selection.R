# A map selection is a set that lives in the browser and is reported back to
# R. Three things put features into it - a click, a drawn shape, and R itself
# - and all three land in the same `input$<id>_selection`.
devtools::load_all()
library(sf)
library(shiny)
library(calcite)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)

ui <- calcite_shell(
  header = calcite_navigation(
    calcite_navigation_logo(slot = "logo", heading = "Selecting on a map")
  ),

  panel_start = calcite_shell_panel(
    width = "m",
    calcite_panel(
      heading = "Selection tools",
      description = "Click a county, or draw a shape over several",

      calcite_block(
        heading = "Draw a shape",
        description = "The tool is live until the shape is finished",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "select-range",
        calcite_button(
          id = "rectangle",
          "Drag a box",
          icon_start = "rectangle",
          width = "full"
        ),
        calcite_button(
          id = "lasso",
          "Draw a lasso",
          icon_start = "freehand-area",
          width = "full",
          appearance = "outline"
        ),
        calcite_label(
          layout = "inline",
          calcite_switch(id = "add"),
          "Add to the selection instead of replacing it"
        )
      ),

      calcite_block(
        heading = "Select from R",
        description = "The same set, driven from the server",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "list-check",
        calcite_button(
          id = "busiest",
          "The ten busiest maternity wards",
          icon_start = "sort-descending",
          width = "full"
        ),
        calcite_button(
          id = "clear",
          "Clear",
          icon_start = "x",
          width = "full",
          appearance = "outline"
        )
      )
    )
  ),

  panel_end = calcite_shell_panel(
    width = "m",
    calcite_panel(
      heading = "What is selected",
      description = "Read back with arc_selected()",
      calcite_block(
        heading = "Counties",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "check-circle",
        tableOutput("selected")
      )
    )
  ),

  calcite_panel(
    heading = "North Carolina counties",
    arcgisMapOutput("map", height = "calc(100vh - 9rem)")
  )
)

server <- function(input, output, session) {
  # `selectable` is what makes a click toggle a feature into the selection.
  # set_highlight() styles that selection wherever it comes from.
  output$map <- renderArcgisMap({
    arc_map() |>
      add_layer(
        nc,
        color = BIR74,
        palette = "Orange 5",
        name = "Counties",
        selectable = TRUE,
        tooltip = c(County = NAME, Births = BIR74)
      ) |>
      set_highlight(color = "#00c5ff", fill_opacity = 0.35) |>
      as_widget()
  })

  mode <- reactive(if (isTRUE(input$add$checked)) "add" else "replace")

  observeEvent(
    input$rectangle$clicks,
    arc_map_proxy("map") |> arc_draw_selection(tool = "rectangle", mode = mode()),
    ignoreInit = TRUE
  )

  # A lasso is the polygon tool drawn freehand.
  observeEvent(
    input$lasso$clicks,
    arc_map_proxy("map") |> arc_draw_selection(tool = "lasso", mode = mode()),
    ignoreInit = TRUE
  )

  # Object ids are row numbers, which is what lets a chart and a map built
  # from the same data frame select each other's rows.
  observeEvent(
    input$busiest$clicks,
    arc_map_proxy("map") |>
      set_selection(order(nc$BIR74, decreasing = TRUE)[1:10]),
    ignoreInit = TRUE
  )

  observeEvent(
    input$clear$clicks,
    arc_map_proxy("map") |> set_selection(integer()),
    ignoreInit = TRUE
  )

  # Every one of the three routes above arrives here.
  output$selected <- renderTable({
    ids <- arc_selected(input$map_selection, layer = "Counties")
    if (!length(ids)) {
      return(NULL)
    }
    st_drop_geometry(nc[ids, c("NAME", "BIR74")])
  })
}

shinyApp(ui, server)
