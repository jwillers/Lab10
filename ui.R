library(shiny)
library(maps)
library(ggplot2)

data("us.cities")
us.cities$country.etc<-toupper(us.cities$country.etc)
StateList<-sort(unique(us.cities$country.etc))


# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Choose a route"),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view
  sidebarLayout(
    sidebarPanel(
      selectInput("stateset", "Choose a state:", 
                  choices = StateList),
      
      selectInput("cityset", "Choose a city:", choices = "First, select a state"),
      
      actionButton("updateData","Add to list")
      
    ),
        
   # Show a summary of the dataset and an HTML table with the 
   # requested number of observations
    mainPanel(
      plotOutput("mapUSA"),
      tableOutput("view")
    )
  )
))