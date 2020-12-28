#Changing Map Based on Zoom Level Dark Map - 04.20.2020


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
          menuSubItem("Earthquake OSM",tabName = "m_osm", icon=icon("map")),
          menuSubItem("Earthuake Dark",tabName = "m_dark",icon=icon("map"))
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "m_osm",
          tags$style(type="text/css","#earthq_osm {height:calc(100vh - 80px) !important;}"),
          leafletOutput("earthq_osm")
        ),
        tabItem(
          tabName = "m_dark",
          tags$style(type="text/css","#earthq_osm {height:calc(100vh - 80px) !important;}"),
          leafletOutput("earthq_dark")
        )
      )
    )
  )
)
# Define server logic 
server <- function(input, output,session) {
  
  data(quakes)
  
  output$earthq_osm=renderLeaflet({
    
    pal=colorNumeric("Blues",quakes$mag)
    
    leaflet(data=quakes) %>% addTiles(group="OpenStreetMap")  %>%
      
      addProviderTiles(providers$Esri.WorldStreetMap,
                       options = tileOptions(minZoom =0, maxZoom = 13),
                       group = "Esri.WorldStreetMap") %>%
      
      addProviderTiles(providers$Esri.WorldImagery,
                       options=tileOptions(minZoom = 0, maxZoom = 13),
                       group = "Esri.WorldImagery") %>%
      
      
      addCircles(radius = ~10^mag/10, 
                 weight = 1, 
                 color = ~pal(mag), 
                 fillColor = ~pal(mag),
                 fillOpacity = 0.7,
                 popup = ~as.character(mag),
                 label = ~as.character(mag),
                 group = "Points") %>%
      
      addMarkers(lng = ~long,lat = ~lat, 
                 popup=~as.character(mag), 
                 label=~as.character(mag), 
                 group = "Markers") %>%
      
      addLayersControl(
        baseGroups = c("OpenStreetMap","Esri.WorldStreetMap","Esri.WorldImagery"),
        overlayGroups = c("Markers","Points"),
        options = layersControlOptions(collapsed = TRUE)
      ) %>%
      
      
      
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~mag, group = "Points",
        title = "Earthquake Magnitude"
      )
    
  })
  
  
  output$earthq_dark = renderLeaflet({
    
    pal = colorNumeric("OrRd",quakes$mag)
    
    leaflet(data=quakes) %>%
      addProviderTiles(providers$CartoDB.DarkMatter,
                       options=tileOptions(minZoom = 0,maxZoom = 7)) %>%
      
      addCircles(radius = ~10^mag/10,weight=1,color=~pal(mag), 
                 fillColor = ~pal(mag),
                 fillOpacity = 0.7,
                 popup = ~as.character(mag),
                 label = ~as.character(mag),
                 group="Points") %>%
      
      addProviderTiles(providers$Esri.WorldImagery,
                       options = tileOptions(minZoom = 7,maxZoom = 14)) %>%
      
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~mag, group = "Points",
        title = "Earthquake Magnitude"
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

