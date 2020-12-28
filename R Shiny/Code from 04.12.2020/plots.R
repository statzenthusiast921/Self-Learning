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
   titlePanel("Plotting fuck yeah"),
   
 plotOutput("plot1")
)

# Define server logic required to draw a histogram
library(ggplot2)
server <- function(input, output) {
   data("mtcars")
  output$plot1=renderPlot({
    ggplot(data=mtcars,aes(x=mpg,y=hp))+geom_point()
  })

}

# Run the application 
shinyApp(ui = ui, server = server)

