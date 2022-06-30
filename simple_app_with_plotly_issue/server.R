library(shiny)
library(plotly)

server = function(input, output, session) {
  
  # Define output for individual tabs ####
  
  # avoid showing wrong answer before selecting a choice
  output$q1 <- renderUI({
    if(as.character(input$quiz1)==" "){
      HTML(paste0("<br>","<b>","please answer the question","</b>", "</br>"))
    } else {
      HTML(paste0("<br>","<b>","Wrong Answer","</b>", "</br>"))
    }
  })
  
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
  
  ## for first tab  ####
  
  output$test1 <- renderText({
    "test1"
  })
  
  output$issue <- renderText({
    "It does not show the plot after deployment!"
  })
  
  ##  for Tab 2 ####
  
  #When you click the "next tab button" in tab 1, you jump to tab 2
  observeEvent(input$Tab2, {
    updateTabsetPanel(session, "tabselected",
                      selected = "2")
  })
  
  output$test2 <- renderText({
    "test2"
  })
  
  #go to the previous tab
  observeEvent(input$before2, {
    updateTabsetPanel(session, "tabselected",
                      selected = "1")
  })
  
  #Tab only visible after the correct answer
  observeEvent(input$quiz1,{
    if(input$quiz1 == "statementn1" ){  #condition
      insertTab(inputId = "tabselected",    #The tab is inserted here
                tabPanel(
                  title = "Title2",
                  titlePanel("Title2"),
                  value = "2",       #Sidebar 2 is displayed
                  
                  "Explanation2.",
                  
                  textOutput("test2")
                  
                ) #End of the TabPanel
                , target="1", position ="after" )
    }
    
    if(input$quiz1 != "statementn1" ){  #condition
      removeTab(inputId = "tabselected",     #Here the tab is cleared if the wrong answer is entered after the correct one
                target="2" )
    }
  })

}

