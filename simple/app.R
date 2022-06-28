
library(shiny)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("plotly"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("playplot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  myplot <- reactive({
    db <- data.frame(no=seq(1,100,1),p=runif(100,0,1))
    db$g <- ifelse(db$p >= 0.05,"ok","nok")
    df <- db
    df$frame <- 100
    i <- 1
    for (i in seq(1,99,1)){
      db$frame <- i
      df <- rbind(df,db[1:i,])}
    return(df)
  })
  
  # plot the p values
  fig <- function(){
    myplot() %>%
      plot_ly(
        x = ~no,
        y = ~p,
        frame = ~frame,
        type = 'scatter',
        mode = 'markers',
        color = ~g,
        colors = c("#ffb300", "#2aff00"),
        showlegend = F
      ) %>%
      add_segments(x = 0, xend = 101, y = 0.05 , yend = 0.05,color = I("gray")) %>%
      layout( xaxis = list(range = c(0,101)), yaxis = list(range = c(0, 1)))
  }
  
  output$playplot <- renderPlotly(fig())
  
}

# Run the application 
shinyApp(ui = ui, server = server)
