library(shiny)
library(maps)
library(ggplot2)
library(reshape)

## Prepare the data
data("us.cities") 
# Rename variables in the us.cities dataset
us.cities <- rename(us.cities, c(name="city"))
us.cities <- rename(us.cities, c(country.etc="state"))
# Make all state codes uniform
us.cities$state<-toupper(us.cities$state)
# Create a list of sorted unique state codes
StateList<-sort(unique(us.cities$state))
# Remove Alaska and Hawaii
StateList <- subset(StateList, !(StateList%in%c("HI","AK")))
# Remove the state codes at the end of the city names
us.cities$city<-substr(us.cities$city,1,nchar(us.cities$city)-3) 


# Define UI for Route Map
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Choose a route"),
  
  # Sidebar with controls to select a city/state/Add to Route
  sidebarLayout(
    sidebarPanel(
      selectInput("stateset", "Choose a state:", choices = StateList),
      
      selectInput("cityset", "Choose a city:", choices = "Select a state first"),
      
      actionButton("updateData","Add to list")
      
    ),
    
    # Show a map of the US with a list of the cities chosen
    mainPanel(
      plotOutput("mapUSA"),
      tableOutput("view")
    )
  )
))