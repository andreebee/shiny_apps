#https://stackoverflow.com/questions/38488174/tab-specific-sidebar-in-shinydashboard



# load libraries
require(shiny)
require(shinydashboard)
require(shinyjs)

# create a simple app
ui <- dashboardPage(
    title='Loading graphs',
    dashboardHeader(
        title = 'Loading Graphs'
    ),
    dashboardSidebar(
        conditionalPanel("input.navbar == 'tab1_val'",
                         div(id='tab1_sidebar',
                             sliderInput('tab1_slider', 'tab1 slider', min=2,max=7,value=2))
        ),
        conditionalPanel("input.navbar == 'tab2_val'",
                         div(id='tab2_sidebar',
                             sliderInput('tab2_slider', 'tab2 slider', min=2,max=7,value=2))
        )
    ),
    dashboardBody(
        useShinyjs(),
        tabsetPanel(
            id = "navbar",
            tabPanel(title="tab1 title",id="tab1",value='tab1_val',
                     valueBoxOutput('tab1_valuebox')),
            tabPanel(title="tab2 title",id="tab2",value='tab2_val',
                     valueBoxOutput('tab2_valuebox'))
        )
    )
)

server <- shinyServer(function(input, output, session) {
    
    output$tab1_valuebox <- renderValueBox({
        valueBox('1000',subtitle = "blah blah",icon = icon("car"),
                 color = "blue"
        )
    })
    
    output$tab2_valuebox <- renderValueBox({
        valueBox('2000',subtitle = "blah2 blah2",icon = icon("car"),
                 color = "red"
        )
    })
    
    
    
    # on click of a tab1 valuebox
    shinyjs::onclick('tab1_valuebox',expr={
        # move to tab2
        updateTabsetPanel(session, "navbar", 'tab2_val')
    })
    
    # on click of a tab2 valuebox
    shinyjs::onclick('tab2_valuebox',expr={
        # move to tab2
        updateTabsetPanel(session, "navbar", 'tab1_val')
    })
})

shinyApp(ui=ui,server=server)
