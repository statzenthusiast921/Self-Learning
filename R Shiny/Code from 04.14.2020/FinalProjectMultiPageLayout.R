#Reactivity Final Project - 04.13.2020

library(shiny)
library(ggplot2)
data("airquality")


monthChoices = unique(airquality$Month)

# Define UI for application that draws a histogram
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "month",label="Select a month:",choices=unique(airquality$Month)),
      selectInput(inputId = "column",label="Select a column",choices=c("Wind","Temp"))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data",DTOutput("datatable1")),
        tabPanel("Plot",plotOutput("plot1"))
      )
    )
  )
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

