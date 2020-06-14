library(shiny)
library(leaflet)

source("loadShips.R")

vesselInput <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("type"), "Vessel type", NULL),
    selectInput(ns("name"), "Vessel name", NULL)
  )
}

vessel <- function(input, output, session, vessels) {
  observeEvent(input$type, {
    updateSelectInput(session, "type", choices = levels(vessels$type))
  }, once = TRUE)
  observeEvent(input$type, {
    choices <- vessels %>% filter(type == input$type) %>% select(name)
    updateSelectInput(session, "name", choices = choices)
  }, ignoreInit = TRUE)
  row <- reactive({
    vessels %>% filter(type == input$type, name == input$name)
  })
  return(row)
}

ui <- fluidPage(
  titlePanel('Vessel App'),
  sidebarLayout(
    sidebarPanel(
      vesselInput('vessel')
    ),
    mainPanel(
      leafletOutput("map"),
      "Longest distance between observations: ",
      textOutput("dist", inline = TRUE), "m."
    )
  )
)

server <- function(input, output) {
  vesselRow <- callModule(vessel, 'vessel', ships)
  output$dist <- renderText({
    vesselRow()$dist
  })
  output$map <- renderLeaflet({
    r <- vesselRow()
    opt <- labelOptions(textOnly = TRUE, noHide = TRUE)
    leaflet() %>% addTiles() %>%
      addMarkers(lat = r$lat1, lng = r$lon1, label = "Start", labelOptions = opt) %>%
      addMarkers(lat = r$lat2, lng = r$lon2, label = "End", labelOptions = opt)
  })
}

shinyApp(ui, server)
