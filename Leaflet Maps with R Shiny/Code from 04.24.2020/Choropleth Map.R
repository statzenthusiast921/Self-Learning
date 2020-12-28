#Adding the Fourth Map - 04.24.2020

library(shinydashboard)
library(shiny)
library(leaflet)
library(leaflet.extras)
library(rgdal)
library(sp)
library(raster)

download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip", destfile="world_shape_file.zip")
unzip("world_shape_file.zip")
world_spdf=readOGR(dsn = getwd(),layer = "TM_WORLD_BORDERS_SIMPL-0.3")
world_spdf$POP2005 = as.numeric(as.character(world_spdf$POP2005))/1000000 %>% round(2)

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
          menuSubItem("Earthquake Dark",tabName = "m_dark",icon=icon("map")),
          menuSubItem("Earthquake HeatMap", tabName = "m_heat",icon=icon("map")),
          menuSubItem("World Population", tabName = "m_chor",icon=icon("map"))
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
          tags$style(type="text/css","#earthq_dark {height:calc(100vh - 80px) !important;}"),
          leafletOutput("earthq_dark")
        ),
        tabItem(
          tabName = "m_heat",
          tags$style(type="text/css","#earthq_heat {height:calc(100vh - 80px) !important;}"),
          leafletOutput("earthq_heat")
        ),
        tabItem(
          tabName = "m_chor",
          tags$style(type="text/css","#world_chor {height:calc(100vh - 80px) !important;}"),
          leafletOutput("world_chor")
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
  
  #----------MAP #3: HEAT MAP---------#
  output$earthq_heat = renderLeaflet({
    pal=colorNumeric("RdYlBu",quakes$mag)
    leaflet(data=quakes) %>%
      addProviderTiles(providers$Esri.WorldImagery,
                       options=tileOptions(minZoom = 0,maxZoom = 13)) %>%
      
      addHeatmap(
        lng = ~long, lat = ~lat, intensity = ~mag, blur = 20, max = 0.05, radius = 15
      )
  })
  
  
  #----MAP #4: Choropleth Map - World Population----#
  output$world_chor=renderLeaflet({
    bins=c(0,10,20,50,100,500,Inf)
    pal=colorBin(palette = "YlOrBr",domain = world_spdf$POP2005,
                 na.color = "transparent",
                 bins=bins)
    customLabel = paste("Country: ",world_spdf$NAME,"<br/>",
                        "Population: ",round(world_spdf$POP2005,2), serp="") %>%
      lapply(htmltools::HTML)
    
    leaflet(world_spdf) %>%
      addProviderTiles(providers$OpenStreetMap,options=tileOptions(minZoom = 2,
                                                                   maxZoom = 8)) %>%
      addPolygons(fillColor = ~pal(POP2005),
                  fillOpacity = 0.9,
                  stroke = TRUE,
                  color = "white",
                  highlight=highlightOptions(
                    weight=5,
                    fillOpacity = 0.3
                  ),
                  label=customLabel,
                  weight=0.3,
                  smoothFactor = 0.2) %>%
      
      addLegend(
        pal=pal,
        values = ~POP2005,
        position = "bottomright",
        title = "World Population (Millions)"
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)