# arc_map_proxy() updates a map that is already rendered, without resending
# the features, and the map reports back what the reader did to it.
# The UI is {calcite}, so the controls match the map they drive.
devtools::load_all()
library(sf)
library(shiny)
library(calcite)

nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
nc$region <- ifelse(st_coordinates(st_centroid(nc))[, 1] > -80, "East", "West")

# page_sidebar() only takes one panel, so the shell is built directly to get
# controls on the left and the readouts on the right.
ui <- calcite_shell(
  header = calcite_navigation(
    calcite_navigation_logo(slot = "logo", heading = "arcgisviz maps in Shiny")
  ),

  panel_start = calcite_shell_panel(
    width = "m",
    calcite_panel(
      heading = "Map controls",
      description = "Every change here goes over the proxy",

      calcite_block(
        heading = "Basemap",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "basemap",
        calcite_select(
          id = "basemap",
          label = "Basemap",
          values = c("topo-vector", "satellite", "oceans"),
          labels = c("Topographic", "Satellite", "Oceans")
        )
      ),

      calcite_block(
        heading = "Filter",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "filter",
        calcite_slider(
          id = "births",
          label_text = "Minimum births, 1974",
          value = 0,
          min = 0,
          max = 22000,
          step = 500,
          ticks = 5500,
          label_handles = TRUE
        )
      ),

      calcite_block(
        heading = "Layers",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "layers",
        calcite_label(
          layout = "inline",
          calcite_switch(id = "seats"),
          "Show county seats"
        )
      ),

      calcite_block(
        heading = "Highlight",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "selection",
        calcite_label(
          "Region",
          calcite_segmented_control(
            id = "region",
            width = "full",
            calcite_segmented_control_item(
              value = "None",
              label = "None",
              checked = TRUE
            ),
            calcite_segmented_control_item(value = "East", label = "East"),
            calcite_segmented_control_item(value = "West", label = "West")
          )
        ),
        calcite_button(
          id = "goto",
          "Zoom to Raleigh",
          icon_start = "zoom-to-object",
          width = "full"
        )
      )
    )
  ),

  panel_end = calcite_shell_panel(
    width = "m",
    calcite_panel(
      heading = "What the reader did",
      description = "Both blocks are driven by the map, not by the controls",

      calcite_block(
        heading = "Hover",
        description = "The feature under the pointer",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "cursor",
        verbatimTextOutput("hover")
      ),

      calcite_block(
        heading = "Click",
        description = "Where, and what was there",
        collapsible = TRUE,
        expanded = TRUE,
        icon_start = "pin",
        verbatimTextOutput("click")
      )
    )
  ),

  # The map is the shell's only main content, so it takes the whole column
  # between the two panels. calc() rather than 100% - a percentage height
  # inside calcite-panel's flex body has nothing to resolve against.
  calcite_panel(
    heading = "North Carolina counties",
    arcgisMapOutput("map", height = "calc(100vh - 9rem)")
  )
)

server <- function(input, output, session) {
  # Rendered once. Everything after this goes through the proxy, so the
  # counties cross the wire exactly one time.
  output$map <- renderArcgisMap({
    arc_map() |>
      add_layer(
        nc,
        color = BIR74,
        palette = "Orange 5",
        name = "Counties",
        tooltip = c(County = NAME, Births = BIR74, Region = region)
      ) |>
      as_widget()
  })

  # Every calcite input arrives as a list of the component's properties, so
  # the value wanted is always named: $value, $checked, $clicks.
  observeEvent(input$basemap$value, {
    arc_map_proxy("map") |>
      set_basemap(input$basemap$value) |>
      arc_update()
  })

  # A filter re-evaluates the layer's own definition expression in place -
  # no layer is rebuilt and nothing is resent.
  observeEvent(input$births$value, {
    arc_map_proxy("map") |>
      set_filter(paste("BIR74 >=", input$births$value), layer = "Counties")
  })

  # A layer added through a proxy must be named; adding it again under the
  # same name replaces it, and remove_layer() takes it back off.
  observeEvent(input$seats$checked, {
    proxy <- arc_map_proxy("map")
    if (isTRUE(input$seats$checked)) {
      proxy |>
        add_layer(
          st_centroid(nc),
          palette = "grey20",
          size = 6,
          name = "Seats",
          tooltip = c(County = NAME)
        ) |>
        arc_update()
    } else {
      remove_layer(proxy, "Seats")
    }
  })

  # set_selection() highlights by object id, which is what links a map to a
  # chart drawn from the same rows.
  observeEvent(input$region$value, {
    region <- input$region$value
    ids <- if (region == "None") integer() else which(nc$region == region)
    arc_map_proxy("map") |>
      set_selection(ids, layer = "Counties")
  })

  # A calcite button reports a running click count, and reports it once on
  # load too - hence ignoreInit.
  observeEvent(
    input$goto$clicks,
    {
      arc_map_proxy("map") |>
        arc_goto(center = c(-78.64, 35.78), zoom = 9, duration = 1200)
    },
    ignoreInit = TRUE
  )

  # Hovering a feature sends its attributes; the tooltip draws itself.
  output$hover <- renderPrint(input$map_hover)

  # A click reports where, and which feature if one was under the pointer.
  output$click <- renderPrint(input$map_click)
}

shinyApp(ui, server)
