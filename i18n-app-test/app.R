library(shiny)
library(R.utils)
source("../global.R")

ui <- fluidPage(
  languageSelector("langSelect"),
  textOutput("text"),
  uiOutput('page_content')
)


server <- function(input, output, session) {
  i18n <-languageServer('langSelect', "./translations.json")

  output$page_content <- renderUI({
    tagList(
      p(i18n()$t("Hello World"))
    )
  })
}

shinyApp(ui, server)
