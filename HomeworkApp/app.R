library(ggthemes)
library(shiny)
library(dplyr)
library(readr)
library(tidyverse)

data(storms)
theme_set(theme_minimal())

oxford <- "https://raw.githubusercontent.com/OxCGRT/covid-policy-tracker/master/data/OxCGRT_latest.csv"

oxford <- read_csv(oxford)
oxford <- rename(oxford, country = CountryName)


oxfordNames <- oxford %>%
  select(country, Date, StringencyIndex) %>%
  distinct() %>%
  group_by(country, StringencyIndex)


ui <- fluidPage(
  
  selectInput("oxfordNames",
              label = "Filter by Country Name: ",
              choices = unique(oxfordNames$country)),
  
  "The plot below shows the stringency index over time.",
  plotOutput("nameDist")
)

server <- function(input, output, session) {
  
  output$nameDist <- renderPlot({
    
    str(input$oxfordNames)
    
    ggplot(data = filter(oxfordNames, country == input$oxfordNames),aes(x=Date, y= StringencyIndex)) +
      geom_smooth(color = "black")+ theme_economist()+ scale_x_continuous(breaks=c(20200000,20205000,20210000, 20215000, 20220000),
                                                                                         labels=c("January 2020", "May 2020", "January 2021", "May 2022", "January 2022"))+
      labs(x = NULL, y = "Stringency Index")+ theme(axis.title.y= element_text(size = 15))+ theme(axis.title.y = element_text(vjust = 2.5))
    
  },
  
  width = 600, height = 400)
  
}

shinyApp(ui, server)