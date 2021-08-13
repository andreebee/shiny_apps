# **************************************************************************** #
# Effect of outliers on mean (distribution of salaries)
# Description:  Application displaying a histogram with salaries distributions
#               where there is a 5% with high salaries affecting the 
#               median and mean values.
#               
# Ticket on 
# Trello board: https://trello.com/c/WqjcJllb/11-auswirkung-von-ausrei%C3%9Fern-auf-mittelwert-verteilung-geh%C3%A4lter
# **************************************************************************** #

library(ggplot2)
library(tibble)
library(plyr)
library(dplyr)
library(scales)
library(shinythemes)

salaries <- readRDS(file = "adjustedData.rds")

# Separating higher salaries from lower ones. 
incomes <-  as.data.frame(filter(salaries, TotalPay < 200000))

# Getting Highest salaries greater than 200k
upIncomes <- filter(salaries, TotalPay >= 200000)
upIncomes <- upIncomes %>% arrange(desc(TotalPay))
numRows <- nrow(upIncomes)


# Percentage of highest salaries to exclude on distribution.
maxPercentage <- 5 

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

# ***************** Functions ***************** #

# This function calculates the number of rows from the highest salaries to keep.
# @percentage: Percentage of rows to keep among the highest salaries previously
#             selected.
# @returns:   Number of rows to keep from the highest salaries previously chosen.
getRowsToKeep <-  function(percentage) {
  percentageToDelete <- 1 - (((percentage * 100) / maxPercentage) / 100)
  rowsToKeep <- as.integer(numRows * percentageToDelete)
  
  return(rowsToKeep)
}

# This function returns a formatted number replacing thousands by a K symbol
# @x: Number to be formatted
# @returns: Formatted number as a string.
formatNumK <- function(x) {
  x <- trunc(x)
  x <- round((x / 1000), digits=0)
  
  return (paste(toString(x), 'K'))
}
# ********************************************** #


server <- function(input, output) {
  set.seed(10)
  
  # Histogram
  output$plot <-  renderPlot({
    
    # Obtains the number of rows to keep from highest salaries based upon
    # percentaged selected by the user.
    rowsToKeep <- getRowsToKeep(input$percentage)

    # Combines incomes average salaries with the percentage of high salaries 
    # chosen to be kept on the distribution.
    filteredData <- rbind(incomes, tail(upIncomes, rowsToKeep))
    
    # Calculates and creates the label for the mean value to be 
    # displayed in the legend.
    meanFormatted <- formatNumK(mean(filteredData$TotalPay))
    meanValue <- paste('Mittel (', meanFormatted, ' )') 
    
    # Calculates and creates the label for the median value to be 
    # displayed in the legend.
    medianFormatted <- formatNumK(median(filteredData$TotalPay))
    medianValue <- paste('Mittelwert (', medianFormatted, ' )')
    
    # Original Dataset
    #totalIncomes <- rbind(incomes, upIncomes)
    
    
    ggplot(filteredData, aes(x=TotalPay)) +
      
      # Here two histograms are needed, the fisrt one in order 
      # to display the original information and will be placed 
      # at the back. The second histogram will display only the 
      # data selected after applying the percentage filter.
      # The effect these two histograms create are shadowing,
      # therefore it is possible to see which areas are been 
      # removed.
      geom_histogram(data = salaries, fill = "#0a279a", bins = 30) + 
      geom_histogram(fill = "#9fade5", bins = 30) +
      labs(x = "Brutto-Jahresgehalt (US-Dollar)", y = 'Anzahl') + 
      
      #mean line
      geom_vline(
        aes(xintercept = mean(TotalPay, na.rm = T), colour = "mean"),
        linetype="dashed", 
        size = 1
      ) +

      #median line
      geom_vline(
        aes(xintercept = median(TotalPay, na.rm = T),colour = "median"),
        linetype = "longdash", 
        size = 1
      ) +
      
      # x Axis
      scale_x_continuous(
        breaks = seq(from = 0, to = 600000, by = 50000), 
        labels = scales::dollar_format(scale = .001, suffix = "K")
      ) +
      
      # legend
      scale_colour_manual("Beschriftung", 
        values = c("mean" = "blue", "median" = "red"), 
        labels = c(meanValue, medianValue)
      ) 
  })
}

shinyApp(ui = ui, server = server)
