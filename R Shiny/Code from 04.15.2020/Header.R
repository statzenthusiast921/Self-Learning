#Basic Structure Overview - 04.15.2020
#Starting with the Header
library(shiny)
library(shinydashboard)

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
    dashboardSidebar(),
    dashboardBody()
    
  )
)

# Define server logic 
server <- function(input, output) {
   
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

