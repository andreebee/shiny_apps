library(ggplot2)
library(lattice)
library(tibble)
library(plyr)
library(dplyr)
library(scales)


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
ui <- fluidPage(      
#####
  sliderInput("percentage", "Percentage of richiest to exclude",
              value=0,
              min=0, 
              max=maxPercentage),
  # Plot
  plotOutput("plot")
)

### Functions ###
getRowsToKeep <-  function(percentage) {
  percentageToDelete <- 1 - (((percentage * 100) / maxPercentage) / 100)
  rowsToKeep <- as.integer(numRows * percentageToDelete)
  
  return(rowsToKeep)
}
#####


server <- function(input, output) {
  # verhindert "Springen der Punkte"
  set.seed(10)
  
  # Plot zeichnen
  output$plot <-  renderPlot({
    rowsToKeep <- getRowsToKeep(input$percentage)
    filteredData <- rbind(incomes, tail(upIncomes,rowsToKeep))
    ggplot(filteredData, aes(x=TotalPay)) +
      geom_histogram() +
      #mean
      geom_vline(aes(xintercept=mean(TotalPay, na.rm=T), colour = "mean"),       
                 linetype="dashed", size=1)                                   +
      # blank, solid, dashed, dotted, dotdash, longdash, twodash
      #median
      geom_vline(aes(xintercept=median(TotalPay, na.rm=T), colour = "median"),   
                 linetype="longdash", size=1)         +
      scale_x_continuous(limits=c(0, 600000), labels = comma) +
      scale_colour_manual("legend", values = c("mean" = "blue", 
                                               "median" = "red"))   
  })
}

shinyApp(ui=ui, server = server)
