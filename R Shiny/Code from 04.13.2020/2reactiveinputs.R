#Reactivity Lecture #2 - 04.13.2020
library(shiny)
library(ggplot2)
data("mtcars")

colChoices=colnames(mtcars)
cylinderChoices = unique(mtcars$cyl)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  selectInput("colSelector",label="Select a column:",choices=colChoices),
  selectInput("cylSelector",label="Select a cylinder",choices=cylinderChoices),
  plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
     filter = reactive({
                    filteredData=mtcars[mtcars$cyl==input$cylSelector,] 
                    return(filteredData)
                    })
     
     output$p1=renderPlot({
     ggplot(data=filter(),aes_string(x="mpg",y=input$colSelector))+geom_point()
   })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

