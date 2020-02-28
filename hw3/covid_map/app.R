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
library(grid)
library(gridExtra)

setwd('/home/gdewey/biostat-203b-2020-winter/hw3')

# Define UI 
ui = fluidPage(
    
    # Application title
    titlePanel(h1("Visualizing the 2020 Coronavirus Epidemic")),
    
    headerPanel(""),
    headerPanel(""),
    
    # Sidebar
    sidebarPanel(
        
        # Date input
        dateInput(inputId = "date", 
                  label = "Date", 
                  value = "2020-02-26",
                  min = "2020-01-22",
                  max = "2020-02-26"),
    
        # Case type input
        selectInput(inputId = "casetype",
                    label = "Case Type",
                    choices = c("Confirmed", "Recovered", "Death"))),
    
    # Main output will be incidence map
    mainPanel(
        
        tabsetPanel(type = "tabs",
                    tabPanel("Main", plotOutput("chnmap")),
                    tabPanel("Bar plot", plotOutput("prov")),
                    tabPanel("Reddit posts", tableOutput("Reddit")))),

)

# Load virus and map data
covid = read_csv("covid.csv")
covid

provs = read_csv("provs.csv")
provs

# Load text data
reddit = read_csv("reddit.csv")
reddit

# Define server logic
server = function(input, output) {
    
    dateInput = reactive({input$date})
    
    outcome = reactive({input$casetype})
    
    province = reactive({input$province})

    output$chnmap = renderPlot({
        
        covid %>%
            filter(`Country/Region` %in% c("Mainland China",
                                           "Macau",
                                           "Hong Kong",
                                           "Taiwan")) %>%
            filter(date == dateInput()) %>%
            group_by(`Province/State`) %>%
            top_n(1, date) %>%
            right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
            ggplot() +
            geom_sf(mapping = aes(fill = !!sym(tolower(outcome())), 
                                  geometry = geometry)) +
            scale_fill_gradient(name = "Count",
                                trans = "log10",
                                breaks = c(5, 50, 500, 5000, 50000),
                                labels = c(5, 50, 500, 5000, 50000),
                                guide = "legend",
                                low = "blue",
                                high = "orange") +
            theme_bw() +
            labs(title = str_c(outcome(), " Cases"), subtitle = dateInput())
    }) 
    
    output$prov = renderPlot({
        
       covid %>% filter(`Country/Region` %in% c("Mainland China", 
                                                "Macau", 
                                                "Hong Kong", 
                                                "Taiwan")) %>% 
                mutate(isHubei = ifelse(`Province/State` == "Hubei", 
                                        "Hubei", "Others")) %>%
                ggplot() + 
                geom_col(aes(date, eval(parse(text = tolower(outcome()))), 
                             fill = isHubei)) +
                labs(fill = "Province") +
                xlab("Date") +
                ylab("Count") +
                scale_fill_manual(values = c("orange", "blue")) +
                theme_bw()
    
        })
    
    output$Reddit = renderTable({
        
        s1 = reddit %>% filter(sub == "Science", 
                               created_date == ymd(dateInput())) %>% sample_n(5) 
        s2 = reddit %>% filter(sub == "News", 
                               created_date == ymd(dateInput())) %>% sample_n(5)
        s3 = reddit %>% filter(sub == "Coronavirus", 
                               created_date == ymd(dateInput())) %>% sample_n(5)
        
        display_table = bind_rows(s1, s2, s3)
        
        display_table %>% select(c("author", "title", "url", "sub"))
                     
       })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
