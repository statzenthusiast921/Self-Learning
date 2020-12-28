#Upload a File - 04.14.2020


library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(
   sidebarLayout(
     sidebarPanel(
       fileInput("file1","Upload a csv file:",
                 multiple=FALSE,
                 accept=c(".csv")),
       textInput("sep",label="Enter the Separator character:", value=","),
       checkboxInput("header",label="File contains a header",value=TRUE)
     ),
     mainPanel(
       DTOutput("data1")
     )
   )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$data1=renderDT({
    req(input$file1)
    df=read.csv(input$file1$datapath,header=input$header,sep=input$sep)
    return(datatable(df))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

