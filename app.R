library(shiny)
library(leaflet)
library(data.table)

ships <- fread(
  file = "ships.csv",
  select = c(
    "SHIP_ID" = "factor",
    "SHIPNAME" = "factor",
    "ship_type" = "factor",
    "DATETIME" = "character",
    "LAT" = "numeric",
    "LON" = "numeric"
  ),
  col.names = c("id", "name", "type", "datetime", "lat", "lon")
)

vesselInput <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("type"), "Vessel type", levels(ships$type)),
    selectInput(ns("name"), "Vessel name", levels(ships$name))
  )
}

vessel <- function(input, output, session) {
  reactive({
    paste(input$type, input$name)
  })
}

ui <- fluidPage(
  titlePanel('Vessel App'),
  sidebarLayout(
    sidebarPanel(
      vesselInput('vessel')
    ),
    mainPanel(
      leafletOutput("map"),
      textOutput("text")
    )
  )
)

server <- function(input, output) {
  vesselId <- callModule(vessel, 'vessel')
  output$text <- renderText({
    vesselId()
  })
  output$map <- renderLeaflet({
    leaflet() %>% addProviderTiles(providers$OpenStreetMap.Mapnik)
  })
}

shinyApp(ui, server)
