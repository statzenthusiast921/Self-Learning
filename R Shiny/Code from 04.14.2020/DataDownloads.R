#Data Downloads - 04.14.2020
#something still isn't right with this --> freezes when clicking download
#Line 13 may need another comma on the end

library(shiny)
library(DT)
cylinderChoices=unique(mtcars$cyl)

# Define UI 
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("cylSelector",label="Select a cylinder",choices=cylinderChoices)
    ),
    mainPanel(
      downloadButton("downloadData","Download Data"),
      DTOutput("datatable1")
    )
  )
)

# Define server logic 
server <- function(input, output) {
  filter = reactive({
    filteredData=mtcars[mtcars$cyl==input$cylSelector,] 
    return(filteredData)
  })
  
 
  
  output$datatable1=renderDT({
    datatable(filter())
  })
  
  output$downloadData=downloadHandler(
    filename="FilteredData.csv",
    content=function(file){
      write.csv(filter()[input[["datatable1_rows_all"]],],file)
    }
  )
}


# Run the application 
shinyApp(ui = ui, server = server)

