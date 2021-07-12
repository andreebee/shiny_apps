library(plotly)
library(dplyr)
library(shiny)

load("salaries.RData")

### Cleaning dataset ###
  data <- data[!(is.na(data$BasePay)), ]
  data <- data[data$BasePay >= 200, ]
  data <- data %>% arrange(BasePay)
###

### Initialization of variables ###
  minIncomeValue <- min(data$BasePay, na.rm = TRUE)
  maxIncomeValue <- max(data$BasePay, na.rm = TRUE)
###
  
### Outlier Detection ###
  iqr <- IQR(data$BasePay)
  Q <- quantile(data$BasePay, probs=c(.25, .75))
  up <-  Q[2] + (1.5*iqr) # Upper Range  
  low<- Q[1]-1.5*iqr # Lower Range
  
  incomes <- subset(data, data$BasePay < up)
  upIncomes <- subset(data, data$BasePay >= up)
  numRows <- nrow(upIncomes)
######

ui <- fluidPage(
  titlePanel('Verteilung Gehälter'),
  sidebarLayout(
    sidebarPanel(
      sliderInput("percentage", "Percentage",
                  value=c(0, 0),
                  min=0, 
                  max=70)
    ),
    mainPanel(
      plotlyOutput("histogram")
    )
  )
)

server <- function(input, output, session) {
  output$histogram <- renderPlotly({
  
    percentage <- as.integer(numRows * (input$percentage[2] / 100) )
    
    sliderPercentage <- (input$percentage[2] / 100)  # 0.2 , 0.3
    percentageToKeep <- 1 - sliderPercentage
    rowToKeep <- as.integer(numRows * percentageToKeep)
    
    
    plot_ly(rbind(incomes,upIncomes[0:rowToKeep,]), x = ~BasePay, nbinsx=20) %>%
      add_histogram()
  })
}

shinyApp(ui, server)