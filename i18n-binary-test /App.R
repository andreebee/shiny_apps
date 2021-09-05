library(shiny)
library(R.utils)
source("../binarySelector.R")

ui <- fluidPage(
  languageBinarySelector("langSelect"),
  uiOutput('page_content')
)


server <- function(input, output, session) {
  i18n <-languageBinaryServer('langSelect')
 
  output$page_content <- renderUI({
    tagList(
      p(i18n()(c("Hello World", "Hallo Welt")))
    )
  })
}

shinyApp(ui, server)
