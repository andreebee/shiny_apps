library(shiny)
library(ggplot2)



ui <- fluidPage(
  
  # App title ----
  titlePanel("Parameter der Normalverteilung"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "m",
                  label = "Erwartungswert",
                  min = -5,
                  max = 5,
                  value = 0),
      sliderInput(inputId = "s",
                  label = "Standardabweichung",
                  min = .5,
                  max = 5,
                  value = 1)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot"),
      plotOutput(outputId = "vertPlot")
      
    )
  )
)
x=seq(-15,15,length.out=500)
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  
  
  output$distPlot <- renderPlot({
    
    dn=dnorm(x, input$m, input$s)
    plot(x, dn, type="l", col="steelblue3", lwd=2, 
         xlab="x", ylab="Dichte", ylim=c(0,.75))
    #r=seq(input$m-input$s,input$m+input$s,length.out=500)
    #dr=dnorm(r, input$m, input$s)
    #abline(h=0,col="gray")
    #l=abline(v = input$m-input$s, col = 2)
    #k=abline(v = input$m+input$s, col = 2)
    #polygon(x=c(r,input$m-input$s, input$m+input$s) ,y=c(dr,l,k),col="snow3")
    
    
    
  })
 
  
  output$vertPlot <- renderPlot({
    
    pn=pnorm(x, input$m, input$s)
    plot(x, pn, type="l", col="steelblue3", lwd=2, 
         xlab="x", ylab="Verteilungsfunktion")
    
    
    
    
  }) 
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
