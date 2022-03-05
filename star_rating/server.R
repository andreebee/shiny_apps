#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(rdrop2)
library(digest)

# Define the fields we want to save from the form
fields <- c("n_stars")

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  hide <- reactiveVal(0)
  
  observeEvent(input$submit, {
    hide(hide() + 1)
  })
    output$n_stars <- renderUI({
      if(hide()==0){
        sliderInput(inputId = "n_stars", label = "Ratings",
                    min = 1,  max = 5, value = 3, step = 1)   
      }
    })
    
    output$submit <- renderUI({
      if(hide()==0){
        actionButton("submit", "Submit")   
      } else {
        HTML(paste("<b>","Thank you!","</b>"))
      }
    })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })

  # to show the stars
  output$stars_ui <- renderUI({
    # to calculate our input %
    n_fill <- (input$n_stars / 5) * 100
    # element will look like this: <div class="full-stars" style="width:n%"></div>
    style_value <- sprintf("width:%s%%", n_fill)
    tags$div(class = "full-stars", style = style_value)
  })

  token <- reactive({
    readRDS("droptoken.rds")
  })
  
  # to save data
  saveData <- function(data) {
    token <- token()
    data <- t(data)
    # Create a unique file name
    fileName <- sprintf("%s_%s.csv", as.integer(Sys.time()), digest(data))
    # Write the data to a temporary file locally
    filePath <- file.path(tempdir(), fileName)
    write.csv(data, filePath, row.names = FALSE, quote = TRUE)
    # Upload the file to Dropbox
    drop_acc(dtoken = token)
    drop_upload(dtoken=token,filePath, path = "shinyapp")
  }
  
  # to load data
  loadData <- function() {
    token <- token()
    # Read all the files into a list
    drop_acc(dtoken = token)
    filesInfo <- drop_dir(dtoken=token,"shinyapp")
    filePaths <- filesInfo$path_display
    data <- lapply(filePaths, drop_read_csv,dtoken=token, stringsAsFactors = FALSE)
    # Concatenate all data together into one data.frame
    data <- do.call(rbind, data)
    data
  }
  
  # Whenever a field is filled, aggregate all form data
  formData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(formData())
  })
  
  # Show the previous responses
  # (update with current response when Submit is clicked)
  output$responses <- renderDataTable({
    input$submit
    loadData()
  })
  
}
