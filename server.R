library("shiny")

data("us.cities")
us.cities$country.etc<-toupper(us.cities$country.etc)
StateList<-sort(unique(us.cities$country.etc))
us.cities$name<-substr(us.cities$name,1,nchar(us.cities$name)-3)

datalist <- head(us.cities,2)
# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output, session) {
  
  observe({
    cities <- subset(us.cities,country.etc == input$stateset)$name
    updateSelectInput(session, "cityset", choices = cities)  
  })
  
  observe({
    input$updateData
    datalist<-rbind(datalist,subset(us.cities, name == input$cityset))
  })
  
  output$mapUSA <- renderPlot({
    map('usa')
    if (nrow(datalist)>0) {
      points(datalist$long, datalist$lat)
      lines(datalist$long,datalist$lat)
    }  
    if (input$cityset != "") {
      citCoord<-unlist(subset(us.cities,name == input$cityset,select=c(long,lat)))
      points(citCoord[[1]], citCoord[[2]])
    }
  })
  output$view <- renderTable({
    datalist
  })
  
})