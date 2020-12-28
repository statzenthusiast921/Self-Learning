#Basic Structure Overview - 04.15.2020
#Header, Sidebar
library(shiny)
library(shinydashboard)
library(ggplot2)
cylinderChoices=unique(mtcars$cyl)

# Define UI 
ui <- fluidPage(
  dashboardPage(
    dashboardHeader(title="Dashboard Header",
                    dropdownMenu(type="messages",
                                 messageItem(from="Mike",message="This is a test message")
                    ),
                    dropdownMenuOutput(outputId = "messageMenu"),
                    dropdownMenu(type="notifications",
                                 notificationItem(text="This is a test notification")
                    ),
                    dropdownMenu(type="tasks",
                                 taskItem(text="This is a test task",value=50)
                    )
    ),
    
    dashboardSidebar(
      sidebarMenu(
        menuItem(text="Data",tabName="data",icon=icon("table")),
        menuItem(text="Plot",tabName="plots",icon=icon("chart-bar")),
        selectInput(inputId = "selectCylinder",label="Select a cylinder:",choices=cylinderChoices)
      )
    ),
    
#-------------------START HERE-------------------#

#need to match tabname from sidebarmenu down here in body, order doesn't matter

    dashboardBody(
      tabItems(
        tabItem(tabName = "plots",
                plotOutput("plot1")
                ),
        tabItem(tabName = "data",
                DTOutput(outputId = "data1")
                )
      )
    )
    
  )
)






# Define server logic 
server <- function(input, output) {
  
  dataFiltered=reactive({
    data=mtcars[mtcars$cyl==input$selectCylinder,]
    return(data)
  
  })
  
  output$data1=renderDT(datatable(dataFiltered()))
  output$plot1=renderPlot({
    ggplot(data=dataFiltered(),aes(x=mpg,y=hp))+geom_point()
  })
  
  messageData=data.frame(from=c("Finance","Accounting","HR"),
                         message=c("Revenue is up","Budget meeting this Friday","Donuts in the breakroom"))
  
  output$messageMenu=renderMenu({
    
    msg=apply(messageData,1,function(row){
      messageItem(from=row[['from']],message=row[["message"]])
      
    })
    dropdownMenu(type="messages",.list = msg)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

