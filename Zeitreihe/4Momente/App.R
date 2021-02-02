#Ziel dieser App: Studis verstehen, was die ersten 4 Momente einer Verteilung bedeuten
#Ausgehend von der Standardnormalverteilung kann man je 1 Moment ver�ndern und sieht den Effekt
#auf die Dichte
#Dazu wird die Familie der Johnson Distribution genutzt 
#(die die Standartnormalverteilung als Spezialfall enth�lt)



#install.packages("shiny")
#install.packages("shinyjs") 
#der code für den rest Button ist von: https://stackoverflow.com/questions/24265980/reset-inputs-button-in-shiny-app 
library(shinyjs)
library(shiny)
library(ggplot2)
library(Matrix) #to use bandSparse to create band matrix
library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)
#install.packages("SuppDists")
library(SuppDists)

#define sequence to plot along
x <- seq(-4, 4, by=0.1)

ui <- fluidPage(
    
    # App title ----
    titlePanel("Veranschaulichung der 4 Momente einer Verteilung"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            shinyjs::useShinyjs(),      #fuer Reset Button
            id = "side-panel",
            
            "Anleitung: Maximieren Sie das Fenster. Verändern Sie eines der 4 Momente der Verteilung, um deren Bedeutung zu ergründen. 
      Klicken Sie auf Zurücksetzen , bevor sie das nächste Moment verändern.",
            
            
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "mean",
                        label = "1. Moment: Mittelwert",
                        min = -2,
                        max = 2,
                        step = 1,
                        value = 0),
            sliderInput(inputId = "variance",
                        label = "2. Moment: Varianz",
                        min = 0.7,
                        max = 1,
                        step = 0.1,
                        value = 1),
            sliderInput(inputId = "schiefe",
                        label = "3. Moment: Schiefe",
                        min = -0.4,
                        max = 0.4,
                        step = 0.1,
                        value = 0),
            sliderInput(inputId = "woelbung",
                        label = "4. Moment: Wölbung (wenn Varianz=1)",
                        min = 2.5,
                        max = 10,
                        step = 0.5,
                        value = 3),
            checkboxInput(inputId="zoom", label="Zoom auf Tail der Verteilung", value = FALSE),
            actionButton(inputId = "reset_input", label = "Zurücksetzen")
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            plotOutput(outputId = "distPlot")#,
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
    #if (input$zoom) limit <- 0.1 else limit <- 0.6
    
    output$distPlot <- renderPlot({
        
        #get Parameters of Johnson Distribution from Moments
        JohnsonParameter <- JohnsonFit(c(input$mean,
                                         input$variance,
                                         input$schiefe,
                                         input$woelbung), moment="use" )
        #get distribution
        y <- dJohnson(x, parms=JohnsonParameter)
        plot (x, 
              y, 
              col="black", 
              type="l", 
              ylim=c(0, 0.6 - 0.5 * input$zoom),
              ylab="Dichte")
        lines(x, dnorm(x), col="red"  , lty="dotted")
        legend("topleft", legend = c(" Dichte der erzeugten Verteilung", " Normalverteilungsdichte als Referenz"), col=c(1, 2), lty=1:2, cex=1)
    })
    
    #für Reset Button
    observeEvent(input$reset_input, {
        shinyjs::reset("side-panel")
    })
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)

