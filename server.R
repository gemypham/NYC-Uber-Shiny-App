
## Please install the packages for it to work: 
# load data

load("Data/uber_2014.Rdata")
load("Data/Lyft_2014.Rdata")
load("Data/zone_txt.Rdata")


### Create a small dataset for borough and different time
by_borough_month <- uber_2014 %>%
  group_by(Borough, month ) %>%
  dplyr::summarize(Total = n()) 
by_dayofweek_borough <- uber_2014 %>%
  group_by(Borough, dayofweek ) %>%
  dplyr::summarize(Total = n()) 
by_borough_hour <- uber_2014 %>%
  group_by(Borough, hour ) %>%
  dplyr::summarize(Total = n()) 

##Lyft

lby_borough_month <- Lyft_2014 %>%
  group_by(Borough, month ) %>%
  dplyr::summarize(Total = n()) 
lby_dayofweek_borough <- Lyft_2014 %>%
  group_by(Borough, dayofweek ) %>%
  dplyr::summarize(Total = n()) 
lby_borough_hour <- Lyft_2014 %>%
  group_by(Borough, hour ) %>%
  dplyr::summarize(Total = n()) 

col=c('tomato','yellow','violetred','darkseagreen','turquoise','khaki','lightgreen',
      'orange','maroon','purple')
cols <- brewer.pal(8,"Set2")
colu <-brewer.pal(8,"Blues")
coll <-brewer.pal(8,"Reds")

shinyServer(
  function(input,output,session){
    #First Map#
    output$map <- renderLeaflet({
      leaflet() %>%
        addTiles(
          urlTemplate = "https://api.mapbox.com/styles/v1/gemypham/ciwbtzr4p004a2poc7896legr/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiZ2VteXBoYW0iLCJhIjoiY2l3YnEwcjU3MDY1NDJ6bzUwZW0wMng5cyJ9.btptNK6dBNOEVtD0CQzQlw",
          attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
        ) %>%
        setView(lng = -73.97, lat = 40.75, zoom = 13)
    # })
    # observe({
    #   leafletProxy("map", data = uber2014_April) %>%
    #     clearShapes() %>%
    #     addCircles(~Lon, ~Lat, radius=80, 
    #                stroke=FALSE, fillOpacity=0.4,popup = uber2014_April$hour,color ='blue') 
    #   # leafletProxy("map", data = uber_2014)%>%
      #   clearMarkers()%>%
      #   addCircles(~Lon, ~Lat, radius=80, popup =uber_2014$hour,
      #            stroke=FALSE, fillOpacity=0.4,color="blue")
        
    })
    
      output$borough_plot<-renderPlot({
        if(input$plot == "Uber"){
        b = plot(uber_2014$Borough,
                          ylab = "Number of pickups",
                          xlab = "Boroughs",
                          main = "Uber",
                          col = colu)
        print(b)
        }
        else {
          if(input$plot =="Lyft"){
        c <- plot(Lyft_2014$Borough,
                           ylab = "Number of pickups",
                           xlab = "Boroughs",
                           main = "Lyft",
                           col = coll)
        print(c)
          }
        }
        })
    
    output$scatterplot<-renderPlot({

        if (input$vary == "Day of Week") {
          p <- ggplot(by_dayofweek_borough, aes(dayofweek,Total, fill = Borough)) +
            geom_bar( stat = "identity") +
            ggtitle("Uber Trips by Day of Week in each Borough") +
            scale_y_continuous(labels = comma) +
            scale_fill_manual(values = cols) + facet_wrap( ~ Borough)

        }
        else {
           if (input$vary == "Month") {
             p <- ggplot(data=by_borough_month,aes(x=month, y=Total, fill = Borough))
             p <- p+ geom_bar( stat = "identity") +
               ggtitle("Uber Trips by Month in each Borough") +
               scale_y_continuous(labels = comma) +
               scale_fill_manual(values = col) + facet_wrap( ~ Borough)
           }
           else {
              if (input$vary == "Hour") {
                p <- ggplot(data=by_borough_hour,aes(x=hour, y=Total, fill = Borough))
                p <- p+ geom_bar( stat = "identity") +
                  ggtitle("Uber Trips by Hour in each Borough") +
                  scale_y_continuous(labels = comma) +
                  scale_fill_manual(values = col) + facet_wrap( ~ Borough)
              }
           }
        }

        p <- p + geom_jitter() 
        p <- p + geom_smooth(method = "lm")
        
        print(p)
    })
  
    output$scatterplotl <-renderPlot({
      
      if (input$vary == "Day of Week") {
        l <- ggplot(lby_dayofweek_borough, aes(dayofweek,Total, fill = Borough)) +
          geom_bar( stat = "identity") +
          ggtitle("Lyft Trips by Day of Week in each Borough") +
          scale_y_continuous(labels = comma) +
          scale_fill_manual(values = col) + facet_wrap( ~ Borough)
        
      }
      else {
        if (input$vary == "Month") {
          l <- ggplot(data=lby_borough_month,aes(x=month, y=Total, fill = Borough))
          l <- l+ geom_bar( stat = "identity") +
            ggtitle("Lyft Trips by Month in each Borough") +
            scale_y_continuous(labels = comma) +
            scale_fill_manual(values = col) + facet_wrap( ~ Borough)
        }
        else {
          if (input$vary == "Hour") {
            l <- ggplot(data=lby_borough_hour,aes(x=hour, y=Total, fill = Borough))
            l <- l+ geom_bar( stat = "identity") +
              ggtitle("Lyft Trips by Hour in each Borough") +
              scale_y_continuous(labels = comma) +
              scale_fill_manual(values = col) + facet_wrap( ~ Borough)
          }
        }
      }
      
      l <- l + geom_jitter() 
      # l <- l + geom_smooth(method = "lm")
      
      print(l)
      
    })
    rwd <- reactive({
      zone_txt
    })
    
    wordcloud_rep <- repeatable(wordcloud)
    output$wordcloud <- renderPlot({
      wordcloud_rep(
        words = rwd()$Zone,
        freq = rwd()$Total,
        scale = c(5, 1),
        min.freq = input$rfreq,
        max.words = input$rmax,
        rot.per = 0.2,
        random.order = F,
        colors = brewer.pal(8, "Dark2")
      )
    })
    
    output$ziptable <- DT::renderDataTable({
      df <- uber_2014 %>%
        arrange(., desc(dayofweek))
      DT::datatable(head(df,100), class = 'cell-border stripe', escape = FALSE)
      
    })
 
  }
)