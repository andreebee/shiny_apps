# load packages and global.r for translation
library(shiny)
library(R.utils)
source("../global.R")

server <- function(input, output, session) {
  i18n <-languageServer('langSelect', "./translations.json")

  output$page_content <- renderUI({
    # using taglist to add multiple ui input and elements
    tagList(
      # using i18n()$t to translate the text
      p(i18n()$t("msg_HiThere")),
      p(i18n()$t("msg_Fruits"))
    )
  })
  
  output$hi <- renderText({
    # using i18n()$t to translate the text
    i18n()$t("msg_HelloWorld")
  })
}