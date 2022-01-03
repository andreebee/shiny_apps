#Aim of this app: Students understand what the Box-Cox transformer looks like
#The lambda can be varied, for this purpose it is indicated how this variistion affects the Box-Cox transformer,
#this is compared with the time series without a transformer and the time series transformed with the log.
#In addition, it is shown how the transformers affect the quarterly earnings of JohnsonJohanson shares
#The quarterly earnings of the JohnsonJohnson share in R are used

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
    #x and y values of the time series that we are going to transform
    x  = time(JohnsonJohnson)
    y  = JohnsonJohnson
    #x and y values of the identity function that we are going to transform
    xf = seq(from=0, to=3, by=0.05)
    yf = xf
    #c  = 0 #Konstante for Trafo
    
    output$distPlot <- renderPlot({
        c = input$lambda
        #y_t: transformed time series
        #yf_t: transformed values of the identity function
        if(input$lambda != 0){
            y_t  = ((y  + c) ^ input$lambda - 1) / input$lambda
            yf_t = ((yf + c) ^ input$lambda - 1) / input$lambda
        }
        else{
            y_t  = log(y  + c)
            yf_t = log(yf + c)
        }
        
        #1.Plot: J&J
        #Boxcox plot transformed data 
        ts.plot(y_t, ylim = c(-2, 14), ylab="",
                main="Quartalsgewinne pro Aktie von Johnson & Johnson ",
                col="blue")
        legend("topleft", 
               c("ohne Trafo", "log-Trafo", "Box-Cox-Trafo"),
               lwd = 2,
               col=c("black", "red", "blue"))
        #Plot original data
        lines(x=x, y=y, col="black", type="l", lty="dashed")
        #Plot logarithmic data
        y_2 = log(y)
        lines(x=x, y=y_2, col="red", type="l", lty="dashed")
        
    })
    
    
    output$functionPlot <- renderPlot({
        c = input$lambda
        #y_t: transformed time series
        #yf_t: transformed values of the identity function
        if(input$lambda != 0){
            y_t  = ((y  + c) ^ input$lambda - 1) / input$lambda
            yf_t = ((yf + c) ^ input$lambda - 1) / input$lambda
        }
        else{
            y_t  = log(y  + c)
            yf_t = log(yf + c)
        }
        
        
        
        #2.Plot: Transformation functions
        #Plot Box-Cox transformer function
        plot(x=xf, yf_t, xlim=c(0, 3), ylim=c(0, 3), xlab="x", ylab="f(x)",
             main="Tranformationsfunktionen", type="l",
             col="blue")
        legend("topleft", 
               c("Identität", "Logarithmus", "Box-Cox-Trafo"),
               lwd = 2,
               col=c("black", "red", "blue"))
        yf_2 = log(yf)
        #Plot logarithm function
        lines(x=xf, y=yf_2, col="red", type="l", lty="dashed")
        #Plot identity function
        lines(x=xf, y=yf, col="black", type="l", lty="dashed")
    })
    
    
}#end of server

# Create Shiny app ----
shinyApp(ui = ui, server = server)
