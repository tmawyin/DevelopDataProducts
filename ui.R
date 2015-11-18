library(shiny)
library(leaflet)

## This function defines the User Interface file for the shiny application 
shinyUI(fluidPage(
    # Application title
    titlePanel("Judicial Power Ranking in Latin America"),
    br(),
    # Application Description
    p("The purpose of this application is to showcase the Judicial Power 
      ranking in Latin America countries. The ranking is based in six 
      different metrics that are measured by scholar who answer a questionaire 
      and evaluate the services of each country."), 
    br(),
    p("The map might take a little time to load, thank you for your patience"),
    br(),
    
    # Sidebar with controls to select each of the metrics used to rank the
    # countries.
    sidebarLayout(
        sidebarPanel(
            # Radio buttons to select ranking type
            radioButtons("metric", "Ranking Metric:",
                         c("Information" = "1",
                           "Interaction" = "2",
                           "Integration" = "3",
                           "Participation" = "4",
                           "Website performance" = "5",
                           "Style and Design" = "6")),
            br(),
            #
            sliderInput("n", 
                        "Number of Countries:", 
                        value = 20,
                        min = 1, 
                        max = 25)
        ),
        
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Bar Plot", plotOutput("plot")),
                        tabPanel("Map", leafletOutput("map", width="100%", height="400")),
                        tabPanel("About", 
                                 br(),
                                 p("This file is intended to show the rankings 
                                of 25 Latin American countries given as 
                                a result of ranking metric for their Judicial 
                                Power. 
                                The objective of this application is to show an
                                interactive map/plot where the user can visualize 
                                the countries with better rankings."),
                                 br(), p("Select the desire metric on the left 
                                         panel to see the corresponding ranking 
                                         per country"),
                                 br(), p("You can also select from the slidebar 
                                         tool, the number of countries you would 
                                         like to compare for each of the metrics. 
                                         The bar plor presents the highest ranked
                                         countries."),
                                 br(), p("Acknowledgment: The data was collected 
                                        and provided by Dr. Rodrigo Sandoval 
                                        from the University of Toluca in Mexico.")
                                 )
            )
        )
    )
))