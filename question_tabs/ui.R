library(shiny)
library(DT)

# for the sake of development
#def_answer1 <- 'statementn1'
#def_answer2 <- 'statementn2'
#def_answer3 <- 'statementn3'
def_answer1 <- NULL
def_answer2 <- NULL
def_answer3 <- NULL

ui <- shinyUI(pageWithSidebar(
  headerPanel("Question Tabs"),
  
  # Start of the Sidebar Panel ####
  sidebarPanel(
    
    ## Start of the first conditional panel ####
    conditionalPanel(
      condition = "input.tabselected ==1",
      #Condition for this sidebar to be displayed
      #Add an input
      uiOutput('page_content1'),
      "Now a question, if you answer correctly you can move to the next tab.",
      #Quiz
      selectInput(
        inputId = "quiz1",
        label = "Which statement is true?",
        selected = def_answer1,
        choices = c(" ","statement1",
                    "statement2",
                    "statementn1")
      ),
      #Explanation
      conditionalPanel("input.quiz1 ===  'statementn1'",   #correct answer given
                       actionButton("Tab2", label = "Next Tab"),
                       HTML(paste0("<br>","<b>", "Correct Answer","</b>", "</br>")),
                       HTML(paste0("<b>", "Explanation:", "</b>")),
                       paste0("explanation1."),
      ),
      #Output if the answer is wrong
      conditionalPanel("input.quiz1 !== 'statementn1'",   #correct answer given
                       htmlOutput("q1"),
      )              
    ),
    
    ## End of the first conditional panel ####
    
    ## Start of the 2 conditional panel ####
    
    conditionalPanel(
      condition = "input.tabselected == 2",
      #Condition for this sidebar to be displayed
      # Add an input
      uiOutput('page_content2'),
      "Now a question, if you answer correctly you can move to the next tab.",
      #Quiz
      selectInput(
        inputId = "quiz2",
        label = "Which statement is true?",
        selected = def_answer2,
        choices = c(" ","statement1",
                    "statement2",
                    "statementn2")
      ),
      actionButton("before2", label = "Previous Tab"), #Back Button
      #Explanation
      conditionalPanel("input.quiz2 ===  'statementn2'",   #correct answer given
                       actionButton("Tab3", label = "Next Tab"),
                       HTML(paste0("<br>","<b>", "Correct Answer","</b>", "</br>")),
                       HTML(paste0("<b>", "Explanation:", "</b>")),
                       paste0("explanation2."),
      ),
      #Output if the answer is wrong
      conditionalPanel("input.quiz2 !== 'statementn2'",   #correct answer given
                       htmlOutput("q2"),
      )
    ),
    
    ## End of the 2 conditional panel ####
    
    ## Start of the 3 conditional panel ####
    
    conditionalPanel(
      condition = "input.tabselected == 3",
      #Condition for this sidebar to be displayed
      # Add an input
      uiOutput('page_content3'),
      "Now a question, if you answer correctly you can move to the next tab.",
      #Quiz
      selectInput(
        inputId = "quiz3",
        label = "Which statement is true?",
        selected = def_answer3,
        choices = c(" ","statement1",
                    "statement2",
                    "statementn3")
      ),
      actionButton("before3", label = "Previous Tab"), #Back Button
      #Explanation
      conditionalPanel("input.quiz3 ===  'statementn3'",   #correct answer given
                       actionButton("Tab4", label = "Next Tab"),
                       HTML(paste0("<br>","<b>", "Correct Answer","</b>", "</br>")),
                       HTML(paste0("<b>", "Explanation:", "</b>")),
                       paste0("explanation3."),
      ),
      #Output if the answer is wrong
      conditionalPanel("input.quiz3 !== 'statementn3'",   #correct answer given
                       htmlOutput("q3"),
      )
    ),
    
    ## End of the 3 conditional panel ####
    
    ## Start of the last conditional panel ####
    
    conditionalPanel(
      "input.tabselected == 4",
      actionButton("before4", label = "Previous Tab")
    )
  ),
  
  ## End of the last conditional panel ####
  
  # End of the Sidebar Panel ####
  
  mainPanel(
    #Output: Tabset with plots
    tabsetPanel(
      type = "tabs",
      
      # From here Tab 1 ####
      
      tabPanel(
        title = "Title1",
        titlePanel("Title11"),
        value = "1",    #Sidebar 1 is displayed, Value in " " so that you can jump to the next tab
        
        "Explanation1.",
        
        textOutput("test1")
        
      ), #End of TabPanel
      id = "tabselected"    #Important for event button and conditional sidebar
    ) #End of TabsetPanel
  )
)
)
