# erstmal nur die Difefrenz betrachten


library(shiny)
library(ggplot2)


#Ziehe unabhaengige standardnormalverteilte Stichprobe
Gruppe1 = rnorm(100)
anz = c(1:100)


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("2 Stichproben t-Test"),

    # Sidebar with a slider input for number of bins 
    # Add a slider
    sliderInput(
        inputId = "diff",
        label = "Differnz der Mittelwerte",
        min = 0,
        max = 10,
        value = 5),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("boxPlot"),
            verbatimTextOutput("p")   #t-Test Ausgabe ausgeben c
        )
    )


# Define server 
server <- function(input, output) {
    
    #Gruppe2 = rnorm(100, input$diff, 1)
    
    #p Wert des t-Tests
    
output$p = renderPrint({
    #ziehe Zweite Stichprobe, mit gegebner Differnz der Mittelwerte
    Gruppe2 = rnorm(100, input$diff, 1)
    
    t.test(Gruppe1, Gruppe2, alternative = "two.sided" )$p.value   #2 Seitiger t-Test
})
#Boxplot
output$boxPlot = renderPlot({
    
    #ziehe Zweite Stichprobe, mit gegebner Differnz der Mittelwerte
    Gruppe2 = rnorm(100, input$diff, 1)
    
    Wert = c(Gruppe1, Gruppe2)
    Gruppe = c(rep("1", 100), rep("2", 100))
    
    daten = data.frame(Gruppe, Wert)
    
    #Boxplot mit zwei Var erstellen
    ggplot(daten, aes(x = Gruppe , y =Wert , fill = factor(Gruppe)))+   #benoetigt DataFrame
        geom_boxplot()+
        geom_jitter(width = 0.1, alpha = 0.2)
}
    
)
}

# Run the application 
shinyApp(ui = ui, server = server)
