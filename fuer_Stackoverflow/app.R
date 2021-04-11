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
            actionButton("submit", label = "Submit"),
            conditionalPanel(
                "input.submit!=0",
                conditionalPanel(
                    "input.quiz1 === 'Right'",
                    paste0("Text")
                )
            )
        ),
        conditionalPanel(
            condition = "input.tabselected ==2",
            sliderInput(
                inputId = "slider2",
                label = "Slider 2",
                min = 0,
                max = 1,
                value = 0.5
                  )
               )        
    ),
    mainPanel(
             tabsetPanel(
            type = "tabs",
          tabPanel(
                "Tab 1",
                titlePanel("Tab 1"),
                value = "1",
               htmlOutput("Erklaerung1"),
                uiOutput("Button1")
            ), 
    
          tabPanel(title = "Tab 2" ,
                value = "2",
                conditionalPanel("input.quiz1 === 'Right'",
                    titlePanel("Tab 2"),
                    htmlOutput("Erklaerung2"),
                    uiOutput("Button2") 
                    ) 
            ), 
             id = "tabselected"
            )
        )
)
)


server = function(input, output, session) {
    Erklaerung1_reactive = eventReactive(input$submit, {
        if (input$quiz1 == "Right") {
            HTML(paste0("<b>", "Right", "</b>"))
        }
        else{
            HTML(paste0("<strong>", "Wrong", "</strong>"))
        }
    })
    output$Erklaerung1 <- renderUI({
        Erklaerung1_reactive()
    })
    Button1_reactive = eventReactive(input$submit, {
        if (input$quiz1 == "Right") {
            actionButton("Tab2", label = "Next")
        }
        else{
            paste0("")
        }
    })
    output$Button1 <- renderUI({
        Button1_reactive()
    })
    observeEvent(input$Tab2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
}
shinyApp(ui = ui, server = server)
