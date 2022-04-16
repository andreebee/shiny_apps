#### Mit Quiz 2.0
#fuer Conditional Panel:
#https://stackoverflow.com/questions/53226229/conditionalpanel-with-tabpanel
# ohne submit Button

#https://www.ifad.de/mittelwertvergleiche-mittels-t-test/
#To do: Formuliereungen/Erklärungen, eventuell tab namen erscheinen

# https://stackoverflow.com/questions/68079731/how-to-create-a-shiny-app-where-tabs-are-only-become-visible-if-a-condition-is-m
# insertTab, Tabs erscheinen erst nach richtiger Antwort

#richtige Antwort als Umgebungsvariable, macht den Code einfacher -> vielleicht noch aendern
# -> Geht nicht https://stackoverflow.com/questions/34658490/conditionalpanel-in-shiny-not-working
# Fragen
# Antwort1_1 = "Die Änderung der Differenz des Mittelwertes hat keine Auswirkung"
# Antwort1_2 = "Eine größe Differenz der Mittelwerte erzeugt einen großen p-Wert"
# Antwort1_3_R = "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert"

# It is important not to have same wording for the right answer of different question  

library(shiny)
library(ggplot2)

#Draw groups at the beginning so that they stay the same and only the changes in the parameters have an influence and not chance
#set.seed(1)
#Gruppe1 = rnorm(1000)   
#set.seed(2)
#Gruppe2 = rnorm(1000) # Generate more so that the sample remains the same even if the number varies

# for the sake of development
#def_answer1 <- 'Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert'
#def_answer2 <- 'Eine größere Standardabweichung erzeugt einen größeren p-Wert'
#def_answer3 <- 'Höherere Fallzahlen führen zu kleineren p-Werten'
def_answer1 <- NULL
def_answer2 <- NULL
def_answer3 <- NULL

ui <- shinyUI(pageWithSidebar(
    headerPanel("Zweiseitiger t-Test"),
    
    sidebarPanel(
      
      # From here Tab -1 sidebar panel #########################################
       conditionalPanel(
         condition = "input.tabselected ==-1",
         
         #Add a Slider
         sliderInput(
           inputId = "diff0",
           label = "Differenz der Erwartungswerte",
           min = 0,
           max = 2,
           step = 0.1,
           value = 1
         ),
         # Add a slider
         sliderInput(
           inputId = "sd0",
           label = "Standardabweichung",
           min = 1,
           max = 15,
           step = 1,
           value = 8
         ),
         # Add a slider
         sliderInput(
           inputId = "n0",
           label = "Fallzahl",
           min = 250,
           max = 1250,
           step = 50,
           value = 500
         ),
         # Add a slider
         sliderInput(
           inputId = "nn",
           label = "Stichprobengröße",
           min = 50,
           max = 500,
           step = 1,
           value = 100
         ),
         
         actionButton("Tab0", label = "Nächstes Tab")
       ),
       # End of Tab -1 sidebar panel ###########################################
        
      # From here Tab 0 sidebar panel #########################################
       conditionalPanel(
         condition = "input.tabselected ==0",
         actionButton("Tab1", label = "Nächstes Tab"),
         actionButton("vorher_1", label = "Vorheriges Tab")
       ),
      # End of Tab 0 sidebar panel #############################################
         
        conditionalPanel(
            condition = "input.tabselected ==1",
            #Condition for this sidebar to be displayed
            #Add a Slider
            sliderInput(
                inputId = "diff",
                label = "Differenz der Erwartungswerte",
                min = 0,
                max = 2,
                step = 0.1,
                value = 1
            ),
            
            "Beantworten Sie folgende Frage, um zum nächsten Tab zu gelangen. ",
            
            #Quiz
            selectInput(
                inputId = "quiz1",
                label = "Welche Aussage stimmt?",
                selected = def_answer1,
                choices = c("","Die Änderung der Differenz des Mittelwertes hat keine Auswirkung",
                            "Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert",
                            "Eine größere Differenz der Mittelwerte erzeugt einen größeren p-Wert"     )
            ),
            #correct answer -> give explanation
            conditionalPanel("input.quiz1 ===  'Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert'",   #richtige Antwort gegeben
                             HTML(paste0("<br>","<b>", "Richtige Antwort","</b>", "</br>")),
                             HTML(paste0("<b>", "Erklärung:", "</b>")),
                             paste0("Größere Mittelwertunterschiede bzw. stärkere Effekte sind für den Test leichter zu erkennen und führen daher zu kleineren p-Werten."),
                             actionButton("Tab2", label = "Nächstes Tab")
            ),
            #wrong answer 
            conditionalPanel("input.quiz1 !== 'Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert' ",   #richtige Antwort gegeben
                             htmlOutput("q1")
            ),
            actionButton("vorher0", label = "Vorheriges Tab")
        ), #End of the first conditional panel
        
        conditionalPanel(
            condition = "input.tabselected == 2", #Condition for this sidebar to be displayed
            
            # Add a slider
            sliderInput(
                inputId = "diff2",
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
            
            "Beantworten Sie folgende Frage, um zum nächsten Tab zu gelangen. ",
            
            #Quiz
            selectInput(
                inputId = "quiz2",
                label = " Welche Aussage stimmt?",
                selected = def_answer2,
                choices = c("",
                    "Die Änderung der Standardabweichung hat keine Auswirkung",
                    "Eine größere Standardabweichung erzeugt einen kleineren p-Wert",
                    "Eine größere Standardabweichung erzeugt einen größeren p-Wert"
                )
            ),
            

            #correct answer -> give explanation
            conditionalPanel("input.quiz2 === 'Eine größere Standardabweichung erzeugt einen größeren p-Wert'", #the answer is correct
                             HTML(paste0("<b>", "Richtige Antwort","</b>", "</br>")),
                             HTML(paste0("<b>", "Erklärung:", "</b>")),
                             HTML(paste0("Ein Mittelwertunterschied / ein Effekt ist bei größerer Standartabweichung schwerer für den Test zu erkennen. Dies führt zu einem größeren p-Wert.", "<br>")),
                             actionButton("Tab3", label = "Nächstes Tab")
            ) ,
            #wrong answer 
            conditionalPanel("input.quiz2 !== 'Eine größere Standardabweichung erzeugt einen größeren p-Wert'", #the answer is correct
                             htmlOutput("q2")
            ),
            actionButton("vorher2", label = "Vorheriges Tab") #Back Button
            
        ), #End of the second conditional panel
        
        conditionalPanel(
            "input.tabselected == 3",
            #Condition for this sidebar to be displayed
            #Add a Slider
            sliderInput(
                inputId = "diff3",
                label = "Differenz der Erwartungswerte",
                min = 0,
                max = 2,
                step = 0.1,
                value = 1
            ),
            
            # Add a slider
            sliderInput(
                inputId = "sd2",
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
            
            "Beantworten Sie folgende Frage, um zum nächsten Tab zu gelangen. ",
            
            #Quiz
            selectInput(
                inputId = "quiz3",
                label = " Welche Aussage stimmt?",
                selected = def_answer3,
                choices = c("",
                    "Die Änderung der Fallzahl hat keine Auswirkung",
                    "Höherere Fallzahlen führen zu kleineren p-Werten",
                    "Höherere Fallzahlen führen zu größeren p-Werten"
                )
            ),
            
            #correct answer -> give explanation
            conditionalPanel("input.quiz3 === 'Höherere Fallzahlen führen zu kleineren p-Werten'", #the answer is correct
                             HTML(paste0("<b>", "Richtige Antwort","</b>", "</br>")),
                             HTML(paste0("<b>", "Erklärung:", "</b>")),
                             HTML(paste0("Je höher die Fallzahl, desto leichter kann ein Test einen Unterschied erkennen. Dies führt zu kleineren p-Werten.", "<br>")),
                             actionButton("Tab4", label = "Nächstes Tab")
            ),
            #wrong answer
            conditionalPanel("input.quiz3 !== 'Höherere Fallzahlen führen zu kleineren p-Werten'", #the answer is correct
                             htmlOutput("q3")
            ),
            actionButton("vorher3", label = "Vorheriges Tab") #Back Button
            
        ), #End of the third conditonal panel
        
        conditionalPanel(
            "input.tabselected == 4",
            #Condition for this sidebar to be displayed
            #Add a Slider
            sliderInput(
              inputId = "diff4",
              label = "Differenz der Erwartungswerte",
              min = 0,
              max = 2,
              step = 0.1,
              value = 1
            ),
            
            # Add a slider
            sliderInput(
              inputId = "sd3",
              label = "Standardabweichung",
              min = 1,
              max = 15,
              step = 1,
              value = 8
            ),
            
            # Add a slider
            sliderInput(
              inputId = "n2",
              label = "Fallzahl",
              min = 250,
              max = 1250,
              step = 50,
              value = 500
            ),
            # check box to show the plot for the p values
            checkboxInput("showvalues", "Einzelne p-Werte anzeigen", value = FALSE, width = NULL),
            actionButton("vorher4", label = "Vorheriges Tab")
        )
    ), #End of the Sidebar Panel
    
    mainPanel(
        #Output: Tabset with plots
        tabsetPanel(
            type = "tabs",
            
            # From here Tab -1 main panel ######################################
            tabPanel(
              title = "-1",
              titlePanel("-1"),
              value =  "-1",
              plotOutput("barplot"),
              plotOutput("playplot")
            ),
            # End of Tab -1 main panel #########################################
            
            # From here Tab 0  main panel ######################################
            tabPanel(
              title = "0",
              titlePanel("0"),
              value =  "0",
              plotOutput("boxPlot0"),    #Box-Plot
              HTML(paste0("<b>", "p-Wert", "</b>")),
              htmlOutput("p0") #p-value
            ),
            # End of Tab 0 main panel ##########################################
            
            #From here  Tab 1 #########################################################################
            
            tabPanel(
                title = "Differenz",
                titlePanel("Effekt der Differenz der Erwartungswerte zweier Normalverteilungen"),
                value = "1",    #Sidebar 1 is displayed, Value in " " so that you can jump to the next tab
                
                "Hier sieht man den Effekt auf den p-Wert, wenn sich die
                 Differenz der Mittelwerte zweier normalverteilten
                 Stichproben ändert.",
                
                plotOutput("boxPlot1"),    #Box-Plot
                HTML(paste0("<b>", "p-Wert", "</b>")),
                htmlOutput("p1") #p-value
               
            ), #End of TabPanel
            id = "tabselected"    #Important for event button and conditional sidebar
            
        ) #End of TabsetPanel
      )
    )
)



server = function(input, output, session) {
  
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
                          label = "Erwartungswert \n Gruppe 2"),colour="#00BFC4")
                       
          
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
    
    #setting default values for sd and sample size
    def_sd <- reactive({8})
    def_n <- reactive({500})
    
    ######################### Define output for individual tabs #####################
    
    ########################## for tab -1 ######################################
    observeEvent(input$Tab0, {
      updateTabsetPanel(session, "tabselected",
                        selected = "0")
    })
    
    output$barplot <- renderPlot({
      
      #calling Gruppe1 and Gruppe2
      Gruppe1 <- Gruppe1()
      Gruppe2 <- Gruppe2()
      Gruppe1 = Gruppe1[1:input$n0] * input$sd0
      #Create group 2 by adding the difference between the mean values, cut off so that group 1 and group 2 have the same number of values
      Gruppe2 = Gruppe2[1:input$n0] * input$sd0 + input$diff0
      set.seed(1)
      Stichproben1 = replicate(100, sample(Gruppe1,size = input$nn, replace = FALSE))
      set.seed(2)
      Stichproben2 = replicate(1, sample(Gruppe2,size = input$nn, replace = FALSE))
      t = apply(Stichproben1,
                2 ,
                t.test,
                y = Stichproben2,
                alternative = "two.sided")    #List that contains lists, do the t-test for all samples for Group1
      #https://stackoverflow.com/questions/20428742/select-first-element-of-nested-list fuer lapply Befehl
      p_Wert = lapply(t, '[[', 3)             #Generate vector with the p-values
      signifikant = sum(p_Wert < 0.05)        #Number of significant and insignificant p-values
      nicht_signifikant = sum(p_Wert >= 0.05)
      
      bar_df <- data.frame(t_test=c("signifikant", "nicht signifikant"),
                           Anzahl=c(signifikant,nicht_signifikant),
                           result=c("p-Werte","p-Werte"))
      
      ggplot(data=bar_df, aes(x=result,y=Anzahl,fill=t_test)) +
        geom_bar(stat="identity",width = 0.5) +
        ggtitle("Anzahl signifikanter p-Werte für 1000 Simulationen")+
        coord_flip()+
        labs(x = "")+
        theme(plot.title = element_text(hjust = 0.5),
              aspect.ratio = 0.2,
              axis.text.y = element_blank(),axis.ticks.y = element_blank()) +
        guides(fill=guide_legend(reverse=T,title="Ergebnis t-Test")) +
        scale_fill_manual(values=c("#ffb300","#2aff00"))
    })
    
    output$playplot <- renderPlot({
        
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:input$n0] * input$sd0
        #Create group 2 by adding the difference between the mean values, cut off so that group 1 and group 2 have the same number of values
        Gruppe2 = Gruppe2[1:input$n0] * input$sd0 + input$diff0
        set.seed(1)
        Stichproben1 = replicate(100, sample(Gruppe1,size = input$nn, replace = FALSE))
        set.seed(2)
        Stichproben2 = replicate(1, sample(Gruppe2,size = input$nn, replace = FALSE)) 
        t = apply(Stichproben1,
                  2 ,
                  t.test,
                  y = Stichproben2,
                  alternative = "two.sided")    #List that contains lists, do the t-test for all samples for Group1
        #https://stackoverflow.com/questions/20428742/select-first-element-of-nested-list fuer lapply Befehl
        p_Wert = lapply(t, '[[', 3)             #Generate vector with the p-values
        
        # dataframe for the p values
        dot_df <- data.frame(no=seq(1,100,1),pWert=unlist(p_Wert))
        dot_df$g <- ifelse(dot_df$pWert >= 0.05,"nicht signifikant","signifikant")
        
        # plot the p values
        ggplot(dot_df, aes(x=no, y=pWert,color=g)) +
          geom_point() +
          geom_hline(yintercept = 0.05,color="black")+
          scale_y_continuous(breaks=sort(c(seq(from=0,to=1,by=0.25), 0.05)), limits = c(0, 1)) +
          labs(x = "Simulation") +
          ggtitle("Einzelne p-Werte") +
          guides(color=guide_legend(reverse=T,title="Ergebnis t-Test")) +
          scale_color_manual(values=c("#ffb300","#2aff00"))
      
    })
    
    ########################## for tab 0 #######################################
    observeEvent(input$Tab1, {
      updateTabsetPanel(session, "tabselected",
                        selected = "1")
    })
    
    observeEvent(input$vorher_1, {
      updateTabsetPanel(session, "tabselected",
                        selected = "-1")
    })
    
    output$p0 <- renderUI({
      #calling Gruppe1 and Gruppe2
      Gruppe1 <- Gruppe1()
      Gruppe2 <- Gruppe2()
      Gruppe1 = Gruppe1[1:input$n0] * input$sd0
      #Create group 2 by adding the difference between the mean values, cut off so that group 1 and group 2 have the same number of values
      Gruppe2 = Gruppe2[1:input$n0] * input$sd0 + input$diff0
      p <- p_Wert(Gruppe1, Gruppe2)
      wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
      result <- paste("<b>",p[[2]],"</b>")
      HTML(paste(wert,result,sep="<br/>"))
    })
    
    #create the Boxplot and the values,only the differences of the MW is included
    output$boxPlot0 = renderPlot({
      #calling Gruppe1 and Gruppe2
      Gruppe1 <- Gruppe1()
      Gruppe2 <- Gruppe2()
      Gruppe1 = Gruppe1[1:input$n0] * input$sd0
      Gruppe2 = Gruppe2[1:input$n0] * input$sd0 + input$diff0
      BoxPlot(Gruppe1, Gruppe2)
    })
    
    ##########################for first tab (MW difference)###########################
    observeEvent(input$vorher0, {
      updateTabsetPanel(session, "tabselected",
                        selected = "0")
    })
    
    # avoid showing wrong answer before selecting a choice
    output$q1 <- renderUI({
      if(as.character(input$quiz1)==""){
        HTML(paste0("<br>","<b>","Bitte treffen Sie eine Auswahl","</b>", "</br>"))
      } else {
        HTML(paste0("<br>","<b>","Falsche Antwort","</b>", "</br>"))
      }
    })
    
    output$p1 <- renderUI({
        #using default values for sd and sample size
        def_sd <- def_sd()
        def_n <- def_n()
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:def_n] * def_sd
        #Create group 2 by adding the difference between the mean values, cut off so that group 1 and group 2 have the same number of values
        Gruppe2 = Gruppe2[1:def_n] * def_sd + input$diff
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #create the Boxplot and the values,only the differences of the MW is included
    output$boxPlot1 = renderPlot({
        #using default values for sd and sample size
        def_sd <- def_sd()
        def_n <- def_n()
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:def_n] * def_sd
        Gruppe2 = Gruppe2[1:def_n] * def_sd + input$diff
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    
    ######################  for Tab 2 SD ###################################################
    #When you click the "next tab button" in tab 1, you jump to tab 2
    observeEvent(input$Tab2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })

    # avoid showing wrong answer before selecting a choice
    output$q2 <- renderUI({
      if(as.character(input$quiz2)==""){
        HTML(paste0("<br>","<b>","Bitte treffen Sie eine Auswahl","</b>", "</br>"))
      } else {
        HTML(paste0("<br>","<b>","Falsche Antwort","</b>", "</br>"))
      }
    })    
        
    output$p2 <- renderUI({
        #using default values for sd and sample size
        def_n <- def_n()
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:def_n] * input$sd
                #use transformation: z=x-mu/sigma -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:def_n] * input$sd + input$diff2
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #Box plot of the values
    output$boxPlot2 = renderPlot({
        #using default values for sd and sample size
        def_n <- def_n()
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:def_n] * input$sd
        ##use transformation: z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:def_n] * input$sd + input$diff2
        BoxPlot(Gruppe1, Gruppe2)
    })
    
 
    
    #go to the previous tab
    observeEvent(input$vorher2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "1")
    })
    
    #Tab only visible after the correct answer
    observeEvent(input$quiz1,{
      if(input$quiz1 == "Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert" ){  #condition
        insertTab(inputId = "tabselected",                                                      #The tab is inserted here
                  tabPanel(
                    title = "Differenz und Standardabweichung" ,
                    value = "2",       #Sidebar 2 is displayed
                    titlePanel("Effekt der Differenz der Erwartungswerte und der Standardabweichung zweier Normalverteilungen"),
                      
                      "Hier sieht man den Effekt auf den p-Wert, wenn sich die
                     Standardabweichung ändert.",
                      
                      plotOutput("boxPlot2"),    #Box-Plot
                      HTML(paste0("<b>", "p-Wert", "</b>")),
                      htmlOutput("p2"),          #p-value
                      
                   
                  ) #End of the TabPanel
                  , target="1", position ="after" )
      }
      
      if(input$quiz1 != "Eine größere Differenz der Mittelwerte erzeugt einen kleineren p-Wert" ){  #condition
        removeTab(inputId = "tabselected",                                                      #Here the tab is cleared if the wrong answer is entered after the correct one
                   target="2" )
      }
    })
    
    
    ################################### for Tab 3: Fallzahl #######################################
    observeEvent(input$Tab3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
    
    # avoid showing wrong answer before selecting a choice
    output$q3 <- renderUI({
      if(as.character(input$quiz3)==""){
        HTML(paste0("<br>","<b>","Bitte treffen Sie eine Auswahl","</b>", "</br>"))
      } else {
        HTML(paste0("<br>","<b>","Falsche Antwort","</b>", "</br>"))
      }
    })    
    
    output$p3 = renderUI({
        #set seed to generate same random values
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:input$n] * input$sd2
        #Create group2 with transformation + cut
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #Boxplot, of the Values
    output$boxPlot3 = renderPlot({
        #calling Gruppe1 and Gruppe2
        Gruppe1 <- Gruppe1()
        Gruppe2 <- Gruppe2()
        Gruppe1 = Gruppe1[1:input$n] * input$sd2
        #Create group2 with transformation + cut
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        BoxPlot(Gruppe1, Gruppe2)
    })

    #go to the previous tab
    observeEvent(input$vorher3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
    #Tab only visible after the correct answer is given
    observeEvent(input$quiz2,{
      
      if(input$quiz2 == "Eine größere Standardabweichung erzeugt einen größeren p-Wert" ){
        insertTab(inputId = "tabselected",                                                           #Insert tab
                  tabPanel(
                    title = "Differenz, Standardabweichung und Fallzahl",
                    value = "3",  #Sidebar 3 is displayed
                   titlePanel("Effekt der Differenz der Erwartungswerte, Standardabweichung und Fallzahl zweier Normalverteilungen"),
                      
                      "Hier sieht man den Effekt auf den p-Wert, wenn sich die
                     Fallzahl der Merkmalsträger ändert.",
                      
                      plotOutput("boxPlot3"),    #Box-Plot
                      HTML(paste0("<b>", "p-Wert", "</b>")),
                      htmlOutput("p3"),          #p-value
                      #plotOutput("sigPlot"),     #Significance histogram
                      
                  )#End of TabPanel
                  , target="2", position ="after" )
      }
      
      if(input$quiz2 != "Eine größere Standardabweichung erzeugt einen größeren p-Wert" ){
        removeTab(inputId = "tabselected",                                                           #Delete tab if the answer is wrong
                   target="3")
      }
    })
    
    
    ######################## Tab 4 ####################################################
    observeEvent(input$Tab4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "4")
    })
    
    #Idea: you draw group 2 1000 times and see how often the result is significant
    #Generate vector with b entries
    #Vektor = rep(0, 1000)
    #Vektor[i] = rnorm(input$n, input$diff, input$sd)
    
    output$sigPlot = renderPlot({
      #calling Gruppe1 and Gruppe2
      Gruppe1 <- Gruppe1()
      Gruppe2 <- Gruppe2()
      Gruppe1 = Gruppe1[1:input$n2] * input$sd3
      Stichproben = replicate(1000, rnorm(input$n2, input$diff4, input$sd3))     #Take 1000 samples
      t = apply(Stichproben,
                2 ,
                t.test,
                y = Gruppe1,
                alternative = "two.sided")    #List that contains lists, do the t-test for all samples for Group1
      #https://stackoverflow.com/questions/20428742/select-first-element-of-nested-list fuer lapply Befehl
      p_Wert = lapply(t, '[[', 3)             #Generate vector with the p-values
      signifikant = sum(p_Wert < 0.05)        #Number of significant and insignificant p-values
      nicht_signifikant = sum(p_Wert >= 0.05)
      
      #Plot mit Legende erzeugen
      
      #barplot(
      #c(signifikant, nicht_signifikant),
      #ylim = c(0, 1000) ,
      #main = "Anteil signifikanter p-Werte für 1000 Simulationen",
      #xlab = "signifikant/nicht signifikant",
      #ylab = "Anteil",
      #col = c(3, 7)
      #)
      #legend(
      #1,
      #95,
      #legend = c("signifikanter p-Wert", "kein signifikanter p-Wert"),
      #fill = c(3, 7),
      #cex = 0.8
      #)
      
      bar_df <- data.frame(t_test=c("signifikant", "nicht signifikant"),
                           Anzahl=c(signifikant,nicht_signifikant),
                           result=c("p-Werte","p-Werte"))
      
      ggplot(data=bar_df, aes(x=result,y=Anzahl,fill=t_test)) +
        geom_bar(stat="identity",width = 0.5) +
        ggtitle("Anzahl signifikanter p-Werte für 1000 Simulationen")+
        coord_flip()+
        labs(x = "")+
        theme(plot.title = element_text(hjust = 0.5),
              aspect.ratio = 0.2,
              axis.text.y = element_blank(),axis.ticks.y = element_blank()) +
        guides(fill=guide_legend(reverse=T,title="Ergebnis t-Test")) +
        scale_fill_manual(values=c("#fad784","#84f86d"))
    })
    
    output$pvalues = renderPlot({
      
      # show the plot if the check box is checked
      if(input$showvalues == TRUE) {
      
      #calling Gruppe1 and Gruppe2
      Gruppe1 <- Gruppe1()
      Gruppe2 <- Gruppe2()
      Gruppe1 = Gruppe1[1:input$n2] * input$sd3
      Stichproben = replicate(1000, rnorm(input$n2, input$diff4, input$sd3))     #Take 1000 samples
      t = apply(Stichproben,
                2 ,
                t.test,
                y = Gruppe1,
                alternative = "two.sided")    #List that contains lists, do the t-test for all samples for Group1
      #https://stackoverflow.com/questions/20428742/select-first-element-of-nested-list fuer lapply Befehl
      p_Wert = lapply(t, '[[', 3)             #Generate vector with the p-values
      
      # dataframe for the p values
      dot_df <- data.frame(no=seq(1,1000,1),pWert=unlist(p_Wert))
      dot_df$g <- ifelse(dot_df$pWert >= 0.05,"nicht signifikant","signifikant")
      
      # plot the p values
      ggplot(dot_df, aes(x=no, y=pWert,color=g)) +
        geom_point() +
        geom_hline(yintercept = 0.05,color="black")+
        scale_y_continuous(breaks=sort(c(seq(from=0,to=1,by=0.25), 0.05)), limits = c(0, 1)) +
        labs(x = "Simulation") +
        ggtitle("Einzelne p-Werte") +
        guides(color=guide_legend(reverse=T,title="Ergebnis t-Test")) +
        scale_color_manual(values=c("#fad784","#84f86d"))
      }
      else {}
      
    })
    
    #go to the previous tab
    observeEvent(input$vorher4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
    
    #Tab only visible after the correct answer is given
    observeEvent(input$quiz3,{
      
      if(input$quiz3 == "Höherere Fallzahlen führen zu kleineren p-Werten" ){
        insertTab(inputId = "tabselected",                                    #Insert tab
                  tabPanel(
                    title = "Ergebnis",
                    value = "4",   #Sidebar 4 is displayed
                    titlePanel("Ergebnis"),
                      
                    # Quelle Bild: https://www.pinterest.de/pin/819373725934792787/
                    # HTML(paste0("<b>", "p-Wert", "</b>")),
                    # img(src='Smiley.png', align = "bottomleft"),
                      "Sie haben alle Fragen richtig beantwortet.  " ,
                    #)
                    plotOutput("sigPlot", height = 200),    #Significance histogram
                    plotOutput("pvalues"),
                  )#End of TabPanel
                  , target="3", position ="after" )
      }
      if(input$quiz3 != "Höherere Fallzahlen führen zu kleineren p-Werten" ){
        removeTab(inputId = "tabselected",        #Delete tab if the wrong answer is given
                   target="4" )
      }
      
      
      
    })
    
  }


shinyApp(ui = ui, server = server)
