library(shiny)
library(R.utils)
source("../global.R")

server <- function(input, output, session) {
  i18n <-languageServer('langSelect', "./translations.json")

  output$page_content <- renderUI({
    tagList(
      p(i18n()$t("msg_HiThere")),
      p(i18n()$t("msg_Fruits"))
    )
  })
  
  output$hi <- renderText({
    i18n()$t("msg_HelloWorld")
  })
}