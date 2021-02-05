#Ziel dieser App: Studis verstehen, was es bedeutet, wenn ein Signal von einem WN überlagert wird
#Dazu kann die Signalfunktion per Hand verändert werden und die Varianz und der EW des WN können variiert werden




library(shiny)
library(ggplot2)
library(Matrix) #to use bandSparse to create band matrix
library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)

ui <- fluidPage(
    
    # App title ----
    titlePanel("Simulation Signal + WhiteNoise"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "variance",
                        label = "Varianz WhiteNoise",
                        min = 0,
                        max = 3,
                        step = 0.1,
                        value = 1),
            #verbatimTextOutput("value"),
            sliderInput(inputId = "mean",
                        label = "Erwartungswert WhiteNoise",
                        min = 0,
                        max = 3,
                        step = 0.1,
                        value = 0),
            textInput(inputId = "formula",
                      label = "Signalfunktion",
                      value = "2*cos(2*pi*x/(50+0.6*pi))",
                      width = NULL,
                      placeholder = NULL
                      
            ),
            
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            plotOutput(outputId = "distPlot"),
            textOutput(outputId = "snratio")
            
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
    x = seq(from=1, to=100)
    
    
    
    #updateNumericInput(session, "variance", value = x)
    output$distPlot <- renderPlot({
        #create var-cov matrix
        #create multivariate Gaussian Vector
        w = rnorm(n = 100, mean = input$mean, sd = input$variance)
        s = eval(parse(text=input$formula))
        ws = w + s
        snratio = (var(s) - (mean(s)^2)) / (input$variance - (input$mean^2))
        ts.plot(as.ts(ws), gpars=list(ylim=c(-10, 10), main="Trajektorie", ylab="")
        )
        abline(h=0, lty=2)
    })
    output$snratio <- renderText({
        w = rnorm(n = 100, mean = input$mean, sd = input$variance)
        s = eval(parse(text=input$formula))
        ws = w + s
        snratio = round((var(s)) / (input$variance), 2)
        
        paste("Die Signal-to-noise ratio ist", snratio)
    })
    
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
