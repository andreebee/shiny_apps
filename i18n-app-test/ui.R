# load packages and global.r for translation
library(shiny)
library(R.utils)
source("../global.R")

ui <- fluidPage(
  # adding a selector to choose the app language
  languageSelector("langSelect"),
  # using uiOutput to translate ui input elements
  uiOutput('page_content'),
  # adding a sample output elements
  textOutput("hi")
)