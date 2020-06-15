library(shiny)

vesselInput <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("type"), "Vessel type", NULL),
    selectInput(ns("name"), "Vessel name", NULL)
  )
}

vessel <- function(input, output, session, vessels) {
  group <- reactive({
    vessels %>% filter(type == input$type)
  })
  row <- reactive({
    group() %>% filter(name == input$name)
  })
  observeEvent(input$type, {
    updateSelectInput(session, "type", choices = levels(vessels$type))
  }, once = TRUE)
  observeEvent(input$type, {
    updateSelectInput(session, "name", choices = group()$name)
  }, ignoreInit = TRUE)
  return(row)
}
