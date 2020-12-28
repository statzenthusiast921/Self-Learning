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
   titlePanel("Title, I Don't Fucking Know"),
   
   verbatimTextOutput("text1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$text1=renderText(paste("This is", "sample text.",sep="\n"))
}

# Run the application 
shinyApp(ui = ui, server = server)

