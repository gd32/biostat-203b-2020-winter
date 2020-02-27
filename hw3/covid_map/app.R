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
    plotdate = "2020-01-31"
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
