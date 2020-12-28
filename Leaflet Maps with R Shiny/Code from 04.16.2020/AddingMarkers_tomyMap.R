#Adding markers to my first map 04.16.2020

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
    dashboardHeader(title="R Geo App"),
    dashboardSidebar(
      sidebarMenu(
        menuItem(
          "Maps",
          tabName = "maps",
          icon=icon("globe"),
          menuSubItem("Earthquake OSM",tabName = "m_osm", icon=icon("map"))
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "m_osm",
          tags$style(type="text/css","#earthq_osm {height:calc(100vh - 80px) !important;}"),
          leafletOutput("earthq_osm")
        )
      )
    )
  )
)
# Define server logic 
server <- function(input, output,session) {
  
  data(quakes)
  
  output$earthq_osm=renderLeaflet({
    leaflet(data=quakes) %>% addTiles(group="OpenStreetMap")  %>%
      addMarkers(lng = ~long,lat = ~lat, 
                 popup=~as.character(mag), 
                 label=~as.character(mag), 
                 group = "Markers")
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

