#Dynamic Data Refresh - 04.14.2020

library(shiny)
library(DT)
library(ggplot2)
# Define UI for application that draws a histogram
ui <- fluidPage(
 DTOutput(outputId = "updatedData"),
 plotOutput(outputId = "updatedPlot")
)

#session --> allows us to end this monitoring of the data file as soon as session ends
# Define server logic required to draw a histogram
library(data.table)
server <- function(input, output, session) {
   fileData = reactiveFileReader(intervalMillis = 1000,
                                 session=session,
                                 filePath="/Users/jonzimmerman/Desktop/Udemy Courses/R Shiny/dataToRefresh.csv",
                                 readFunc = read.csv)
   dataAggregation=reactive({
     aggData=data.table(fileData())[,list(totalSales=sum(Amount)),
                                    by=list(SalesPerson,Day)]
     return(aggData)
   })
   
   output$updatedData = renderDT(datatable(dataAggregation()))
   output$updatedPlot = renderPlot({
     ggplot(data=dataAggregation(),aes(x=SalesPerson,y=totalSales,fill=SalesPerson))+geom_col()
     
   })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

