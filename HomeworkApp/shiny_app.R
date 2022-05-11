
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
      geom_smooth() 
    
  },
  
  width = 600, height = 400)
   
}

shinyApp(ui, server)