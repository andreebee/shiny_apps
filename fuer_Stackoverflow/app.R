### Noch Frage stellen!!!
#Stackoverflow
#Problem: Nicht gleich die richtige Antwort anzeigen,soll erstkommen, wenn submit geklickt wenn das Zweite mal die Loesung versucht wird raus zu finden, Zeile 29
#Tabs nicht gleich anzeigen , sollen erst erscheinen, wenn Frage richtig beantwortet


#Rohe Variante 

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
                choices = c("",
                            "Right",
                            "Wrong")
            ),
          
                conditionalPanel(
                    "input.quiz1 === 'Right'",
                    paste0("Feedback: Right"),
                    actionButton("Tab2", label = "Next Question")
                    
            
            ),
         
                conditionalPanel(
                    "input.quiz1 === 'Wrong'",
                    paste0("Feedback: Wrong")
                )
               
        ),
        conditionalPanel(
            condition = "input.tabselected  ==2",
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
           
               conditionalPanel(
                   "input.quiz2 === 'true'",
                    paste0("Feedback: Right answer")#,
                 
            ),
           
                conditionalPanel(
                    "input.quiz2 === 'false'",
                    paste0("Feedback: Wrong answer")
                ) 
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
    observeEvent(input$quiz1,{
        
        if(input$quiz1 == "Right" ){
            insertTab(inputId = "tabselected",
                      tabPanel(title = "Question2" ,
                               titlePanel("Description question 2"),
                                value = "2"), target="1", position ="after" )
        }
      
      if(input$quiz1 != "Right" ){
        removeTab(inputId = "tabselected",                                                           #Tab loeschen bei falscher Antwort
                  target="2")
      }
    })
    
   
    
}

shinyApp(ui = ui, server = server)









































