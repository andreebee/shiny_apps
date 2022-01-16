# load packages
library(shiny)
library(shiny.i18n)

# loading the json file 
i18n <- Translator$new(translation_json_path = "./translations.json")

server <- function(input, output, session) {
  
  # creating a reactive variable to switch between language according to the language selectinput
  t <- reactive({
    if (input$language=='en'){
      i18n$set_translation_language("en")
    } else{
      i18n$set_translation_language("de")
    }
  })
  
  output$page_content <- renderUI({
    # run the reactive variable to translate
    t()
    # using taglist to add multiple ui input and elements
    tagList(
      # using i18n$t to translate the text
      p(i18n$t("Hello World")),
      p(i18n$t("Hi there"))
    )
  })
  
  output$fruits <- renderText({
    # run the reactive variable to translate
    t()
    # using i18n()$t to translate the text
    i18n$t("Fruits")
  })
}