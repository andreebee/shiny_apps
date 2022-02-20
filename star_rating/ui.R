#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)



# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      # name
      textInput("name","Name"),
      
      # rate the app
      includeCSS("www/stars.css"),
      sliderInput(inputId = "n_stars", label = "Ratings", min = 0,  max = 5, value = 3, step = 0.5),
      tags$div(class = "ratings",
               tags$div(class = "empty-stars",
                        uiOutput("stars_ui")
               )
      ),
      # to save the rating
      actionButton("submit", "Submit")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      DT::dataTableOutput("responses", width = 300), tags$hr(),
      textOutput("text")
    )
  )
  
  
    
  
))
