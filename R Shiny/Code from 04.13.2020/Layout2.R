#Working with Different Layouts 2 - 04.13.2020

library(shiny)

xAxisChoices=colnames(mtcars)
yAxisChoices=colnames(mtcars)

cylinderChoices=unique(mtcars$cyl)

# Define UI

#fluid rows have total width of 12 --> 4 things each get width of 3
# 2 UIs on top, 2 UIs on bottom

ui <- fluidPage(
  fluidRow(
    column(width=6,  selectInput("xSelector",label="Select the x axis:",choices=xAxisChoices)),
    column(width=6,  selectInput("ySelector",label="Select the y axis:",choices=yAxisChoices))
  ), 
  fluidRow(
    column(width=3,  selectInput("cylSelector",label="Select a cylinder",choices=cylinderChoices)),
    column(width=3,  actionButton("refreshPlot",label="Refresh")),
  
  fluidRow(
    plotOutput("p1")
    
  )))
  

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

