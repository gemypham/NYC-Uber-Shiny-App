library(shiny)
library(markdown)
library(leaflet)
library(shinythemes)

TimeRange <- c(
  "0:00-1:00"=0,
  "1:00-2:00"=1,
  "2:00-3:00"=2,"3:00-4:00"=3, "4:00-5:00"=4, "5:00-6:00"=5,
  "6:00-7:00"=6,
  "7:00-8:00"=7, "8:00-9:00"=8, "9:00-10:00"=9, 
  "10:00-11:00"=10 , "11:00-12:00"=11, "12:00-13:00"=12 ,
  "13:00-14:00"=13 , "14:00-15:00"=14, "15:00-16:00"=15 ,
  "16:00-17:00"=16 , "17:00-18:00"=17 , "18:00-19:00"=18 ,
  "19:00-20:00"=19 , "20:00-21:00"=20, "21:00-22:00"=21,
  "22:00-23:00"=22, "23:00-24:00"=23 
)
 #WeekRange <- c("April" =Apr, "May" = May, "June" = Jun, "July"= July, "August" = Aug, "Septembr"=Sep)

shinyUI(navbarPage(title ="UBER Pickups in New York City",
                   id = "nav",
                   theme = shinytheme("cosmo"),
                   tabPanel("NYC Map",
                            # div() :HTML Builder Functions,return objects that can be rendered as HTML
                            div(class="outer",
                                
                                tags$head(
                                  # Include our custom CSS
                                  includeCSS("style.css"),
                                  includeScript("gomap.js")
                                ),
                                
                                leafletOutput("map", width="100%", height="100%"),
                                
                                # Shiny versions prior to 0.11 should use class="modal" instead.
                                absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                              draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                              width = 330, height = "auto",h2(img(src = "rex2.png", height =40)
                                                                             ),
                                              # h3() is the title for the first map.
                              
                                              h2("Uber Pickups in NYC in April"),
                                              h4('This map shows the number of Uber trips 
                                                 during the month of April 2014')
                                            
                                              
                                              ### 1. first option: time range
                                              # after choosing time range
                                              # the map should show the avaibility for all bike stations in this period of time
                                              #,selectInput("TimeRange", "Time Range of the day", TimeRange,selected=1)                                           
                                              
                                              
                                )
                            ) # end of dev()
                            
                            
                            ##### end of the first map
                   ),
                   tabPanel("Visualise UBER Activity",
                            
                            sidebarLayout(
                              sidebarPanel(
                                h3("Busiest Time in NYC Borough for Uber and Lyft"),
                                helpText("Select a time to plot number of Uber and Lyft trips in each borough."),
                                selectInput("vary", "Time:",
                                            choices =c("Month","Day of Week","Hour")
                                
                                            
                                # ),
                                # h3("Lyft's Busiest Time in NYC Borough"),
                                # helpText("Select a time to plot number of Lyft's trips in each borough."),
                                # selectInput("vary", "Time:",
                                #             choices =c("Month","Day of Week","Hour")
                                            
                                            
                                )
                                
                                
                                ,
                                hr(),
                                h3("Exploring Uber and Lyft"),
                                helpText("Select the company to plot."),
                                selectInput("plot","Company",
                                            choices = c("Uber"="Uber",
                                                        "Lyft"="Lyft")
                                )
                               
                            ),
                            mainPanel(
                              plotOutput("scatterplot", height="500px"),
                              plotOutput("scatterplotl", height="500px"),
                              plotOutput("borough_plot", height="300px")
                            
                            )
                   )
                   ),
                   
                 
                   tabPanel("Word Cloud: Zones",
                            fluidRow(
                              column(
                                3,
                                h2("Word Cloud"),
                                br(),
                                br(),
                                sliderInput(
                                  "rfreq",
                                  h4("Minimum Frequency:"),
                                  min = 1000,
                                  max = 176800,
                                  value = 20000
                                ),
                             
                                sliderInput(
                                  "rmax",
                                  h4("Maximum Number of Zones:"),
                                  min = 1,
                                  max = 258,
                                  value = 160
                                )
                              ),
                              
                              column(
                                9,
                                h2("Which NYC Zone requested Uber the most:"),
                                
                                plotOutput("wordcloud", height = 500),
                                hr()
                                # ,DT::dataTableOutput("ziptable")
                              )
                            )),
                   # tabPanel("Dataset",
                   #          sidebarLayout(
                   #            sidebarPanel(
                   #              h3("Busiest Time in NYC Borough for Uber and Lyft"),
                   #              helpText("Select a time to plot number of Uber and Lyft trips in each borough.")
                   #            ),
                   # 
                   #   mainPanel(
                   #     hr(),
                   #     DT::dataTableOutput("ziptable")
                   # 
                   # 
                   #   )
                   # ),

                   tabPanel("The Dataset",

                            mainPanel(
                              img(
                                src = "uber8.png",
                                height = 500,
                                weight = 800),
                              h2(),
                              strong('Snapshot of our Uber Dataset'),
                              DT::dataTableOutput("ziptable")
                              
                              
                            )
                   ),
                   tabPanel("About App",img(
                     src = "rex.png",
                     height = 100,
                     weight = 100)
                     
                     ,
                     mainPanel(
                       includeMarkdown("about.Rmd")
                       
                     )
                   )
)
)
