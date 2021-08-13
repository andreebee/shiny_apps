# **************************************************************************** #
# Representation of correlation
# Description:  How does the measure of association change based on the 
#               Cohen effect sizes? Representation of small, medium and 
#               large and negative connections / correlations.
# Ticket on 
# Trello board: https://trello.com/c/t7Z2AK6W/13-darstellung-von-korrelationen
# **************************************************************************** #

library(ggplot2)
library(tibble)
library(plyr)
library(dplyr)
library(scales)
library(shinythemes)

salaries <- readRDS(file = "adjustedData.rds")

### Getting Highest values ###
rowsData <- nrow(salaries)

incomes <-  as.data.frame(filter(salaries, TotalPay < 200000))
upIncomes <- filter(salaries, TotalPay >= 200000)
upIncomes <- upIncomes %>% arrange(desc(TotalPay))
numRows <- nrow(upIncomes)
######


### Global Variables ###
maxPercentage <- 5 
#####

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
      "Einkommensverteilung"
    )
  ),
  fluidRow(
    column(6,
      p("Schließe folgenden Prozentsatz der Reichsten von der Berechnung aus:"),
      div(
        sliderInput("percentage",
          label= "",
          value=0,
          min=0, 
          max=maxPercentage),
        style="margin-top:-36px;")
    ),
  ),
  
  
  # Plot
  plotOutput("plot")
)

### Functions ###
getRowsToKeep <-  function(percentage) {
  percentageToDelete <- 1 - (((percentage * 100) / maxPercentage) / 100)
  rowsToKeep <- as.integer(numRows * percentageToDelete)
  
  return(rowsToKeep)
}

formatNumK <- function(x) {
  x <- trunc(x)
  x <- round((x / 1000), digits=0) 
  return (paste(toString(x), 'K'))
}

#####


server <- function(input, output) {
  # verhindert "Springen der Punkte"
  set.seed(10)
  
  # Plot zeichnen
  output$plot <-  renderPlot({
    rowsToKeep <- getRowsToKeep(input$percentage)
    filteredData <- rbind(incomes, tail(upIncomes,rowsToKeep))
    
    meanFormatted <- formatNumK(mean(filteredData$TotalPay))
    meanValue <- paste('Mittel (', meanFormatted, ' )') 
    
    medianFormatted <- formatNumK(median(filteredData$TotalPay))
    medianValue <- paste('Mittelwert (', medianFormatted, ' )')
    
    totalIncomes <- rbind(incomes, upIncomes)
    
    ggplot(filteredData, aes(x=TotalPay)) +
      geom_histogram(data=totalIncomes, fill="#0a279a", bins = 30) + 
      geom_histogram(fill="#9fade5", bins = 30) +
      labs(x = "Brutto-Jahresgehalt (US-Dollar)", y = 'Anzahl') + 
      
      #mean
      geom_vline(
        aes(xintercept = mean(TotalPay, na.rm = T),colour = "mean"),
        linetype="dashed", 
        size=1
      ) +

      #median
      geom_vline(
        aes(xintercept = median(TotalPay, na.rm=T),colour = "median"),
        linetype="longdash", 
        size=1
      ) +
      
      # x Axis
      scale_x_continuous(
        breaks = seq(from = 0, to = 600000, by = 50000), 
        labels = scales::dollar_format(scale = .001, suffix = "K")
      ) +
      
      # legend
      scale_colour_manual("Beschriftung", 
                          values = c("mean" = "blue", "median" = "red"), 
                          labels = c(meanValue, medianValue)) 
  })
}

shinyApp(ui=ui, server = server)
