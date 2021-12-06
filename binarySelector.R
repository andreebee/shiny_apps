library(shiny)

# File with translations
langList <- c("English" = "en",
              "German" = "de")

# Module UI function
languageBinarySelector <- function(id, label = "Language Selector") {
  tagList(
    selectInput(NS(id, "langSelect"), label, choices = langList),
    textOutput(NS(id, "textTest"))
  )
}

languageBinaryServer <- function(id, translationsPath) {
  # File with translations
  moduleServer(id, function(input, output, session) {
    i18n <- reactive({
      selected <- input$langSelect
      
      chooseTranslation <- function(vector) {
        if(selected == "en"){
          return(vector[1])
        }
        return(vector[2])
      }
      
      return(chooseTranslation)
    })
    
    return(i18n)
  })
}


