# Ziel:


#####    Layout
library(shinydashboard)
library(shiny)
library(ggplot2)


body <- dashboardBody(
    # Create a tabBox
    tabItems(
        tabItem(tabName = "dashboard",
                tabBox(
                    #title = "2-Stichproben t-Test",
                    tabPanel("Differenz"),
                    tabPanel("Differenz und Standardabweichung"),
                    tabPanel("Differenz, Standardabweichung und Anzahl")
                )
        )
    )
)


sidebar <- dashboardSidebar(
    sidebarMenu(
        # Create `menuItem()`s, "Dashboard" 
        menuItem(text = "Dashboard",
                 tabName = "dashboard"
        ),
    
    # Add a slider
       sliderInput(
          inputId = "diff",
           label = "Differnz",
           min = 0,
           max = 100,
           value = 50),
    
    # Add a slider
    sliderInput(
        inputId = "sd",
        label = "Standardabweichung",
        min = 0,
        max = 100,
        value = 50),
    
    # Add a slider
    sliderInput(
        inputId = "anz",
        label = "Anzahl",
        min = 0,
        max = 100,
        value = 50)
    
)
)



header <- dashboardHeader( title = "2-Stichproben t-Test")

ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body
                   
)

server <- function(input, output) {
    
}

# Run the application 
shinyApp(ui = ui, server = server)
