#Introduction
library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(rgdal)
library(sp)
library(raster)

#-------------------Define UI-------------------#
ui =fluidPage(
   dashboardPage(
     dashboardHeader(),
       dashboardSidebar(),
        dashboardBody()
   )
)
# Define server logic 
server <- function(input, output,session) {
  
  
}

#-------------------Run the application-------------------#
shinyApp(ui = ui, server = server)

