#Working with Different Layouts 3 - 04.13.2020
#Conditional Panels
library(shiny)

xAxisChoices=colnames(mtcars)
yAxisChoices=colnames(mtcars)

cylinderChoices=unique(mtcars$cyl)

# Define UI



ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("xSelector",label="Select the x axis:",choices=xAxisChoices),
      selectInput("ySelector",label="Select the y axis:",choices=yAxisChoices),
      selectInput("cylSelector",label="Select a cylinder",choices=cylinderChoices),
      checkboxInput("showTitle",label="Check to enter title",value=FALSE),
      conditionalPanel(condition="input.showTitle== true",
                    textInput("title",label="Enter a plot title",placeholder="Title")),
      actionButton("refreshPlot",label="Refresh")
    ),
    mainPanel(
      plotOutput("p1")
    )))


# Define server logic required to draw a histogram
server <- function(input, output) {
  filter = reactive({
    filteredData=mtcars[mtcars$cyl==input$cylSelector,] 
    return(filteredData)
  })
  
  plot1=eventReactive(input$refreshPlot,{
    
    if(input$showTitle==TRUE){
      ggplot(data=filter(),aes_string(x=input$xSelector,y=input$ySelector))+geom_point()+ggtitle(input$title)
      
    } else {
      ggplot(data=filter(),aes_string(x=input$xSelector,y=input$ySelector))+geom_point()
      
    }
    
  })
  
  output$p1=renderPlot(plot1())
  
}

# Run the application 
shinyApp(ui = ui, server = server)

