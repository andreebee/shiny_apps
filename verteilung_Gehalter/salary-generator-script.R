# **************************************************************************** #
# Salary Generator Script
# Description:  The purpose of this script is to generate high salary values 
#               entries in order to produce a right skewed distribution with 
#               a long tail and therefore show the effects of such values among
#               median and mean.
# Ticket on 
# Trello board: https://trello.com/c/WqjcJllb/11-auswirkung-von-ausrei%C3%9Fern-auf-mittelwert-verteilung-geh%C3%A4lter
# **************************************************************************** #

# Original Dataset with salaries obtained 
# from Kaggle https://www.kaggle.com/datasets
data <- read.csv(file = 'Salaries.csv')

# Extracting the Salary column
TotalPays <- as.data.frame(data$TotalPay)

# After creating a histogram of the original DataSet, it was noticed that 
# salaries distribution started decreasing at 210k, then this value will be used
# to generate a fake long tail of salaries distribution by increasing its value.
salaryValue <- 210000

# this is the initial frequency of salaries at 210k, this value will be the 
# starting point for the generated salaries frequency which will be decreasing 
# while salaries value increase.
till <- 180

# The idea here is to create salary values until reaching a value of 600k
while (salaryValue < 600000) {
  
  # This is the counter of the amount of new rows created per salary value.
  i <- 0
  
  while (i < till) {
    # Creating a new entry in DataFrame format with the new generated value for 
    # the salary.
    newRow <- data.frame(salaryValue);
    
    # Assigning the Column's name same as the original DataSet.
    names(newRow) <- c("TotalPay")  
    
    # Concatenating values existing list of payments with the
    # new brand generated salary value.
    TotalPays <- rbind(TotalPays, newRow)
    
    # It will keep adding the same Salary value to the DataFrame until 
    # reaching the (till) value.
    i <- i + 1
  }
  
  # At every iteration the frequency decreases by 2
  till <- till - 2
  
  # same as with salary at every iteration the frequency decreases by 2
  salaryValue = salaryValue + 5000
}

# renaming the final DataSet to salaries, it will import 
salaries <- TotalPays

saveRDS(salaries, file = "adjustedData.rds")
