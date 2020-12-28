#My Final Layout Project - 04.13.2020

library(shiny)

monthChoices = unique(airquality$Month)

# Define UI Section of Web App


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  selectInput("month",label="Select a month:",choices=monthChoices),
  selectInput("column",label="Select a column to plot:",choices=c("Wind","Temp")),
  DTOutput(outputId = "datatable1"),
  plotOutput(outputId = "plot1")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  filteredData = reactive({
    filteredData=airquality[airquality$Month==input$month,] 
    return(filteredData)
  })
  
  output$datatable1=renderDT({
    datatable(filteredData())
  })
  
  output$plot1=renderPlot({
    
    ggplot(data=filteredData(),aes_string(x="Day",y=input$column))+geom_point()+geom_line()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

