#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  # Include custom CSS to remove scroll bar
  tags$head(
    tags$style(HTML('.shiny-split-layout>div {overflow: hidden;}')),
  ),
  
  h1("Zweiseitiger t-Test"),
  titlePanel(h4("Effekt der Differenz der Erwartungswerte, Standardabweichung und Fallzahl zweier Normalverteilungen")),
  splitLayout(cellArgs = list(style = "padding: 20px"),cellWidths = c("35%", "65%"), uiOutput("sliders"), plotOutput("boxPlot"))
)

server <- function(input, output, session) {
  
  # read Gruppe1 and Gruppe2
  Gruppe1 <- reactive({read.csv("Gruppe1.csv")$x})
  Gruppe2 <- reactive({read.csv("Gruppe2.csv")$x})
  
  ################### Create function #########################################
  #Create a box plot with the help of a function
  #Input: two samples
  #Output: boxplot of the samples
  BoxPlot = function(Gruppe1, Gruppe2) {
    #Build a data frame to create a boxplot separated by groups with ggplot
    Wert = c(Gruppe1, Gruppe2)
    Gruppe = c(rep("1", length(Gruppe1)), rep("2", length(Gruppe2)))
    daten = data.frame(Gruppe, Wert)
    
    # to keep the places of data points (jitter)
    set.seed(1)
    #Create a box plot with two variables
    ggplot(daten, aes(x = Gruppe, y = Wert,fill = factor(Gruppe))) +   #need a DataFrame
      geom_boxplot(color="#c4c4c4",width = 0.3, alpha = 0.05) +
      labs(title = "Auswirkung der Änderung") +
      ylim(-40, 40) +
      geom_jitter(width = 0.3, alpha = 0.8,aes(colour=factor(Gruppe))) +
      #stat_summary(fun=mean, geom="point",shape="_",size=10,color="red", fill="red")+
      geom_segment(aes(x=0.65,xend=1.35,y=mean(Gruppe1),yend=mean(Gruppe1)),color="red")+
      geom_segment(aes(x=1.65,xend=2.35,y=mean(Gruppe2),yend=mean(Gruppe2)),color="blue")+
      geom_text(aes(x=0.6, y=mean(Gruppe1),
                    label = "Erwartungswert \n Gruppe 1"),colour="#F8766D") +
      geom_text(aes(x=2.4, y=mean(Gruppe2),
                    label = "Erwartungswert \n Gruppe 2"),colour="#00BFC4") +
      theme(legend.position='bottom') 
    
    
  } #End of BoxPlot
  
  #p-value calculation as a function
  #Input: Samples from which the p-value is to be calculated
  #Output: p-value and test result in a list
  p_Wert = function(Gruppe1, Gruppe2) {
    p = t.test(Gruppe1, Gruppe2, alternative = "two.sided")$p.value   #2-sided t-test
    p = round(p, digits = 3) #round
    if (p < 0.05 ) {
      test_result = "Die Nullhypothese wird abgelehnt."
    }
    else{
      test_result = "Die Nullhypothese wird nicht abgelehnt."
    }
    if (p < 0.001) {
      p = "<0.001"
    }
    else{
      p = p
    }
    list(p,test_result)
  } #End of p_Wert
  
  ########################## for the tab ###########################
  
  output$sliders = renderUI({
    tagList(
      sliderInput(
        inputId = "diff",
        label = "Differenz der Erwartungswerte",
        min = 0,
        max = 2,
        step = 0.1,
        value = 1
      ),
      
      # Add a slider
      sliderInput(
        inputId = "sd",
        label = "Standardabweichung",
        min = 1,
        max = 15,
        step = 1,
        value = 8
      ),
      
      # Add a slider
      sliderInput(
        inputId = "n",
        label = "Fallzahl",
        min = 250,
        max = 1250,
        step = 50,
        value = 500
      ),
      HTML(paste0("<b>", "p-Wert", "</b>")),
      htmlOutput("p") #p-value
    )
  })
  
  
  output$p = renderUI({
    #calling Gruppe1 and Gruppe2
    Gruppe1 <- Gruppe1()
    Gruppe2 <- Gruppe2()
    Gruppe1 = Gruppe1[1:input$n] * input$sd
    Gruppe2 = Gruppe2[1:input$n] * input$sd + input$diff
    p <- p_Wert(Gruppe1, Gruppe2)
    wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
    result <- paste("<b>",p[[2]],"</b>")
    HTML(paste(wert,result,sep="<br/>"))
  })
  
  #Boxplot, of the Values
  output$boxPlot = renderPlot({
    #calling Gruppe1 and Gruppe2
    Gruppe1 <- Gruppe1()
    Gruppe2 <- Gruppe2()
    Gruppe1 = Gruppe1[1:input$n] * input$sd
    Gruppe2 = Gruppe2[1:input$n] * input$sd + input$diff
    BoxPlot(Gruppe1, Gruppe2)
  })
  
}

shinyApp(ui = ui, server = server)