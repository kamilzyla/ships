library(shiny)
library(data.table)

cols <- c(
  "SHIP_ID" = "factor",
  "SHIPNAME" = "factor",
  "ship_type" = "factor",
  "DATETIME" = "character",
  "LAT" = "numeric",
  "LON" = "numeric"
)
rename <- c("id", "name", "type", "datetime", "lat", "lon")
ships <- fread(file = "ships.csv", select = cols, col.names = rename)

vessel_types <- levels(ships$type)

ui <- fluidPage(
  selectInput("vesselType", "Vessel type", vessel_types),
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
