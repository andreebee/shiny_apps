#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define the fields we want to save from the form
fields <- c("name","n_stars")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
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
  
  # to save data
  saveData <- function(data) {
    data <- as.data.frame(t(data))
    if (exists("responses")) {
      responses <<- rbind(responses, data)
    } else {
      responses <<- data
    }
  }
  
  output$text <- renderText({
    session$request$REMOTE_ADDR
    })
  
  
  # to load data
  loadData <- function() {
    if (exists("responses")) {
      datatable(data.frame(
        responses
        ),
        # to remove search bar
        options = list(dom = 't'))
    }
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
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })

})
