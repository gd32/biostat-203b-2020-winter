#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(tidyverse)
library(lubridate)
library(sf)
library(shinythemes)

covid = read_csv("covid.csv")
reddit = read_csv("reddit.csv")

chn_map = st_read("bou2_4p.shp", as_tibble = TRUE) %>%
    mutate(NAME = iconv(NAME, from = "GBK"),
           BOU2_4M_ = as.integer(BOU2_4M_),
           BOU2_4M_ID = as.integer(BOU2_4M_ID)) %>%
    mutate(NAME = str_replace_na(NAME, replacement = "澳门特别行政区"))

translate <- function(x) {
    sapply(x, function(chn_name) {
        if (str_detect(chn_name, "澳门")) {
            eng_name <- "Macau"
        } else if (str_detect(chn_name, "台湾")) {
            eng_name <- "Taiwan"
        } else if (str_detect(chn_name, "上海")) {
            eng_name <- "Shanghai"
        } else if (str_detect(chn_name, "云南")) {
            eng_name <- "Yunnan"
        } else if (str_detect(chn_name, "内蒙古")) {
            eng_name <- "Inner Mongolia"
        } else if (str_detect(chn_name, "北京")) {
            eng_name <- "Beijing"
        } else if (str_detect(chn_name, "台湾")) {
            eng_name <- "Taiwan"
        } else if (str_detect(chn_name, "吉林")) {
            eng_name <- "Jilin"
        } else if (str_detect(chn_name, "四川")) {
            eng_name <- "Sichuan"
        } else if (str_detect(chn_name, "天津")) {
            eng_name <- "Tianjin"
        } else if (str_detect(chn_name, "宁夏")) {
            eng_name <- "Ningxia"
        } else if (str_detect(chn_name, "安徽")) {
            eng_name <- "Anhui"
        } else if (str_detect(chn_name, "山东")) {
            eng_name <- "Shandong"
        } else if (str_detect(chn_name, "山西")) {
            eng_name <- "Shanxi"
        } else if (str_detect(chn_name, "广东")) {
            eng_name <- "Guangdong"
        } else if (str_detect(chn_name, "广西")) {
            eng_name <- "Guangxi"
        } else if (str_detect(chn_name, "新疆")) {
            eng_name <- "Xinjiang"
        } else if (str_detect(chn_name, "江苏")) {
            eng_name <- "Jiangsu"
        } else if (str_detect(chn_name, "江西")) {
            eng_name <- "Jiangxi"
        } else if (str_detect(chn_name, "河北")) {
            eng_name <- "Hebei"
        } else if (str_detect(chn_name, "河南")) {
            eng_name <- "Henan"
        } else if (str_detect(chn_name, "浙江")) {
            eng_name <- "Zhejiang"
        } else if (str_detect(chn_name, "海南")) {
            eng_name <- "Hainan"
        } else if (str_detect(chn_name, "湖北")) {
            eng_name <- "Hubei"
        } else if (str_detect(chn_name, "湖南")) {
            eng_name <- "Hunan"
        } else if (str_detect(chn_name, "甘肃")) {
            eng_name <- "Gansu"
        } else if (str_detect(chn_name, "福建")) {
            eng_name <- "Fujian"
        } else if (str_detect(chn_name, "西藏")) {
            eng_name <- "Tibet"
        } else if (str_detect(chn_name, "贵州")) {
            eng_name <- "Guizhou"
        } else if (str_detect(chn_name, "辽宁")) {
            eng_name <- "Liaoning"
        } else if (str_detect(chn_name, "重庆")) {
            eng_name <- "Chongqing"
        } else if (str_detect(chn_name, "陕西")) {
            eng_name <- "Shanxi"
        } else if (str_detect(chn_name, "青海")) {
            eng_name <- "Qinghai"
        } else if (str_detect(chn_name, "香港")) {
            eng_name <- "Hong Kong"
        } else if (str_detect(chn_name, "黑龙江")) {
            eng_name <- "Heilongjiang"
        } else {
            eng_name <- chn_name # don't translate if no correspondence
        }
        return(eng_name)
    })
}


chn_prov = chn_map %>% 
    count(NAME) %>%
    mutate(NAME_ENG = translate(NAME)) # translate function is vectorized

# Define UI 
ui = fluidPage(theme = shinytheme("paper"),
    
    # Application title
    titlePanel("Visualizing the 2020 Coronavirus Epidemic"),
    
    headerPanel(""),
    
    # Sidebar
    sidebarPanel(
        
        # Date input
        dateInput(inputId = "date", 
                  label = "Date", 
                  value = "2020-02-26",
                  min = "2020-01-23",
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
            labs(title = str_c(outcome(), " Cases"), subtitle = dateInput()) + 
            theme(
                plot.title = element_text(size = 36, face = "bold"),
                plot.subtitle = element_text(size = 24),
                legend.text = element_text(size = 20),
                legend.title = element_text(size = 24)
            )
        
    }, width = 1200, height = 1000) 
    
    output$prov = renderPlot({
        
       covid %>% filter(`Country/Region` %in% c("Mainland China", 
                                                "Macau", 
                                                "Hong Kong", 
                                                "Taiwan"), 
                        date <= dateInput()) %>% 
                mutate(isHubei = ifelse(`Province/State` == "Hubei", 
                                        "Hubei", "Others")) %>%
                ggplot() + 
                geom_col(aes(date, eval(parse(text = tolower(outcome()))), 
                             fill = isHubei)) +
                labs(fill = "Province") +
                xlab("Date") +
                ylab("Count") +
                labs(title = str_c("\n", outcome(), " Cases"), 
                     subtitle = str_c("Cumulative until ", dateInput())) +
                scale_fill_manual(values = c("orange", "blue")) +
                theme_bw() +
                theme(plot.title = element_text(size = 36, face = "bold"),
                      plot.subtitle = element_text(size = 24),
                      axis.text = element_text(size = 18),
                      axis.title = element_text(size = 24),
                      legend.text = element_text(size = 18),
                      legend.title = element_text(size = 20)
            )
    
        }, width = 1000, height = 800)
    
    output$Reddit = renderTable({
        
        s1 = reddit %>% filter(sub == "Science", 
                               created_date == ymd(dateInput())) %>% 
                               sample_n(1) 
        s2 = reddit %>% filter(sub == "News", 
                               created_date == ymd(dateInput())) %>% 
                               sample_n(1)
        s3 = reddit %>% filter(sub == "Coronavirus", 
                               created_date == ymd(dateInput())) %>% 
                               sample_n(3)
        
        display_table = bind_rows(s1, s2, s3)
        
        display_table %>% select(c("author", "title", "url", "sub"))
                     
       })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
