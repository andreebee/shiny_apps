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
#   

library(shiny)
library(ggplot2)

#Draw groups at the beginning so that they stay the same and only the changes in the parameters have an influence and not chance
Gruppe1 = rnorm(500)   
Gruppe2 = rnorm(1000) # Generate more so that the sample remains the same even if the number varies

ui <- shinyUI(pageWithSidebar(
    headerPanel("Zweiseitiger t-Test"),
    
    sidebarPanel(
        conditionalPanel(
            condition = "input.tabselected ==1",
            #Condition for this sidebar to be displayed
            #Add a Slider
            sliderInput(
                inputId = "diff",
                label = "Differenz",
                min = 0,
                max = 1,
                step = 0.1,
                value = 0.5
            ),
            
            "Nun eine Frage, wenn diese richtig beantworte ist, gelangen Sie zum nächsten Tab. Und bekommen eine Erklärung in diesem Tab. ",
            
            #Quiz
            selectInput(
                inputId = "quiz1",
                label = "Welche Aussage stimmt",
                selected = NULL,
                choices = c(" ","Die Änderung der Differenz des Mittelwertes hat keine Auswirkung",
                            "Eine größe Differenz der Mittelwerte erzeugt einen großen p-Wert",
                            "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert"     )
            ),
           
            
            #Explanation
           
                             conditionalPanel("input.quiz1 ===  'Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert'",   #richtige Antwort gegeben
                                              actionButton("Tab2", label = "Nächstes Tab"),
                                              HTML(paste0("<br>","<b>", "Richtige Antwort","</b>", "</br>")),
                                              HTML(paste0("<b>", "Erklärung:", "</b>")),
                                              paste0("Der Effekt ist einmal in dem Boxplot zu erkennen,
                             bei einem kleinem Effekt, sind diese nah ander und in dem p-Wert
                             des t-Tests. Der p-Wert sagt aus, ob der Unterschied signifikant ist oder nicht,
                             aber er sagt nichts über die Stärke des Unterschieds aus.
                             Für den Vergleich der Mittelwerte liegt es nahe, 
                            dass in die Teststatistik die Differenz der Mittelwerte eingeht. 
                            Trotz gleicher Differenzen können sich jedoch die p-Werte und somit auch
                            die Beurteilungen im Hinblick auf die Signifikanz unterscheiden.
                            Die Streuung ist mit einem kleinerem Mittelwert geringer als 
                            mit einem größerem."),
                                              
                      
            ),
            #Output if the answer is wrong
            conditionalPanel("input.quiz1 !== 'Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert'",   #richtige Antwort gegeben
                            HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>")),
                              )              
            
        ), #End of the first conditional panel
        
        conditionalPanel(
            condition = "input.tabselected == 2", #Condition for this sidebar to be displayed
            
            # Add a slider
            sliderInput(
                inputId = "diff2",
                label = "Differenz",
                min = 0,
                max = 1,
                step = 0.1,
                value = 0.5
            ),
            
            # Add a slider
            sliderInput(
                inputId = "sd",
                label = "Standardabweichung",
                min = 0,
                max = 10,
                step = 0.1,
                value = 5
            ),
            
            "Nun eine Frage, wenn diese richtig beantworte ist, gelangen Sie zum nächsten Tab. Und bekommen eine Erklärung in diesem Tab.",
            
            #Quiz
            selectInput(
                inputId = "quiz2",
                label = " Welche Aussage stimmt",
                selected = NULL,
                choices = c("",
                    "Die Änderung der Standardabweichung hat keine Auswirkung",
                    "Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert",
                    "Eine große Änderung der Standardabweichung erzeugt einen kleinen p-Wert"
                )
            ),
            
            actionButton("vorher2", label = "Vorheriges Tab"), #Back Button
           
            
            #Explanation
                             conditionalPanel("input.quiz2 === 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert'", #the answer is correct
                                              actionButton("Tab3", label = "Nächstes Tab"),
                                              HTML(paste0("<br>","<b>", "Richtige Antwort","</b>", "</br>")),
                                              HTML(paste0("<b>", "Erklärung:", "</b>")),
                                              paste0("Der Effekt ist einmal in dem Boxplot zu erkennen,
                             bei einem kleinem Effekt, sind diese nah ander und in dem p-Wert
                             des t-Tests. Der p-Wert sagt aus, ob der Unterschied signifikant ist oder nicht,
                             aber er sagt nichts über die Stärke des Unterschieds aus.
                             Die Differenz der Mittelwerte wird in Relation zur 
                             Standardabweichung des Merkmals beurteilt.")
                                              
                             ) ,
            
            #Output if the answer is wrong
            conditionalPanel("input.quiz2 !== 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert'", #the answer is correct
                             HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>")),
            ) 
            
        ), #End of the second conditional panel
        
        conditionalPanel(
            "input.tabselected == 3",
            #Condition for this sidebar to be displayed
            #Add a Slider
            sliderInput(
                inputId = "diff3",
                label = "Differenz",
                min = 0,
                max = 1,
                step = 0.1,
                value = 0.5
            ),
            
            # Add a slider
            sliderInput(
                inputId = "sd2",
                label = "Standardabweichung",
                min = 0,
                max = 10,
                step = 0.1,
                value = 5
            ),
            
            # Add a slider
            sliderInput(
                inputId = "n",
                label = "Anzahl",
                min = 0,
                max = 1000,
                value = 500
            ),
            
            "Nun eine Frage, wenn diese richtig beantworte ist, gelangen Sie zum nächsten Tab. Und bekommen eine Erklärung in diesem Tab.",
            
            #Quiz
            selectInput(
                inputId = "quiz3",
                label = " Welche Aussage stimmt",
                selected = NULL,
                choices = c("",
                    "Die Änderung der Anzahl der Beobachtungen hat keine Auswirkung",
                    "Ein p-Wert < 0.05 ist signifikant",
                    "Die Änderung der Anzahl der Beobachtungen hat eine mittelmäßige auswirkung auf den p-Wert"
                )
            ),
            
            actionButton("vorher3", label = "Vorheriges Tab"), #Back Button
           
            #Explanation
             conditionalPanel("input.quiz3 === 'Ein p-Wert < 0.05 ist signifikant'", #the answer is correct
                                              actionButton("Tab4", label = "Nächstes Tab"),
                                              HTML(paste0("<br>","<b>", "Richtige Antwort","</b>", "</br>")),
                                              HTML(paste0("<b>", "Erklärung:", "</b>")),
                                              paste0("Ist der p-Wert „klein“, das bedeutet kleiner als ein vorgegebenes Signifikanzniveau
                                                    im allgemein < 0.05, so lässt sich die Nullhypothese ablehvnen.")
                             ),
            
            #Output if the answer is wrong
            conditionalPanel("input.quiz3 !== 'Ein p-Wert < 0.05 ist signifikant'", #the answer is correct
                              HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>"))
            ) 
            
        ), #End of the third contitonal panel
        
        conditionalPanel(
            "input.tabselected == 4",
            actionButton("vorher4", label = "Vorheriges Tab")
        )
    ), #End of the Sidebar Panel
    
    mainPanel(
        #Output: Tabset with plots
        tabsetPanel(
            type = "tabs",
            
            #From here  Tab 1 #########################################################################
            
            tabPanel(
                title = "Differenz",
                titlePanel("Differenz"),
                value = "1",    #Sidebar 1 is displayed, Value in " " so that you can jump to the next tab
                
                "Hier sieht man, welchen Effektes hat, wenn sich die
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
    ################### Create function #########################################
    #Create a box plot with the help of a function
    #Input: two samples
    #Output: boxplot of the samples
    BoxPlot = function(Gruppe1, Gruppe2) {
        #Build a data frame to create a boxplot separated by groups with ggplot
        Wert = c(Gruppe1, Gruppe2)
        Gruppe = c(rep("1", length(Gruppe1)), rep("2", length(Gruppe2)))
        daten = data.frame(Gruppe, Wert)
        
        #Create a box plot with two variables
        ggplot(daten, aes(x = Gruppe, y = Wert, fill = factor(Gruppe))) +   #need a DataFrame
            geom_boxplot() +
            labs(title = "Auswirkung der Änderung") +
            ylim(-5, 5) +
            geom_jitter(width = 0.1, alpha = 0.2)
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
    
    
    ######################### Define output for individual tabs #####################
    ##########################for first tab (MW difference)###########################
    output$p1 <- renderUI({
        #set seed to generate same random values
        set.seed(5)
        #Create group 2 by adding the difference between the mean values, cut off so that group 1 and group 2 have the same number of values
        Gruppe2 = Gruppe2[1:500] + input$diff
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #create the Boxplot and the values,only the differences of the MW is included
    output$boxPlot1 = renderPlot({
        #set seed to generate same random values
        set.seed(5)
        Gruppe2 = Gruppe2[1:500] + input$diff
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    
    ######################  for Tab 2 SD ###################################################
    #When you click the "next tab button" in tab 1, you jump to tab 2
    observeEvent(input$Tab2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
    output$p2 <- renderUI({
        #set seed to generate same random values
        set.seed(5)
        #use transformation: z=x-mu/sigma -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #Box plot of the values
    output$boxPlot2 = renderPlot({
        #set seed to generate same random values
        set.seed(5)
        ##use transformation: z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        BoxPlot(Gruppe1, Gruppe2)
    })
    
 
    
    #go to the previous tab
    observeEvent(input$vorher2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "1")
    })
    
    #Tab only visible after the correct answer
    observeEvent(input$quiz1,{
      if(input$quiz1 == "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert" ){  #condition
        insertTab(inputId = "tabselected",                                                      #The tab is inserted here
                  tabPanel(
                    title = "Differenz und Standardabweichung" ,
                    value = "2",       #Sidebar 2 is displayed
                    titlePanel("Differenz und Standardabweichung"),
                      
                      "Hier sieht man, welchen Effekt es hat, wenn sich die
                     Standardabweichung ändert. Gruppe 1 bleibt fest.",
                      
                      plotOutput("boxPlot2"),    #Box-Plot
                      HTML(paste0("<b>", "p-Wert", "</b>")),
                      htmlOutput("p2"),          #p-value
                      
                   
                  ) #End of the TabPanel
                  , target="1", position ="after" )
      }
      
      if(input$quiz1 != "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert" ){  #condition
        removeTab(inputId = "tabselected",                                                      #Here the tab is cleared if the wrong answer is entered after the correct one
                   target="2" )
      }
    })
    
    
    ################################### for Tab 3: Anzahl #######################################
    observeEvent(input$Tab3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
    
    output$p3 = renderUI({
        #set seed to generate same random values
        set.seed(5)
        #Create group2 with transformation + cut
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        p <- p_Wert(Gruppe1, Gruppe2)
        wert <- paste("p-Wert des zweiseitigen t-Tests: ","<b>",p[[1]],"</b>")
        result <- paste("<b>",p[[2]],"</b>")
        HTML(paste(wert,result,sep="<br/>"))
    })
    
    #Boxplot, of the Values
    output$boxPlot3 = renderPlot({
        #set seed to generate same random values
        set.seed(5)
        #Create group2 with transformation + cut
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    #Idea: you draw group 2 100 times and see how often the result is significant
    #Generate vector with b entries
    #Vektor = rep(0, 100)
    #Vektor[i] = rnorm(input$n, input$diff, input$sd)
    
    output$sigPlot = renderPlot({
        Stichproben = replicate(100, rnorm(input$n, input$diff3, input$sd2))     #Take 100 samples
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
        barplot(
            c(signifikant, nicht_signifikant),
            ylim = c(0, 100) ,
            main = "Anzahl der signifikanten und nicht signifikanten Abweichungen",
            xlab = "signifikant/nicht signifikant",
            ylab = "Anzahl",
            col = c(3, 7)
        )
        legend(
            1,
            95,
            legend = c("signifikanter p-Wert", "kein signifikanter p-Wert"),
            fill = c(3, 7),
            cex = 0.8
        )
    })

    #go to the previous tab
    observeEvent(input$vorher3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
    #Tab only visible after the correct answer is given
    observeEvent(input$quiz2,{
      
      if(input$quiz2 == "Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert" ){
        insertTab(inputId = "tabselected",                                                           #Insert tab
                  tabPanel(
                    title = "Differenz, Standardabweichung und Anzahl",
                    value = "3",  #Sidebar 3 is displayed
                   titlePanel("Differenz, Standardabweichung und Anzahl"),
                      
                      "Hier sieht man, welchen Effekt es hat, wenn sich die
                     Anzahl der Merkmalsträger ändert. Gruppe 1 bleibt fest.",
                      
                      plotOutput("boxPlot3"),    #Box-Plot
                      HTML(paste0("<b>", "p-Wert", "</b>")),
                      htmlOutput("p3"),          #p-value
                      plotOutput("sigPlot"),     #Significance histogram
                      
                  )#End of TabPanel
                  , target="2", position ="after" )
      }
      
      if(input$quiz2 != "Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert" ){
        removeTab(inputId = "tabselected",                                                           #Delete tab if the answer is wrong
                   target="3")
      }
    })
    
    
    ######################## Tab 4 ####################################################
    observeEvent(input$Tab4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "4")
    })
    #go to the previous tab
    observeEvent(input$vorher4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
    
    #Tab only visible after the correct answer is given
    observeEvent(input$quiz3,{
      
      if(input$quiz3 == "Ein p-Wert < 0.05 ist signifikant" ){
        insertTab(inputId = "tabselected",                                    #Insert tab
                  tabPanel(
                    title = "Ergebnis",
                    value = "4",   #Sidebar 4 is displayed
                   titlePanel("Ergebnis"),
                      
                      #Quelle Bild: https://www.pinterest.de/pin/819373725934792787/
                      # HTML(paste0("<b>", "p-Wert", "</b>")),
                     # img(src='Smiley.png', align = "bottomleft"),
                      "Sie haben alle Fragen richtig beantwortet.  " 
                    #)
                  )
                  , target="3", position ="after" )
      }
      if(input$quiz3 != "Ein p-Wert < 0.05 ist signifikant" ){
        removeTab(inputId = "tabselected",                                    #Delete tab if the wrong answer is given
                   target="4" )
      }
      
      
      
    })
    
  }


shinyApp(ui = ui, server = server)









