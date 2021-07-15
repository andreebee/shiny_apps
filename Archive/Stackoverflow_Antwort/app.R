#Rohe Variante

library(shiny) 
library(shinydashboard)
ui <- dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      conditionalPanel("input.navbar == 'tab1_val'",
                       div(id='tab1_sidebar',
                           sliderInput(
                             inputId = "slider1",
                             label = "Slider 1",
                             min = 0,
                             max = 1,
                             value = 0.5),
                           
                           selectInput(
                             inputId = "quiz1",
                             label = "quiz1",
                             selected = NULL,
                             choices = c("Right",
                                         "Wrong")
                           ))
      ),
      conditionalPanel("input.navbar == 'tab2_val'",
                       div(id='tab2_sidebar',
                           sliderInput(
                            inputId = "slider2",
                            label = "Slider 2",
                            min = 0,
                            max = 10,
                            value = 0.5))
        )
      ),

    dashboardBody(
      useShinyjs(),
      tabsetPanel(id="navbar",
             tabPanel("panel","Inhalt", id="tab1", value='tab1_val',valueBoxOutput('tab1_valuebox')),
             tabPanel(title="tab2 title",id="tab2",value='tab2_val',
                      valueBoxOutput('tab2_valuebox')))#,
        #conditionalPanel(
         #   condition = "input.quiz1 === 'Right'",
         #   tabBox(
         #       title = "quiz1",
          #      id= "ttabs", width = 8, height = "420px",
         #       tabPanel("Files",value=1, dataTableOutput("Filesa")),
               
          #  )
       # )#,
        
      #  conditionalPanel(
       #     condition = "input.quiz2 === 'Right'",
       #     tabBox(
        #        title = "intro",
       #         id= "ttabs", width = 8, height = "420px",
       #         tabPanel("Files",value=3, dataTableOutput("Files"))
       #     ))  
        
    )
#id = "tabselected"
)


server <- function(input, output) { 
 
    observeEvent(input$quiz1,{
        if(input$quiz1 == 'Right' ){
            insertTab(inputId = "navbar",
                      tabPanel("Description question 2", "This a dynamically-added tab",id="tab2",
                               value='tab3_val',valueBoxOutput('tab3_valuebox')), target="panel", position ="after")
        }
    })
}
shinyApp(ui, server)
