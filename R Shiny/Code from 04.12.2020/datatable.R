#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Cars Dataset, im starting to get this"),
   
   tableOutput("table1"))

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   data("mtcars")
  output$table1=renderTable(mtcars)
}

# Run the application 
shinyApp(ui = ui, server = server)

