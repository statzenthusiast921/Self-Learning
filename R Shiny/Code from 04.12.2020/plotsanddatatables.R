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
   titlePanel("More Car Shit"),
   DTOutput("dt1"),
   plotOutput("pt1")
)

# Define server logic required to draw a histogram
#install.packages("DT")
library(DT)
server <- function(input, output) {
   
  data("mtcars")
  mtcars$cyl=as.factor(mtcars$cyl)
  
  output$dt1=renderDT({
    datatable(mtcars,options=list(pageLength=5,
                                  lengthMenu=c(5,10,15,20)
                                  ))
  })
  output$pt1=renderPlot({
    ggplot(data=mtcars,aes(x=wt,y=mpg,color=cyl))+geom_point()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

