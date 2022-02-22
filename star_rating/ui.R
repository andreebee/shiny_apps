#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(rdrop2)
library(digest)

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
      
      # rate the app
      includeCSS("www/stars.css"),
      
      # to rate using slider input
      uiOutput("n_stars"),
      
      tags$div(class = "ratings",
      tags$div(class = "empty-stars",
             uiOutput("stars_ui")
      )
      ),
      # to save the rating
      uiOutput("submit")
    ),
    
    mainPanel(
      # Show a plot of the generated distribution
      plotOutput("distPlot"),
      # ratings
      dataTableOutput("responses", width = 300), tags$hr()
    )
  )
  
  
    
  
))
