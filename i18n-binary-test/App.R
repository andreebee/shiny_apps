library(shiny)
library(R.utils)
source("../binarySelector.R")
#Variant for little text

ui <- fluidPage(
  languageBinarySelector("langSelect"), # Dropdownmenu: select language
  uiOutput('page_content')
)

server <- function(input, output, session) {
  i18n <-languageBinaryServer('langSelect')
 
  output$page_content <- renderUI({
    tagList(
      p(i18n()(c("Hello World", "Hallo Welt"))),
      p(i18n()(c("Fruits", "Obst")))
    )
  })
}

shinyApp(ui, server)
