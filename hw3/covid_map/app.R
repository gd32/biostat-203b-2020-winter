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
    titlePanel("Visualizing the 2020 Coronavirus Epidemic"),
    
    # Date input
    dateInput(inputId = "date", 
              label = "Date", 
              value = "2020-02-24",
              min = "2020-01-22",
              max = "2020-02-24"),
    
    # Case type input
    selectInput(inputId = "casetype",
                label = "Case Type",
                choices = c("Confirmed", "Recovered", "Death")),
    
    
    # Province input (for sideplot)
    selectInput(inputId = "province",
                label = "Province",
                choices = c("Anhui",
                            "Fujian",
                            "Gansu",
                            "Guangdong",
                            "Guizhou",
                            "Hainan",
                            "Hebei",
                            "Heilongjiang",
                            "Henan",
                            "Hubei",
                            "Hunan",
                            "Jiangsu",
                            "Jiangxi",
                            "Jilin",
                            "Liaoning",
                            "Qinghai",
                            "Shaanxi",
                            "Shandong",
                            "Shanxi",
                            "Sichuan",
                            "Yunnan",
                            "Zhejiang",
                            "Guangxi",
                            "Inner Mongolia",
                            "Ningxia",
                            "Xinjiang",
                            "Tibet",
                            "Beijing",
                            "Chongqing",
                            "Shanghai",
                            "Tianjin",
                            "Hong Kong",
                            "Macau")),
    
    # Main output will be incidence map
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
    
    outcome = reactive({input$casetype})
    
    province = reactive({input$province})

    output$chnmap = renderPlot({
        p1 = covid %>%
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
        
        p2 = covid %>% filter(`Province/State` == province()) %>% 
             ggplot() + 
             geom_col(aes(date, eval(parse(text = tolower(outcome()))))) +
             xlab("Date") + 
             ylab("Count")
   
        grid.arrange(p1, p2, nrow=1)}
        )
 }

# Run the application 
shinyApp(ui = ui, server = server)