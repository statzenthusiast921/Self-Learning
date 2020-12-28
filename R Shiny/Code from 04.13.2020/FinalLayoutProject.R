#My Final Layout Project - 04.13.2020

library(shiny)
library(ggplot2)
data("airquality")


monthChoices = unique(airquality$Month)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "month",label="Select a month:",choices=monthChoices),
      selectInput(inputId = "column",label="Select a column to plot:",choices=c("Wind","Temp"))
      ),
      mainPanel(
        fluidRow(
          column(width=6,
            DTOutput(outputId = "datatable1")
          ),
          column(width=6,
                 plotOutput("plot1")
                 )
        )
)))

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

