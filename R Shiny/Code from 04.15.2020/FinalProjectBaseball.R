#Final Project - Baseball Dashboard - 04.15.2020

library(shiny)
library(shinydashboard)
library(DT)
library(readr)
library(dplyr)
library(data.table)

allData=as.data.frame(read_csv("/Users/jonzimmerman/Desktop/Udemy Courses/R Shiny/original.csv"))

playerChoices=unique(allData$name)
yearChoices=unique(allData$yearID)
metricChoices=c("G","AB","R","H","Doubles","Triples","HR","RBI","BB","SO")
teamChoices=unique(allData$franchName)

# Define UI for application t
ui <- fluidPage(
  
  dashboardPage(
    dashboardHeader(title="Baseball App"),
    dashboardSidebar(
      sidebarMenu(
#----------MENU + MENUSUBITEM creates parent and child grouping of menus which are collapsable----------#
        menuItem(text="Player Data",
                 startExpanded=TRUE,
                 menuSubItem(text = "Data",tabName = "playerData"),
                 menuSubItem(text = "Plots",tabName = "playerPlot")
                 ),
#----------NON-COLLAPSABLE MENUs----------#     
        menuItem(text = "Data Per Team/Year", tabName = "dataPerTeamYear"),
        menuItem(text = "Yearly Leaders", tabName = "yearlyleaders"),
#----------INPUTS THAT CHANGE THE DATA VIEWS----------#
        selectInput(inputId = "playerSelect",label="Select a player:",choices=playerChoices,selected="Barry Bonds"),
        selectInput(inputId = "metricSelect",label="Select which stat to display:",choices=metricChoices, selected="HR"),
        selectInput(inputId = "teamSelect",label="Select which team to view",choices=teamChoices,selected="New York Yankees"),
        selectInput(inputId = "year",label="Select which year to view",choices=yearChoices,selected=2015)
      )
    ),
    dashboardBody(
#----------USE TABITEMS WHEN YOU HAVE MULTIPLE TABS TO USE----------#
      tabItems(
        tabItem(tabName = "playerData",
                
#----------TWO THINGS ON THIS TAB----------#
                DTOutput(outputId = "careerDataPlayer"),
                DTOutput(outputId = "yearlyDataPlayer")
                ),
#----------ONE THING ON THIS TAB----------#
        tabItem(tabName = "playerPlot",
                plotOutput("yearPlotPlayer")
                ),
        tabItem(tabName = "dataPerTeamYear",
                DTOutput("teamData")),
        tabItem(tabName = "yearlyleaders",
                plotOutput("yearLeaderPlot"))
        
      )
    )
  ) 
  
)

# Define server logic 
server <- function(input, output) {
   
   teamData=reactive({
     filteredData=subset(allData,franchName == input$teamSelect)
     
     final=data.table(filteredData)[,list(G=sum(G),
                                          AB=sum(AB),
                                          R=sum(R),
                                          H=sum(H),
                                          Doubles=sum(Doubles),
                                          Triples=sum(Triples),
                                          HR=sum(HR),
                                          RBI=sum(RBI),
                                          BB=sum(BB),
                                          SO=sum(SO)),
                                    by=list(franchName,yearID)]
     return(final)
   })
   
   yearData=reactive({
     filteredData=subset(allData,yearID==input$year)
     
     final=filteredData[order(filteredData[input$metricSelect],decreasing=T),]
     final2=final[1:10,]
     
     final2$name=factor(final2$name,levels=unique(final2$name))
     
     return(final2)
   })
   
   playerData=reactive({
     filteredData=subset(allData,name == input$playerSelect)
     return(filteredData)
   })
   
   playerCareerData=reactive({
     data=playerData()
     
     careerData=data.table(data)[,list(G=sum(G),
                                      AB=sum(AB),
                                      R=sum(R),
                                      H=sum(H),
                                      Doubles=sum(Doubles),
                                      Triples=sum(Triples),
                                      HR=sum(HR),
                                      RBI=sum(RBI),
                                      BB=sum(BB),
                                      SO=sum(SO)),
                                by=list(name)]
     return(careerData)
   })
   
   output$careerDataPlayer = renderDT({
     data=playerCareerData()
     datatable(data,options=list(pageLength=nrow(data)))
     
   })
   
   output$yearlyDataPlayer = renderDT({
     data=playerData()
     datatable(data,options=list(pageLength=nrow(data)))
   })
   
   output$yearPlotPlayer = renderPlot({
     plot=ggplot(playerData(),aes_string(x="yearID",y=input$metricSelect))
     plot=plot+geom_col(fill="blue")
#----------DYNAMIC TITLE----------#
     plot=plot+ggtitle(paste0(input$metricSelect,"Per Year For", input$playerSelect))
     plot
   })
   
   output$teamData = renderDT({
     data=teamData()
     datatable(data,options=list(pageLength=nrow(data)))
   })
   
   output$yearLeaderPlot=renderPlot({

     plot=ggplot(yearData())
     plot=plot+geom_col(aes_string(x="name",y=input$metricSelect),fill="blue")
     plot=plot+ggtitle(paste0(input$metricSelect," Leaders for the Year ",input$year))
     plot
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

