library(shiny)
library(DT)

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
  
  # avoid showing wrong answer before selecting a choice
  output$q2 <- renderUI({
    if(as.character(input$quiz2)==" "){
      HTML(paste0("<br>","<b>","please answer the question","</b>", "</br>"))
    } else {
      HTML(paste0("<br>","<b>","Wrong Answer","</b>", "</br>"))
    }
  })
  
  # avoid showing wrong answer before selecting a choice
  output$q3 <- renderUI({
    if(as.character(input$quiz3)==" "){
      HTML(paste0("<br>","<b>","please answer the question","</b>", "</br>"))
    } else {
      HTML(paste0("<br>","<b>","Wrong Answer","</b>", "</br>"))
    }
  })
  
  
  ## for first tab  ####
  
  output$test1 <- renderText({
    "test1"
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
  
  ##  for Tab 3 ####
  
  #When you click the "next tab button" in tab 2, you jump to tab 3
  observeEvent(input$Tab3, {
    updateTabsetPanel(session, "tabselected",
                      selected = "3")
  })
  
  output$test3 <- renderText({
    "test3"
  })
  
  #go to the previous tab
  observeEvent(input$before3, {
    updateTabsetPanel(session, "tabselected",
                      selected = "2")
  })
  
  #Tab only visible after the correct answer
  observeEvent(input$quiz2,{
    if(input$quiz2 == "statementn2" ){  #condition
      insertTab(inputId = "tabselected",    #The tab is inserted here
                tabPanel(
                  title = "Title3",
                  titlePanel("Title3"),
                  value = "3",       #Sidebar 3 is displayed
                  
                  "Explanation3.",
                  
                  textOutput("test3")
                  
                ) #End of the TabPanel
                , target="2", position ="after" )
    }
    
    if(input$quiz2 != "statementn2" ){  #condition
      removeTab(inputId = "tabselected",     #Here the tab is cleared if the wrong answer is entered after the correct one
                target="3" )
    }
  })
  
  ##  for last Tab ####
  
  observeEvent(input$Tab4, {
    updateTabsetPanel(session, "tabselected",
                      selected = "4")
  })
  #go to the previous tab
  observeEvent(input$before4, {
    updateTabsetPanel(session, "tabselected",
                      selected = "3")
  })
  
  #Tab only visible after the correct answer is given
  observeEvent(input$quiz3,{
    
    if(input$quiz3 == "statementn3" ){
      insertTab(inputId = "tabselected",           #Insert tab
                tabPanel(
                  title = "Title4",
                  titlePanel("Title4"),
                  value = "4", #Sidebar 4 is displayed
                  
                  "You have answered all the questions correctly.",
                  dataTableOutput("score")
                  
                )
                , target="3", position ="after" )
    }
    if(input$quiz3 != "statementn3" ){
      removeTab(inputId = "tabselected",        #Delete tab if the wrong answer is given
                target="4" )
    }
  })
  
  #  Defining & initializing the reactiveValues object
  attempts <- reactiveValues(a_q1 = -1, a_q2 = -1, a_q3 = -1)
  scores <- reactiveValues(s_q1 = 0, s_q2 = 0, s_q3 = 0)
  # add 1 to the attempt counter when user answers a question
  # set 1 for the score if users answers correctly at their first attempt
  observeEvent(input$quiz1, {
    attempts$a_q1 <- attempts$a_q1 + 1
    if (input$quiz1 == "statementn1" & attempts$a_q1 == 1){scores$s_q1 <- 1}})
  observeEvent(input$quiz2, {
    attempts$a_q2 <- attempts$a_q2 + 1
    if (input$quiz2 == "statementn2" & attempts$a_q2 == 1){scores$s_q2 <- 1}})
  observeEvent(input$quiz3, {
    attempts$a_q3 <- attempts$a_q3 + 1
    if (input$quiz3 == "statementn3" & attempts$a_q3 == 1){scores$s_q3 <- 1}})
  
  # score table
  output$score <- renderDataTable({
    score_df <- datatable(
      data.frame(
        Question1 = scores$s_q1,
        Question2 = scores$s_q2,
        Question3 = scores$s_q3,
        TotalScore = scores$s_q1 + scores$s_q2 + scores$s_q3,
        row.names = 'score out of 3:'
        ),
      options = list(dom = 't'))
  })
  
}

