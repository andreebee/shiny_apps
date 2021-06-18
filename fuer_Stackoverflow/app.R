### Noch Frage stellen!!!
#Stackoverflow
#Problem: Nicht gleich die richtige Antwort anzeigen,soll erstkommen, wenn submit geklickt wenn das Zweite mal die Loesung versucht wird raus zu finden, Zeile 29
#Tabs nicht gleich anzeigen , sollen erst erscheinen, wenn Frage richtig beantwortet

library(shiny)


ui <- shinyUI(pageWithSidebar(
    headerPanel("Header"),
    sidebarPanel(
        conditionalPanel(
            condition = "input.tabselected ==1",
            sliderInput(
                inputId = "slider1",
                label = "Slider 1",
                min = 0,
                max = 1,
                value = 0.5
                ),
            selectInput(
                inputId = "quiz1",
                label = " Right or wrong",
                selected = NULL,
                choices = c("Right",
                            "Wrong")
            ),
           # actionButton("submit", label = "Submit"),
           # conditionalPanel(
            #    "input.submit!=0",
                conditionalPanel(
                    "input.quiz1 === 'Right'",
                    paste0("Feedback: Right"),
                    actionButton("Tab2", label = "Next Question")
                    
             #   )
            ),
          #  conditionalPanel(
              #  "input.submit!=0",
                conditionalPanel(
                    "input.quiz1 === 'Wrong'",
                    paste0("Feedback: Wrong")
               ) #)
               
        ),
        conditionalPanel(
            condition = "input.tabselected ==2",
            sliderInput(
                inputId = "slider2",
                label = "Slider 2",
                min = 0,
                max = 1,
                value = 0.5
                  ),
            selectInput(
                inputId = "quiz2",
                label = "True or false",
                selected = NULL,
                choices = c("false",
                            "true")
            ),
            #actionButton("submit2", label = "Submit"),
           # conditionalPanel(
            #    "input.submit2!=0",
                conditionalPanel(
                    "input.quiz2 === 'true'",
                    paste0("Feedback: Right answer")#,
                    #Button1_reactive
               # )
            ),
           # conditionalPanel(
             #   "input.submit2!=0",
                conditionalPanel(
                    "input.quiz2 === 'false'",
                    paste0("Feedback: Wrong answer")
                ) 
           # )
         )        
    ),
    mainPanel(
             tabsetPanel(
            type = "tabs",
          tabPanel(
                "Question 1",
                titlePanel("Description question 1"),
                value = "1"
            ), 
    
          tabPanel(title = "Question  2" ,
                value = "2",
                conditionalPanel("input.quiz1 === 'Right'",
                    titlePanel("Description question 2")
                   ) 
            ), 
             id = "tabselected"
            )
        )
)
)


server = function(input, output, session) {
    observeEvent(input$Tab2, {
       updateTabsetPanel(session, "tabselected",
                        selected = "2")
    })
    
}
shinyApp(ui = ui, server = server)
