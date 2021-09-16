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

# Percentage of highest salaries to exclude on distribution.
maxPercentage <- 5 

salaries <- readRDS(file = "adjustedData.rds")

# Using an upper bound of 5% to detect outliers, 
# that for this scenario are the richest salaries among the Dataset.
upperBound <- quantile(salaries$TotalPay, 0.950)

# Separating higher salaries from lower ones. 
incomes <-  as.data.frame(filter(salaries, TotalPay < upperBound))

# Getting Highest salaries greater than upperBound
upIncomes <- filter(salaries, TotalPay >= upperBound)
upIncomes <- upIncomes %>% arrange(desc(TotalPay))
numRows <- nrow(upIncomes)


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
  
  return (paste(toString(x), "K"))
}
# ********************************************** #




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


server <- function(input, output) {
  set.seed(10)
  
  # Histogram
  output$plot <-  renderPlot({
    rowsToKeep <- getRowsToKeep(input$percentage)
    filteredData <- rbind(incomes, tail(upIncomes, rowsToKeep))
    
    # Calculates and creates the label for the mean value to be 
    # displayed in the legend.
    meanValue <- mean(filteredData$TotalPay, na.rm =T) 
    meanAnnotation <- paste('Mittelwert (', formatNumK(meanValue), ')')  
    
    # Calculates and creates the label for the median value to be 
    # displayed in the legend.
    medianValue <- median(filteredData$TotalPay, na.rm =T)
    medianAnnotation <- paste('Median (', formatNumK(medianValue), ')')
    
    ggplot(filteredData, aes(x=TotalPay)) +
      
      # Here two histograms are needed, the first one in order 
      # to display the original information and will be placed 
      # at the back. The second histogram will display only the 
      # data selected after applying the percentage filter.
      # The effect these two histograms create is shadowing,
      # therefore it is possible to see which areas are been 
      # removed since both are overlaping one over the other one.
      geom_histogram(data = salaries, 
                     fill = "#9fade5", 
                     bins = 30,
                     breaks = seq(from = 1000, to = 600000, by = 25000)) +
      geom_histogram(fill = "#050558", 
                     bins = 30, 
                     colour='#b8b8e8', 
                     size=0.5,
                     breaks = seq(from = 1000, to = 600000, by = 25000)) +
      labs(x = "Brutto-Jahresgehalt (in Tausend US-Dollar)", y = 'Anzahl') + 
    
      #mean line
      geom_vline(
        aes(xintercept = meanValue, colour = "mean"),
        data.frame(),
        linetype="dashed", 
        size = 1
      ) +

      annotate("text", 
                angle = 90, 
                x = meanValue + (meanValue * 0.1), 
                y = 10000, 
                label = meanAnnotation, 
                color = "white",
                fontface = "bold") + 
      
      #median line
      geom_vline(
        aes(xintercept = medianValue, colour = "median"),
        data.frame(),
        linetype = "longdash", 
        size = 1
      ) +
      
      annotate("text", 
               angle = 90, 
               x = medianValue - (medianValue * 0.1), 
               y = 10000, 
               label = medianAnnotation, 
               color = "white",
               fontface = "bold") + 
      
      # x Axis
      scale_x_continuous(
        breaks = seq(from = 1000, to = 600000, by = 25000), 
        labels = scales::number_format(scale = .001, suffix = "K")
      ) +
      
      # legend
      scale_colour_manual("Beschriftung", 
        values = c("mean" = "blue", "median" = "red"), 
        labels = c("Mittelwert", "Median")
      ) 
      
  }) %>% 
    bindCache(input$percentage)
}

shinyApp(ui = ui, server = server)
