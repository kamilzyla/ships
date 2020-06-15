library(shiny)
library(leaflet)

source("readShips.R")
source("vesselInput.R")

ships <- readShips('data/ships.zip', 'data/ships.rds')

ui <- fluidPage(
  titlePanel("Marine data"),
  sidebarLayout(
    sidebarPanel(
      vesselInput("vessel")
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
