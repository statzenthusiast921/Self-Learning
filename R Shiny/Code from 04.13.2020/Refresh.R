#Reactivity Lecture #3 - 04.13.2020
#Building an R Shiny Web App that allows you to select multiple criteria
#and then hit "refresh" button to update chart instead of the chart updating 
#as soon as you change one input

library(shiny)
library(ggplot2)
data("mtcars")

xAxisChoices=colnames(mtcars)
yAxisChoices=colnames(mtcars)

cylinderChoices=unique(mtcars$cyl)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  selectInput("xSelector",label="Select the x-axis:",choices=xAxisChoices),
  selectInput("ySelector",label="Select the y-axis:",choices=yAxisChoices),
  
  selectInput("cylSelector",label="Select a cylinder",choices=cylinderChoices),
  actionButton("refreshPlot",label="Refresh"),
  plotOutput("p1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  filter = reactive({
    filteredData=mtcars[mtcars$cyl==input$cylSelector,] 
    return(filteredData)
  })
  
  plot1=eventReactive(input$refreshPlot,{
    ggplot(data=filter(),aes_string(x=input$xSelector,y=input$ySelector))+geom_point()
  })
  
  output$p1=renderPlot(plot1())
  
}

# Run the application 
shinyApp(ui = ui, server = server)

