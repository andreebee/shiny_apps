rm(list = ls())
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
        checkboxGroupInput("Tabs", label = h4("tabpanel"), choices = list("tabs" = "tabs"),selected = NULL),
        checkboxGroupInput("MoreTabs", label = h4("moretabpanel"), choices = list("moretabs" = "moretabs"),selected = NULL)
    ),
    dashboardBody(
        
        conditionalPanel(
            condition = "input.MoreTabs == 'moretabs' && input.Tabs == 'tabs'",
            tabBox(
                title = "intro",
                id= "ttabs", width = 8, height = "420px",
                tabPanel("Files",value=1, dataTableOutput("Filesa")),
                tabPanel("Files1",value=2, dataTableOutput("Files1a"))
            )
        ),
        
        conditionalPanel(
            condition = "input.Tabs == 'tabs' && input.MoreTabs != 'moretabs'",
            tabBox(
                title = "intro",
                id= "ttabs", width = 8, height = "420px",
                tabPanel("Files",value=3, dataTableOutput("Files"))
            ))  
    ))
server <- function(input, output) { }
shinyApp(ui, server)