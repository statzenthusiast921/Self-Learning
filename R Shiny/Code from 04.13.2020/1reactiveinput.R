#Reactivity Lecture - 04.13.2020
library(shiny)
library(ggplot2)
data("mtcars")

colChoices=colnames(mtcars)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  selectInput(inputId = "colSelector",label="Select a column:",choices=colChoices),
  plotOutput("p1")
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   output$p1=renderPlot({
     ggplot(data=mtcars,aes_string(x="mpg",y=input$colSelector))+geom_point()
   })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

