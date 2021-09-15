# **************************************************************************** #
# Representation of correlation
# Description:  How does the measure of association change based on the 
#               Cohen effect sizes? Representation of small, medium and 
#               large and negative connections / correlations.
# Ticket on 
# Trello board: https://trello.com/c/t7Z2AK6W/13-darstellung-von-korrelationen
# **************************************************************************** #

library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)
# Library MASS used for mvrnorm
library(MASS)
source("../global.R")

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
          style=" margin-right: 24px; 
                  margin-top: -8px;"), 
      "Visualisierung des Korrelationskoeffizienten"
    )
  ),
  sidebarLayout(
    sidebarPanel(
      languageSelector("langSelect"),
      sliderInput("covariance", 
                  label="r",
                  value= 0,
                  min=-1, 
                  max=1,
                  step = 0.1)
    ),
    mainPanel(
      tags$div(style="margin: auto;", 
          plotlyOutput("plot"),
      ),

      htmlOutput(style="display: flex;
              justify-content: center;
              margin: auto;
              margin-top: 40px;
              font-size: 14px","correlationLabel"),
    )
  )
)


# Function getCorrelationText() returns a vector with two values, color and 
# text indicating how strong a correlation is.
# Parameter (double):  Correlation number.     
# Returns (vector):    Color indicating the status of the correlation.
#                      Text making reference to how strong the correlation is.
getCorrelationText <- function(corrValue, i18n) {
  corrStatus <- c(i18n()$t("msg_linear_correlation"))
  green <- "green"
  yellow <- "#c1ae06"
  softGreen <- "#84d236"
  
  if(corrValue == 1 ) {
    corrStatus <- c(corrStatus, green, i18n()$t("msg_perf_pos"))
  } else if (corrValue == -1) {
    corrStatus <- c(corrStatus, green, i18n()$t("msg_perf_neg"))
  } else if (corrValue >= 0.3 && corrValue < 0.5) {
    corrStatus <- c(corrStatus, yellow, i18n()$t("msg_weak_pos"))
  } else if (corrValue > -0.5 && corrValue <= -0.3) {
    corrStatus <- c(corrStatus, yellow, i18n()$t("msg_weak_neg"))
  } else if (corrValue >= 0.5 && corrValue < 1) {
    corrStatus <- c(corrStatus, softGreen, i18n()$t("msg_strong_pos"))
  } else if (corrValue > -1 && corrValue <= -0.5 ) {
    corrStatus <- c(corrStatus, softGreen, i18n()$t("msg_strong_neg"))
  } else {
    corrStatus <- c(i18n()$t("msg_linear_relation"), "red", i18n()$t("msg_no"))
  }
  
  return(corrStatus)
}


server <- function(input, output, session) {
  # Localization
  i18n <-languageServer('langSelect', "./translations.json")
  
  # Listening to changes on correlation slider.
  corrSliderValue <- reactive({
    input$covariance
  })
  
  # Whenever the slider's value changes a new text is 
  # displayed indicating how strong the correlation is.
  output$correlationLabel <- renderText({
    
    correlationStatus <- getCorrelationText(corrSliderValue(), i18n)
    
    # Index 1 -> Linear Correlation text
    # Index 2 -> Color
    # Index 3 -> Correlation status
    correlationLinearText <- correlationStatus[1]
    correlationColor <- correlationStatus[2]
    correlationLabel <- correlationStatus[3]
    
    # Creating an HTML SPAN element in bold with a particular color and a text
    # indicating the correlation. By leveraging css styles we can change the 
    # color of the text depending on certain variable in this case the 
    # correlation.
    paste(
        "<span style='color: ", 
          correlationColor , "'>", 
          correlationLabel,
          "</span>",
        "<span style='display: block; color: black; margin-left: 6px'>",
          correlationLinearText,
        "</span>")
  })
  
  
  output$plot <- renderPlotly({ 
    #Constant variances used for covariance matrix
    var1 <- 1
    var2 <- 1

    # create the variance covariance matrix
    sigma <- rbind(
                    c(var1,              corrSliderValue()), 
                    c(corrSliderValue(), var2)
                  )
    
    # create the mean vector
    mu <- c(4, 4) 
    
    # generate the multivariate normal distribution
    df <- as.data.frame(mvrnorm(n=300, mu=mu, Sigma=sigma))
    
    # Formatting Axis labels and ranges.
    x <- list(
      title = "X",
      range = c(0, 8),
      constrain='domain'
    )
    y <- list(
      title = "Y",
      range = c(0, 8),
      scaleanchor = "x",
      scaleratio = 1
    )
    
    m <- list(
      l = 'auto',
      r = 'auto',
      b = 100,
      t = 100,
      pad = 4
    )
    
    
    # Scatter Plot Y vs X with a given correlation.
    plot_ly(data = df, x = ~df$V1, y = ~df$V2, type ='scatter', mode='markers',
            marker = list(size = 8,
                          color = '#145dada6',
                          line = list(color = '#145dad',
                                      width = 0.5))
            ) %>% 
      layout(xaxis = ~x, yaxis = ~y) %>% 
      layout(autosize = TRUE)

  })
}

shinyApp(ui, server)