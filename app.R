library(shiny)
library(dplyr)

source("doj.R")

return_doj <- function(input) {
  # Check if it is a postcode with exact matching only
  idx <- grepl(input, lookup$Postcode)
  if(!any(idx)) {
    # Check if it is a location using fuzzy matching
    idx <- agrepl(input, lookup$Locality)
  }
  return(lookup[which(idx),])
}

# Define UI for dataset viewer application
ui <- shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Department of Justice Regions"),

  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    textInput("location", "Locality or Postcode:", ""),
    width=5,
  ),
  # Show an HTML table with result
  mainPanel(tableOutput("view"), width=7)
))

# Define server logic required to summarize and view the selected dataset
server <- shinyServer(function(input, output) {

  # Return the requested dataset
  datasetInput <- reactive({
    if(input$location=="")
      NULL
    else
      return_doj(input$location)
  })

  # Show the data
  output$view <- renderTable({datasetInput()})
})

shinyApp(ui = ui, server = server)
