#Progress Bars - 04.15.2020

library(shiny)

# Define UI
ui <- fluidPage(
 
  actionButton(inputId = "loop",label="Start long running process")
  
)

# Define server logic
server <- function(input, output) {
   
  observeEvent(input$loop,{
    n=100
    withProgress(message="Running Process",value=0,{
      for(i in 1:n){
        incProgress(amount=1/n,detail=paste0("Completed",i,"%"))
        Sys.sleep(.1)
      }
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

