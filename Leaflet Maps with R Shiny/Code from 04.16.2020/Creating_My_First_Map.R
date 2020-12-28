#Creating my first map 04.16.2020

library(shinydashboard)
library(shiny)
library(leaflet)
library(leaflet.extras)
library(rgdal)
library(sp)
library(raster)

# Define UI for application
ui <- fluidPage(
   dashboardPage(
     dashboardHeader(),
     dashboardSidebar(),
     dashboardBody(
#---------------STYLE THE MAP-------------#
       tags$style(type="text/css","#map {height:calc(100vh - 80px) !important;}"),
       leafletOutput("map")
         )
    )
)
# Define server logic 
server <- function(input, output) {
   
  output$map=renderLeaflet({
    leaflet() %>% addTiles()

#----------adds open street map by default since we didnt specify anything else----------#
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

