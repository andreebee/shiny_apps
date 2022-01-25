library(shiny)
library(tidyverse)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./translation.json")

# Define UI for application that draws two normal distributions using given mean and standard deviation
ui <- fluidPage(
  
    # language selector
    selectInput("language","please select language",c("en","de")),
    
    # Application title
    conditionalPanel(
      condition = "input.language == 'en'",
      conditionalPanel('false', i18n$set_translation_language("en")),
      titlePanel(i18n$t("Compare 2 normal distributions"))
    ),
    conditionalPanel(
      condition = "input.language == 'de'",
      conditionalPanel('false', i18n$set_translation_language("de")),
      titlePanel(i18n$t("Compare 2 normal distributions"))
    ),
    
    sidebarLayout(
      # For getting the mean and std of 2 variables
      # and specifying the alpha to shade the alpha and 1-beta in the graph
      sidebarPanel(
        uiOutput("multi"),
        sliderInput("alpha","Alpha:",min = 0.01,max = 0.20,value = 0.05,step = 0.01)
      ),

        # Show plots of the generated distribution
        mainPanel(
           textOutput("title"),
           plotOutput("distPlot")
        )
    )
)