library(shiny)
library(ggplot2)
options(encoding = "UTF-8")


ui <- fluidPage(
  
  # App title ----
  titlePanel("Wahrscheinlichkeiten würfeln"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Anzahl Würfe:",
                  min = 5,
                  max = 5000,
                  value = 100)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot"),
      
      tableOutput("view")
      
    )
  )
)

x    <- sample(1:6,size=5000, replace=T)

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
    
    
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    a=rep(0, 6); i=0
    for (n in 1:6){
      if(all(x[1:input$bins]!=n))
        {a[n]=0; i=i+1}
      else{a[n]=prop.table(table(x[1:input$bins]))[[n-i]]}}
    barplot(a, names.arg = c(1:6),
         xlab = "Augenzahl",
         ylab = "Relative Häufigkeit", col = "steelblue3", ylim=(c(0,0.3)))
    
  })
 
  output$view <- renderTable({
    a=rep(0, 6); i=0
    for (n in 1:6){
      if(all(x[1:input$bins]!=n))
        {a[n] = 0; i = i+1}
      else{a[n]=prop.table(table(x[1:input$bins]))[[n-i]]}}
    ans = data.frame(Augenzahl=c(1:6), 
      Wahrscheinlichkeit = c(rep(1/6, 6)), 
      Rel.Häufigkeit = a)
    ans 
  }, digits=3) 
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
