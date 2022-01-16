# load packages
library(shiny)
library(shiny.i18n)

ui <- fluidPage(
  # adding a selector to choose the app language
  selectInput("language","please select language",c("en","de")),
  # using uiOutput to translate ui input elements
  uiOutput('page_content'),
  # adding a sample output elements
  textOutput("fruits")
)