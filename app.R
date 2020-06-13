library(shiny)
library(leaflet)

source("loadShips.R")

vesselInput <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("type"), "Vessel type", levels(ships$type)),
    selectInput(ns("name"), "Vessel name", NULL)
  )
}

vessel <- function(input, output, session) {
  observeEvent(input$type, {
    choices = ships %>% filter(type == input$type) %>% select(name)
    updateSelectInput(session, "name", choices = choices)
  })
  reactive({
    c(type = input$type, name = input$name)
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
      "Longest distance between observations: ",
      textOutput("text", inline = TRUE)
    )
  )
)

server <- function(input, output) {
  v <- callModule(vessel, 'vessel')
  output$text <- renderText({
    v <- v()
    filter(ships, type == v[['type']], name == v[['name']])$dist
  })
  output$map <- renderLeaflet({
    leaflet() %>% addProviderTiles(providers$OpenStreetMap.Mapnik)
  })
}

shinyApp(ui, server)
