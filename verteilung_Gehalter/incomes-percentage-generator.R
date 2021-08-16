
library(ggplot2)
library(tibble)
library(plyr)
library(dplyr)
library(scales)
library(shinythemes)
library(tidyverse)

salaries <- readRDS(file = "adjustedData.rds")
print('executing this again')

# Separating higher salaries from lower ones. 
incomes <-  as.data.frame(filter(salaries, TotalPay < 200000))

# Getting Highest salaries greater than 200k
upIncomes <- filter(salaries, TotalPay >= 200000)
upIncomes <- upIncomes %>% arrange(desc(TotalPay))
numRows <- nrow(upIncomes)


# Percentage of highest salaries to exclude on distribution.
maxPercentage <- 5 

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
  
  return (paste(toString(x), "K"))
}
# ********************************************** #


rowsToKeep1 <- getRowsToKeep(1)
filteredData1 <- rbind(incomes, tail(upIncomes, rowsToKeep1))

# Save an object to a file
saveRDS(filteredData1, file = "incomes_1_percent.rds")

rowsToKeep2 <- getRowsToKeep(2)
filteredData2 <- rbind(incomes, tail(upIncomes, rowsToKeep2))

# Save an object to a file
saveRDS(filteredData2, file = "incomes_2_percent.rds")


rowsToKeep3 <- getRowsToKeep(3)
filteredData3 <- rbind(incomes, tail(upIncomes, rowsToKeep3))

# Save an object to a file
saveRDS(filteredData3, file = "incomes_3_percent.rds")

rowsToKeep4 <- getRowsToKeep(4)
filteredData4 <- rbind(incomes, tail(upIncomes, rowsToKeep4))

# Save an object to a file
saveRDS(filteredData4, file = "incomes_4_percent.rds")


rowsToKeep5 <- getRowsToKeep(5)
filteredData5 <- rbind(incomes, tail(upIncomes, rowsToKeep5))

# Save an object to a file
saveRDS(filteredData5, file = "incomes_5_percent.rds")
