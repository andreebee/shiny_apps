# This is a copy of the global.r file, added to the app folder
#so that the app has access to it after deployment.

library(shiny)
library(shiny.i18n)

# File with translations
langList <- c("English" = "messageId",
              "German" = "de")

# Module UI function
languageSelector <- function(id, label = "Language Selector") {
  tagList(
    selectInput(NS(id, "langSelect"), label, choices = langList),
    textOutput(NS(id,"textTest"))
  )
}

languageServer <- function(id, translationsPath) {
  # File with translations
  translator <- Translator$new(translation_json_path = translationsPath)
  moduleServer(id, function(input, output, session) {
    i18n <- reactive({
      selected <- input$langSelect
      if(input$langSelect == 'messageId') {
        selected <- "en"
      }
        
      if (length(selected) > 0 && selected %in% translator$get_languages()) {
        translator$set_translation_language(selected)
      }
      translator
    })
    
    return(i18n)
  })
}


