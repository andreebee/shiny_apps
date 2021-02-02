library(shiny)
library(ggplot2)



ui <- fluidPage(
  
  # App title ----
  titlePanel("Normalverteilung: Quantile"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "m",
                  label = "Erwartungswert",
                  min = -10,
                  max = 10,
                  value = 0),
      sliderInput(inputId = "s",
                  label = "Standardabweichung",
                  min = .5,
                  max = 5,
                  value = 1),
      sliderInput(inputId = "u",
                  label = "Untere Grenze",
                  min = -15,
                  max = 15,
                  value = -2),
      sliderInput(inputId = "o",
                  label = "Obere Grenze",
                  min = -15,
                  max = 15,
                  value = 2)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot"),
      plotOutput(outputId = "vertPlot")
      
    )
  )
)
#x=seq(-15,15,length.out=500)
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
    x <- seq(-4,4,length=400)*input$s + input$m
    dn=dnorm(x, input$m, input$s)
    plot(x, dn, type="l", col=4, lwd=2, 
         xlab="x", ylab="", main="Dichte")
    i <- x >= min(input$u, input$o) & x <=max(input$o, input$u)
    #lines(x, dn, col=4)
    polygon(c(min(input$u, input$o),x[i],max(input$o, input$u)), c(0,dn[i],0), 
            col="steelblue3") 
    abline(h=0)
    area <- pnorm(max(input$o, input$u), input$m, input$s) - pnorm(min(input$u, input$o), input$m, input$s)
    result <- paste("P(",min(input$o, input$u),"< X <",max(input$o, input$u),") =",
                    round(area, digits=3))
    mtext(result,3, col=4)
    
  })
 
  
  output$vertPlot <- renderPlot({
    x <- seq(-4,4,length=100)*input$s + input$m
    pn=pnorm(x, input$m, input$s)
    plot(x, pn, type="l", col=4, lwd=2, 
         xlab="x", ylab="", main="Verteilungsfunktion")
    abline(h=0); abline(v=min(input$u, input$o), lty=2); abline(v=max(input$o, input$u), lty=2)
    abline(h=pnorm(min(input$u, input$o), input$m, input$s), lty=2)
    abline(h=pnorm(max(input$o, input$u), input$m, input$s), lty=2)
    result <- paste("P(X <",min(input$u, input$o),") =", 
                    round(pnorm(min(input$u, input$o), input$m, input$s), 3),", P(X <",max(input$o, input$u),") =", round(pnorm(max(input$o, input$u), input$m, input$s), 3))
    mtext(result,3, col=4)
    #text(-3*input$s + input$m-.1, pnorm(min(input$u, input$o), input$m, input$s)+.05, 
         #labels=paste("P(X <",min(input$u, input$o),") =", round(pnorm(min(input$u, input$o), input$m, input$s), 3)),
         #cex = 1.1, col=4)
    #text(-3*input$s + input$m-.1, pnorm(max(input$o, input$u), input$m, input$s)-.05, 
         #labels=paste("P(X <",max(input$o, input$u),") =", round(pnorm(max(input$o, input$u), input$m, input$s), 3)),
         #cex = 1.1, col=4)
  }) 
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
