library(shiny)
library(shiny.i18n)

# File with translations
langList <- c("English" = "en",
              "German" = "de",
              "Spanish" = "es")

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
      if (length(selected) > 0 && selected %in% translator$get_languages()) {
        translator$set_translation_language(selected)
      }
      translator
    })
    
    return(i18n)
  })
}


