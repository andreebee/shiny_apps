library(shiny)
library(ggplot2)
library(Matrix) #to use bandSparse to create band matrix
library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)

ui <- fluidPage(
    
    # App title ----
    titlePanel("Movingaverage White Noise"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "M",
                        label = "M",
                        min = 2,
                        max = 100,
                        step = 1,
                        value = 0.0),
            
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
    wn1 = rnorm(150,0,1)
    
    output$distPlot <- renderPlot({
        if(2 %% input$M == 0){
            wn_ma = filter(wn1, c(0.5,rep(1, input$M-1),0.5), sides = 2)/input$M
        }
        else{
            wn_ma = filter(wn1, rep(1, input$M), sides = 2)/input$M
            
        }
        plot.ts(wn1, 
                main="Glaettung von White Noise mit Moving Average", 
                ylab="", lwd=1.5)
        lines(wn_ma,type="l",col=2,lwd=3)
        
        
        
        
    })
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
