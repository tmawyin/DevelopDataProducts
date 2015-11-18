## Loading required libraries
library(rgdal)
library(ggplot2)
library(leaflet)
library(tidyr)
library(dplyr)
library(xlsx)
library(shiny)

##-------- Loading the data from the loadFile.R script
suppressWarnings(
    source("loadFile.R"))

##-------- Application Server function.
shinyServer(function(input, output, session) {
    
    # Let's get the required data based on the ranking metric
    metric.num <- reactive({as.numeric(input$metric)})
    country.num <- reactive({as.numeric(input$n)})
    
    # The following code will render the required plot
    output$plot <- renderPlot({
        # Separate data based on the required metric
        data.display <- data.summary %>% filter(Type == type[metric.num()])
        # Organizing the data to generate the bar plot from highest ranked
        data.ordered <- data.display %>% arrange(desc(Total))
        data.ordered <- data.ordered[seq(1,country.num()),]
        
        # Use ggplot to create the bar chart
        ggplot(data.ordered, aes(x=factor(Country), y=Total)) +
            geom_bar(stat="identity", fill="blue") +
            # Styling the plot 
            labs(title = "Judicial Power Rankings") +
            labs(x = "Country", y= "Score") + 
            theme_classic(base_family = "Arial") +
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
    })

    # The following code will render the map
    output$map <- renderLeaflet({
        # Getting the data from metric radio buttons
        data.display <- data.summary %>% filter(Type == type[metric.num()])
        
        # Reading the map - obtained via GIS
        map@data <- merge(map@data, data.display, by.x = "NAME", by.y ="Country",  sort = FALSE)
        
        # Let's generate some colors
        pal <- colorNumeric(palette = "Greens", domain = data.display$Total)
        stamen_tiles <- "http://{s}.tile.stamen.com/toner-lite/{z}/{x}/{y}.png"
        
        ## Setting up the pop-up
        map.popup <- paste0("<strong>Country: </strong>",
                            map@data$NAME,
                            "<br><strong>Total: </strong>",
                            map[['Total']] )
        
        latinMap <- leaflet(data = map) %>% addTiles() %>% 
            addTiles(urlTemplate = stamen_tiles) %>%
            setView(lat=-12.168, lng=-86.704, zoom = 3) %>%
            addPolygons(fillColor =~pal(map[['Total']]), 
                        fillOpacity = 0.7, 
                        color = "#BDBDC3", 
                        weight = 1, 
                        popup = map.popup)
        
        latinMap
    })
    
})

