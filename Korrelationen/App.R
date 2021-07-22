library(shiny)
library(shinythemes)
# Library MASS used for mvrnorm
library(MASS)
library(tidyverse)
library(plotly)


set.seed(5)

ui <- fluidPage(
  theme = shinytheme("paper"),
  navbarPage(
    title=div(
      img(src='htw-logo.png', 
          height="30px", 
          width="100px", 
          style="margin-right: 24px; margin-top: -8px;"), 
      "Visualization of correlation")
  ),
  sidebarLayout(
    sidebarPanel(
      sliderInput("covariance", "r",
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


getCorrelationText <- function(cov) {
  correlationStatus <- c("red","No")
  green <- "green"
  yellow <- "#c1ae06"
  softGreen <- "#84d236"
  
  if(cov == 1 ) {
    correlationStatus <- c(green, "Perfect postive")
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

  cov <- reactive({
    input$covariance
  })
  
  output$correlationLabel <- renderText({
    correlationStatus <- getCorrelationText(cov())
    paste("<b><span style='color: ", correlationStatus[1] , "'>", correlationStatus[2], ' linear correlation', "</span></b>")
    
  })
  
  
  output$plot <- renderPlotly({ 
    var1 <- 1
    var2 <- 1
    

    # create the variance covariance matrix
    sigma<-rbind(c(var1, cov()), c(cov(), var2))
    # create the mean vector
    mu<-c(4, 4) 
    # generate the multivariate normal distribution
    df<-as.data.frame(mvrnorm(n=1000, mu=mu, Sigma=sigma))
    
    
    x <- list(
      title = "X",
      range = c(0, 10)
    )
    y <- list(
      title = "Y",
      range = c(0, 10)
    )
    
    plot_ly(data = df, x = ~df$V1, y = ~df$V2) %>% 
      layout(xaxis = x, yaxis = y)

  })
 
}

shinyApp(ui, server)