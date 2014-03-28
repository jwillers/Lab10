library(shiny)
library(maps)
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
# Initialize a data frame with Ames, IA
datalist <- subset(us.cities,city == "Ames" & state == 'IA')

## The main function for the map
shinyServer(function(input, output, session) {
  # Take the data frame and make a reactive counterpart
  values<-reactiveValues()
  values$datalist<-datalist
  
  # Watch the state selector and if changed, update the cityset
  observe({
    cities <- subset(us.cities,state == input$stateset)$city
    updateSelectInput(session, "cityset", choices = cities)  
  })
  
  # Watch the updateData action button and change the data frame if clicked
  observe({
    # This just watches for a click
    input$updateData 
    # Update the dataframe, but isolate so it does trigger on
    # values$datalist (This prevents an infinite loop),
    # input$cityset or input$stateset so that points aren't added until the button is pushed
    values$datalist<-rbind(isolate(values$datalist),subset(us.cities, city == isolate(input$cityset)&state == isolate(input$stateset)))
  })
  
  # Make the map
  output$mapUSA <- renderPlot({
    map('usa')
    # Make sure to show only when we have data
    if (nrow(values$datalist)>0) {
      # Make the point, then draw the lines
      points(values$datalist$long, values$datalist$lat)
      lines(values$datalist$long, values$datalist$lat)
    }  
    # When a city is selected, show the point without the line
    if (input$cityset != "") {
      citCoord<-unlist(subset(us.cities,city == input$cityset,select=c(long,lat)))
      points(citCoord[[1]], citCoord[[2]])
    }
  })
  # Show the list of cities only if one has been added
  output$view <- renderTable({
    if(nrow(values$datalist)>0) values$datalist[,1:5]
  })
  
})