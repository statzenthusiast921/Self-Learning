#My Project

library(shiny)
library(ggplot2)

data <- read.csv(file="/Users/jonzimmerman/Desktop/Data Projects/Airport Accessibility Project/AirportAccess.csv")
data2=data[1:150,]

regionChoices = unique(data2$Region)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Airport Dataset"),
  selectInput("region",label="Select a region:",choices=regionChoices),
  selectInput(inputId = "column",label="Select a column:",choices=c("DestinationCount","OriginCode","Latitude","Longitude")),
  DTOutput(outputId = "datatable1"),
  plotOutput(outputId = "plot1")
  )

# Define server logic required to draw a histogram
server <- function(input, output) {

  filteredData = reactive({
    filteredData=data2[data2$Region==input$region,] 
    return(filteredData)
  })
  
  output$datatable1=renderDT({
    datatable(filteredData())
  })
  
  output$plot1=renderPlot({
    
    ggplot(data=filteredData(),aes_string(x="DestLat",y=input$column))+geom_point()+geom_line()
  })
  
}


# Run the application 
shinyApp(ui = ui, server = server)

