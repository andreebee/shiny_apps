# **************************************************************************** #
# DARSTELLUNG VON KORRELATIONEN
# Description:  How does the measure of association change based on the 
#               Cohen effect sizes? Representation of small, medium and 
#               large and negative connections / correlations.
# Trello Id:    https://trello.com/c/t7Z2AK6W/13-darstellung-von-korrelationen
# **************************************************************************** #

library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
# Library MASS used for mvrnorm
library(MASS)

# Planting a seed so that random values 
# will be the same on every computer
set.seed(5)

ui <- fluidPage(
  theme = shinytheme("paper"),
  navbarPage(
    title=div(
      # Navigation Bar Logo and Title
      img(src='htw-logo.png', 
          height="30px", 
          width="100px", 
          style="margin-right: 24px; margin-top: -8px;"), 
      "Visualization of correlation")
  ),
  sidebarLayout(
    sidebarPanel(
      sliderInput("covariance", 
                  label="r",
                  value= 0,
                  min=-1, 
                  max=1,
                  step = 0.1),
      htmlOutput("correlationLabel")
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
)

# It returns a vector with two values, color and text indicating how
# strong a correlation is.
# Parameter (double):  Covariance number.     
# Returns (vector):    Color indicating the status of the correlation.
#                      Text making reference to how strong the correlation is.
getCorrelationText <- function(cov) {
  correlationStatus <- c("red","No")
  green <- "green"
  yellow <- "#c1ae06"
  softGreen <- "#84d236"
  
  if(cov == 1 ) {
    correlationStatus <- c(green, "Perfect positive")
  } else if (cov == -1) {
    correlationStatus <- c(green, "Perfect negative")
  } else if (cov >= 0.3 && cov < 0.5) {
    correlationStatus <- c(yellow, "Weak positive")
  } else if (cov > -0.5 && cov <= -0.3) {
    correlationStatus <- c(yellow, "Weak negative")
  } else if (cov >= 0.5 && cov < 1) {
    correlationStatus <- c(softGreen, "Strong positive")
  } else if (cov > -1 && cov <= -0.5 ) {
    correlationStatus <- c(softGreen, "Strong negative")
  }
  
  return(correlationStatus)
}


server <- function(input, output, session) {
  # Listening to changes on covariance slider.
  cov <- reactive({
    input$covariance
  })
  
  # Whenever the slider's value changes a new text is 
  # displayed indicating how strong the correlation is 
  output$correlationLabel <- renderText({
    correlationStatus <- getCorrelationText(cov())
    correlationColor <- correlationStatus[1]
    correlationLabel <- correlationStatus[2]
    
    ## Creating an HTML SPAN element in bold
    ## with a particular color and a text indicating
    ## the correlation
    paste("<b><span style='color: ", 
          correlationColor , "'>", 
          correlationLabel, 
          ' linear correlation', 
          "</span></b>")
  })
  
  
  output$plot <- renderPlotly({ 
    #Variances
    var1 <- 1
    var2 <- 1

    # create the variance covariance matrix
    sigma<-rbind(c(var1, cov()), c(cov(), var2))
    
    # create the mean vector
    mu<-c(4, 4) 
    
    # generate the multivariate normal distribution
    df<-as.data.frame(mvrnorm(n=1000, mu=mu, Sigma=sigma))
    
    # Formatting Axis labels and ranges.
    x <- list(
      title = "X",
      range = c(0, 8)
    )
    y <- list(
      title = "Y",
      range = c(0, 10)
    )
    
    # Plotly featuring the Covariance and correlation 
    plot_ly(data = df, x = ~df$V1, y = ~df$V2) %>% 
      layout(xaxis = x, yaxis = y)

  })
}

shinyApp(ui, server)