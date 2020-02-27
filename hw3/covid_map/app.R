<<<<<<< HEAD
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)

setwd('/home/gdewey/biostat-203b-2020-winter/hw3')

# Define UI for application that draws a histogram
ui = fluidPage(

    # Application title
    titlePanel("Visualizing the 2020 Coronavirus Epidemic"),
    
    # Date input
    dateInput(inputId = "date", 
              label = "Date", 
              value = "2020-02-25",
              min = "2020-01-22",
              max = "2020-02-25"),
    
    mainPanel(plotOutput("chnmap"))
        
)

# Load data
covid = read_csv("covid.csv")
covid

provs = read_csv("provs.csv")
provs

# Define server logic
server = function(input, output) {
    dateInput = reactive({input$date})
    count = "confirmed"
    output$chnmap = renderPlot({covid %>%
        filter(`Country/Region` %in% c("Mainland China", 
                                       "Macau", 
                                       "Hong Kong", 
                                       "Taiwan")) %>%
        filter(date == dateInput()) %>%
        group_by(`Province/State`) %>%
        top_n(1, date) %>% 
        right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
        ggplot() +
        geom_sf(mapping = aes(fill = !!sym(count), geometry = geometry)) +
        scale_fill_gradient(name = "Cases", 
                            trans = "log10", 
                            breaks = c(5, 50, 500, 5000, 50000),
                            labels = c(5, 50, 500, 5000, 50000),
                            guide = "legend",
                            low = "lightblue",
                            high = "red") +
        theme_bw() +
        labs(title = str_c(count, " cases"), subtitle = dateInput())})
}

# Run the application 
shinyApp(ui = ui, server = server)
||||||| merged common ancestors
=======
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)

setwd('/home/gdewey/biostat-203b-2020-winter/hw3')

# Define UI for application that draws a histogram
ui = fluidPage(

    # Application title
    titlePanel("Visualizing the 2020 Coronavirus Epidemic"),
    
    # Date input
    dateInput(inputId = "date", 
              label = "Date", 
              value = "2020-02-25",
              min = "2020-01-22",
              max = "2020-02-25"),
    
    mainPanel(plotOutput("chnmap"))
        
)

# Load data
covid = read_csv("covid.csv")
covid

provs = read_csv("provs.csv")
provs

# Define server logic
server = function(input, output) {
    plotdate = reactive({input$date})
    count = "confirmed"
    output$chnmap = renderPlot({covid %>%
        filter(`Country/Region` %in% c("Mainland China", 
                                       "Macau", 
                                       "Hong Kong", 
                                       "Taiwan")) %>%
        filter(date == plotdate) %>%
        group_by(`Province/State`) %>%
        top_n(1, date) %>% 
        right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
        ggplot() +
        geom_sf(mapping = aes(fill = !!sym(count), geometry = geometry)) +
        scale_fill_gradient(low = "lightblue", high = "red") +
        theme_bw() +
        labs(title = str_c(count, " cases"), subtitle = plotdate)})
}

# Run the application 
shinyApp(ui = ui, server = server)
>>>>>>> 270bc5531b637db9e33b287330b94da0225ea891
