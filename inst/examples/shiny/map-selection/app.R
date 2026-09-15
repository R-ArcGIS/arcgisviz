# A map selection is a set that lives in the browser and is reported back to
# R. Three things put features into it - a click, a drawn shape, and R itself
# - and all three land in the same input$<output_id>$selection.
#
#   shiny::runApp(system.file("examples/shiny/map-selection", package = "arcgisviz"))
#
# The set is the view's own SelectionManager, so it is highlighted for you and
# survives whichever route wrote to it. set_highlight() styles it once, for
# all three.
library(arcgisviz)
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
        calcite_button(
          id = "circle",
          "Drag a circle",
          icon_start = "circle",
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
          id = "invert",
          "Invert",
          icon_start = "refresh",
          width = "full",
          appearance = "outline"
        ),
        calcite_button(
          id = "clear",
          "Clear",
          icon_start = "x",
          width = "full",
          appearance = "outline"
        )
      ),

      calcite_block(
        heading = "Highlight style",
        collapsible = TRUE,
        icon_start = "paint-bucket",
        calcite_label(
          "Colour",
          calcite_select(
            id = "highlight",
            values = c("#00c5ff", "#ffd200", "#ff4d4d"),
            labels = c("Cyan", "Yellow", "Red")
          )
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
      ),
      calcite_block(
        heading = "Total births, 1974",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "sum",
        verbatimTextOutput("total")
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
  # set_highlight() styles that selection wherever it came from.
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
      add_legend(position = "bottom-left") |>
      set_highlight(color = "#00c5ff", fill_opacity = 0.35) |>
      as_widget()
  })

  mode <- reactive(if (isTRUE(input$add$checked)) "add" else "replace")

  # Each of these hands the reader a drawing tool. Whatever the shape covers
  # becomes the selection.
  observeEvent(
    input$rectangle$clicks,
    arc_map_proxy("map") |>
      arc_draw_selection(tool = "rectangle", mode = mode()),
    ignoreInit = TRUE
  )

  # A lasso is the polygon tool drawn freehand - one friendly name over two
  # spec properties.
  observeEvent(
    input$lasso$clicks,
    arc_map_proxy("map") |> arc_draw_selection(tool = "lasso", mode = mode()),
    ignoreInit = TRUE
  )

  observeEvent(
    input$circle$clicks,
    arc_map_proxy("map") |> arc_draw_selection(tool = "circle", mode = mode()),
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

  # "toggle" is available to R too, not only to a click.
  observeEvent(
    input$invert$clicks,
    arc_map_proxy("map") |>
      set_selection(seq_len(nrow(nc)), mode = "toggle"),
    ignoreInit = TRUE
  )

  observeEvent(
    input$clear$clicks,
    arc_map_proxy("map") |> set_selection(integer()),
    ignoreInit = TRUE
  )

  # The highlight is a named style on the view, so restyling it repaints
  # whatever is already selected.
  observeEvent(input$highlight$value, {
    arc_map_proxy("map") |>
      set_highlight(color = input$highlight$value, fill_opacity = 0.35) |>
      arc_update()
  })

  # Every one of the routes above arrives here. arc_selected() pulls the
  # object ids out of the event for one layer.
  selected <- reactive(arc_selected(input$map$selection, layer = "Counties"))

  output$selected <- renderTable({
    ids <- selected()
    if (!length(ids)) {
      return(NULL)
    }
    st_drop_geometry(nc[ids, c("NAME", "BIR74", "SID74")])
  })

  output$total <- renderPrint({
    ids <- selected()
    if (!length(ids)) {
      return(cat("Nothing selected.\n"))
    }
    cat(length(ids), "counties,", sum(nc$BIR74[ids]), "births\n")
  })
}

shinyApp(ui, server)
