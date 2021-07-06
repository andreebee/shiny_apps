library(gapminder)

# Define UI for the application
ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            textInput("title", "Title", "GDP vs life exp"),
            numericInput("size", "Point size", 1, 1),
            checkboxInput("fit", "Add line of best fit", FALSE),
            # Add radio buttons for colour
            radioButtons("color", label="Point color", 
                         choices= c("blue", "red", "green", "black"))
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

# Define the server logic
server <- function(input, output) {
    output$plot <- renderPlot({
        p <- ggplot(gapminder, aes(gdpPercap, lifeExp)) +
            # Use the value of the color input as the point colour
            geom_point(size = input$size, col = input$color) +
            scale_x_log10() +
            ggtitle(input$title)
        
        if (input$fit) {
            p <- p + geom_smooth(method = "lm")
        }
        p
    })
}

# Run the application
shinyApp(ui = ui, server = server)
