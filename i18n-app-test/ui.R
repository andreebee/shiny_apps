library(shiny)
library(R.utils)
source("../global.R")

ui <- fluidPage(
  languageSelector("langSelect"),
  uiOutput('page_content'),
  textOutput("hi")
)