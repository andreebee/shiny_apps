#Ziel dieser App: Studis verstehen, wie die Box-Cox Trafo aussieht
#Es kann Lambda variiert werden, dazu wird angezeit, wie sich diese variistion auf die Box-Cox Trafo auswirkt,
#diese wird mit der ZR ohne Traf und der mit dem Log transformierten ZR verglichen.
#Zusätzlich wird aufgezeigt, wie sich die Trafos auf die Quartalsgewinne der JohnsonJohanson Aktien auswirken
#Es werden die in R vorhandenen Quartalsgewinne der JohnsonJohnson Aktie verwendet


library(shiny)
#library(ggplot2)
#library(Matrix) #to use bandSparse to create band matrix
#library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)

ui <- fluidPage(
    
    # App title ----
    titlePanel("Box-Cox-Transformation"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs (and to show trafo function) ----
        sidebarPanel(
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "lambda",
                        label   = "lambda",
                        min     = 0,
                        max     = 1,
                        step    = 0.1,
                        value   = 0.5),
            plotOutput(outputId = "functionPlot")
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            plotOutput(outputId = "distPlot")
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
    #x und y-Werte der Zeitreihe, die wir transformieren werden
    x  = time(JohnsonJohnson)
    y  = JohnsonJohnson
    #x und y-Werte der Identitätsfunktion, die wir transformieren werden
    xf = seq(from=0, to=3, by=0.05)
    yf = xf
    #c  = 0 #Konstante for Trafo
    
    output$distPlot <- renderPlot({
        c = input$lambda
        #y_t: transformierte Zeitreihe
        #yf_t: transformierte Werte der Identitätsfunktion
        if(input$lambda != 0){
            y_t  = ((y  + c) ^ input$lambda - 1) / input$lambda
            yf_t = ((yf + c) ^ input$lambda - 1) / input$lambda
        }
        else{
            y_t  = log(y  + c)
            yf_t = log(yf + c)
        }
        
        #1.Plot: J&J
        #Boxcox transformierte Daten plotten
        ts.plot(y_t, ylim = c(-2, 14), ylab="",
                main="Quartalsgewinne pro Aktie von Johnson & Johnson ",
                col="blue")
        legend("topleft", 
               c("ohne Trafo", "log-Trafo", "Box-Cox-Trafo"),
               lwd = 2,
               col=c("black", "red", "blue"))
        #Originaldaten plotten
        lines(x=x, y=y, col="black", type="l", lty="dashed")
        #logarithmierte Daten plotten
        y_2 = log(y)
        lines(x=x, y=y_2, col="red", type="l", lty="dashed")
        
    })
    
    
    output$functionPlot <- renderPlot({
        c = input$lambda
        #y_t: transformierte Zeitreihe
        #yf_t: transformierte Werte der Identitätsfunktion
        if(input$lambda != 0){
            y_t  = ((y  + c) ^ input$lambda - 1) / input$lambda
            yf_t = ((yf + c) ^ input$lambda - 1) / input$lambda
        }
        else{
            y_t  = log(y  + c)
            yf_t = log(yf + c)
        }
        
        
        
        #2.Plot: Transformationsfunktionen
        #Plotte Box-Cox Trafo-Funktion
        plot(x=xf, yf_t, xlim=c(0, 3), ylim=c(0, 3), xlab="x", ylab="f(x)",
             main="Tranformationsfunktionen", type="l",
             col="blue")
        legend("topleft", 
               c("Identität", "Logarithmus", "Box-Cox-Trafo"),
               lwd = 2,
               col=c("black", "red", "blue"))
        yf_2 = log(yf)
        #Plotte Logarithmusfunktion
        lines(x=xf, y=yf_2, col="red", type="l", lty="dashed")
        #Plotte Identität
        lines(x=xf, y=yf, col="black", type="l", lty="dashed")
    })
    
    
}#end of server

# Create Shiny app ----
shinyApp(ui = ui, server = server)
