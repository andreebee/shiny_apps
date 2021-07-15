library(dplyr)
library(shiny)
library(plotly)

load("salaries.RData")

### Cleaning dataset ###
  data <- data[!(is.na(data$BasePay)), ]
  data <- data[data$BasePay >= 200, ]
  data <- data %>% arrange(BasePay)
###

### Getting Highest values ###
  rowsData <- nrow(data)
   
  incomes <- data[0:as.integer(rowsData * 0.8),]
  upIncomes <- data[as.integer(rowsData * 0.8): nrow(data),]
  numRows <- nrow(upIncomes)
######

### Global Variables ###
  maxPercentage <- 20  
#####

### Functions ###
getRowsToKeep <-  function(percentage) {
  percentageToDelete <- 1 - (((percentage * 100) / maxPercentage) / 100)
  rowsToKeep <- as.integer(numRows * percentageToDelete)
  
  return(rowsToKeep)
}
#####

ui <- fluidPage(
  titlePanel('Verteilung Gehälter'),
  sidebarLayout(
    sidebarPanel(
      sliderInput("percentage", "Percentage of richiest to delete",
                  value=0,
                  min=0, 
                  max=maxPercentage)
    ),
    mainPanel(
      plotlyOutput("histogram")
    )
  )
)

server <- function(input, output, session) {
  output$histogram <- renderPlotly({
  
    rowsToKeep <- getRowsToKeep(input$percentage)
    filteredData <- rbind(incomes,upIncomes[0:rowsToKeep,])
    vline <- function(x = 0, color = "red") {
      list(
        type = "line", 
        y0 = 0, 
        y1 = 1, 
        yref = "paper",
        x0 = x, 
        x1 = x,
        line = list(color = color)
      )
    }
    
  meanValue <- mean(filteredData$BasePay)
  medianValue <- median(filteredData$BasePay) 
  h <- 37000
  
  plot_ly(filteredData) %>%
      add_histogram(
        x = ~BasePay, 
        nbinsx=20, 
        name = "Salary", 
        color = I("#0c3880")
      ) %>% 
      layout(
        xaxis = list(range = c(-10000, 419275)),
        yaxis = list(range = c(0,h))
      ) %>% 
      add_segments(x = meanValue, 
                    xend = meanValue + 1, 
                    y = 0,
                    yend = h, 
                    name = "Mean",
                    color = I("#636ef9"))  %>% 
      add_segments(x = medianValue, 
                    xend = medianValue + 1, 
                    y = 0, 
                    yend = h, 
                    name = "Median", 
                    color = I("#f96663"),
                    line = list(dash = "dash"))
  
  
    
  })
}

shinyApp(ui, server)