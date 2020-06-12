library(shiny)

ships <- read.csv("ships.csv")
vessel_types <- unique(sort(ships[["ship_type"]]))

ui <- fluidPage(
  selectInput("vesselType", "Vessel type", vessel_types),
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)