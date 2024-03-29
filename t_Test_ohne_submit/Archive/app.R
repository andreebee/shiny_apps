#### Mit Quiz 2.0
#fuer Conditional Panel:
#https://stackoverflow.com/questions/53226229/conditionalpanel-with-tabpanel
# ohne submit Button

#https://www.ifad.de/mittelwertvergleiche-mittels-t-test/
#To do: Formuliereungen/Erklärungen, eventuell tab namen erscheinen


library(shiny)
library(ggplot2)

#Gruppen zu beginn ziehen, damit sie gleich bleiben und nur die Veraenderungen der Parameter einen Einfluss haben und nicht der Zufall
Gruppe1 = rnorm(500)   
Gruppe2 = rnorm(1000) #mehr erzeugen, damit die Stichprobe auch bei der Variation der Anzahl gleich bleibt

ui <- shinyUI(pageWithSidebar(
    headerPanel("Zweiseitiger t-Test"),
    
    sidebarPanel(
        conditionalPanel(
            condition = "input.tabselected ==1",
            #Bedingung, damit diese Sidebar eingeblendet wird
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
                label = " Welche Aussage stimmt",
                selected = NULL,
                choices = c(" ",
                    "Die Änderung der Differenz des Mittelwertes hat keine Auswirkung",
                    "Eine größe Differenz der Mittelwerte erzeugt einen großen p-Wert",
                    "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert"
                )
            ),
           
            
            #Erklaerung
           
                             conditionalPanel("input.quiz1 === 'Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert'",   #richtige Antwort gegeben
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
            # Bei falscher Antwort
            conditionalPanel("input.quiz1 !== 'Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert'",   #richtige Antwort gegeben
                            HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>")),
                              )              
            
        ), #Ende von dem ersten conditional Panel
        
        conditionalPanel(
            condition = "input.tabselected == 2", #Bedingung, damit diese Sidebar eingeblendet wird
            
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
            
            actionButton("vorher2", label = "Vorheriges Tab"), #zuruek Button
           
            
            #Erklaerung
                             conditionalPanel("input.quiz2 === 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert'", #richtige Antwort gegeben
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
            
            #Output bei Falscher Antwort
            conditionalPanel("input.quiz2 !== 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert'", #richtige Antwort gegeben
                             HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>")),
            ) 
            
        ), #Ende zweites conditional Panel
        
        conditionalPanel(
            "input.tabselected == 3",
            #Bedingung, damit diese Sidebar eingeblendet wird
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
            
            actionButton("vorher3", label = "Vorheriges Tab"), #zuruek Button
           
            #Erklaerung
             conditionalPanel("input.quiz3 === 'Ein p-Wert < 0.05 ist signifikant'", #richtige Antwort gegeben
                                              actionButton("Tab4", label = "Nächstes Tab"),
                                              HTML(paste0("<br>","<b>", "Richtige Antwort","</b>", "</br>")),
                                              HTML(paste0("<b>", "Erklärung:", "</b>")),
                                              paste0("Ist der p-Wert „klein“, das bedeutet kleiner als ein vorgegebenes Signifikanzniveau
                                                    im allgemein < 0.05, so lässt sich die Nullhypothese ablehvnen.")
                             ),
            
            #Output bei falscher Antwort
            conditionalPanel("input.quiz3 !== 'Ein p-Wert < 0.05 ist signifikant'", #richtige Antwort gegeben
                              HTML(paste0("<br>","<b>", "Falsche Antwort","</b>", "</br>"))
            ) 
            
        ), #Ende drittes contitonal Panel
        
        conditionalPanel(
            "input.tabselected == 4",
            actionButton("vorher4", label = "Vorheriges Tab")
        )
    ), #Ende Sidebar Panel
    
    mainPanel(
        #Output: Tabset with plots
        tabsetPanel(
            type = "tabs",
            
            #Ab hier Tab 1 #########################################################################
            
            tabPanel(
                title = "",
                titlePanel("Differenz"),
                value = "1",    #Sidebar 1 wird eingeblendet, Value in "" damit man in das naechste Tab springen kann
                
                "Hier sieht man, welchen Effektes hat, wenn sich die
                 Differenz der Mittelwerte zweier normalverteilten
                 Stichproben ändert.",
                
                plotOutput("boxPlot1"),    #Box-Plot
                HTML(paste0("<b>", "p-Wert", "</b>")),
                textOutput("p1"),          #p-Wert
                #htmlOutput("Erklaerung1")#, #richtige oder falsche Antwort ausgeben
               # uiOutput("Button1")        #Button um ins naechste Tab zu springen
            ), #Ende TabPanel
            
            #Ab hier Tab 2 ###############################################################################
            
            tabPanel(
                title = "" ,
                value = "2",       #Sidebar 2 wird eingeblendet
                conditionalPanel(
                    "input.quiz1 === 'Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert'", #Bedingung, wann der Inhalt angezeigt wird
                    titlePanel("Differenz und Standardabweichung"),
                    
                    "Hier sieht man, welchen Effekt es hat, wenn sich die
                     Standardabweichung ändert. Gruppe 1 bleibt fest.",
                    
                    plotOutput("boxPlot2"),    #Box-Plot
                    HTML(paste0("<b>", "p-Wert", "</b>")),
                    textOutput("p2"),          #p-Wert
                    #htmlOutput("Erklaerung2")#, #richtige oder falsche Antwort ausgeben
                    #uiOutput("Button2")        #Button um ins naechste Tab zu springen
                )#Ende CoditionalPanel
            ), #Ende TabPanel
            
            #Ab hier Tab 3 #####################################################################################
            
            tabPanel(
                title = "",
                value = "3",  #Sidebar 3 wird eingeblendet
                conditionalPanel(
                    "input.quiz2 === 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert'", #Bedingung, wann der Inhalt angezeigt wird
                    titlePanel("Differenz, Standardabweichung und Anzahl"),
                    
                    "Hier sieht man, welchen Effekt es hat, wenn sich die
                     Anzahl der Merkmalsträger ändert. Gruppe 1 bleibt fest.",
                    
                    plotOutput("boxPlot3"),    #Box-Plot
                    HTML(paste0("<b>", "p-Wert", "</b>")),
                    textOutput("p3"),          #p-Wert
                    plotOutput("sigPlot"),     #Histogramm zu Signifikanz
                    #htmlOutput("Erklaerung3")#, #richtige oder falsche Antwort ausgeben
                    #uiOutput("Button3")        #Button um ins naechste Tab zu springen
                    
                ) #Ende Conditional Panel
            ),#Ende TabPanel
            
            #Ab hier Tab4 ##############################################
            
            tabPanel(
                title = " ",
                value = "4",   #Sidebar 4 wird eingeblendet
                conditionalPanel(
                    "input.quiz3 === 'Ein p-Wert < 0.05 ist signifikant'", #Bedingung, wann der Inhalt angezeigt wird
                    titlePanel("Ergebnis"),
                    
                    #Quelle Bild: https://www.pinterest.de/pin/819373725934792787/
                    # HTML(paste0("<b>", "p-Wert", "</b>")),
                    img(src='Smiley.png', align = "bottomleft"),
                    "Sie haben alle Fragen richtig beantwortet.  " 
                )
            ),
            id = "tabselected"    #Wichtig, fuer event Button und conditional Sidebar
        )
    )
)
)


server = function(input, output, session) {
    ################### Funktionen schreiben #########################################
    #Boxplot mit Hilfe einer Funktion erzeugen
    #Eingabe: zwei Stichproben
    #Ausgabe: boxplot der Stichproben
    BoxPlot = function(Gruppe1, Gruppe2) {
        #Data frame bauen, um boxplot nach Gruppen getrennt mit ggplot zu erzeugen
        Wert = c(Gruppe1, Gruppe2)
        Gruppe = c(rep("1", length(Gruppe1)), rep("2", length(Gruppe2)))
        daten = data.frame(Gruppe, Wert)
        
        #Boxplot mit zwei Var erstellen
        ggplot(daten, aes(x = Gruppe, y = Wert, fill = factor(Gruppe))) +   #benoetigt DataFrame
            geom_boxplot() +
            labs(title = "Auswirkung der Änderung") +
            ylim(-5, 5) +
            geom_jitter(width = 0.1, alpha = 0.2)
    } #Ende BoxPlot
    
    #p-Wert berechnung als Funktion
    #Eingabe: Stichproben von denen der p-Wert berechnet werden soll
    #Ausgabe: kurzer Text: "p-Wert des zweiseitigen t-Tests: " und der p-Wert
    p_Wert = function(Gruppe1, Gruppe2) {
        p = t.test(Gruppe1, Gruppe2, alternative = "two.sided")$p.value   #2 seitiger t-Test
        p = round(p, digits = 10) #runden
        if (p < 0.001) {
            p = "<0.001"
        }
        else{
            p = p
        }
        paste("p-Wert des zweiseitigen t-Tests: ", p)
    } #Ende p_Wert
    
    
    ######################### Output fuer einzelne Tabs definieren #####################
    ########################## fuer ersten Tab ( MW Differenz) ###########################
    output$p1 = renderText({
        #Gruppe 2 durch anddieren der Differenz der Mittelwerte erzeugen, abschneiden, damit Gruppe1 und Gruppe2 gleiche Anzahl an Werten besitzen
        Gruppe2 = Gruppe2[1:500] + input$diff
        p_Wert(Gruppe1, Gruppe2)
    })
    
    #Boxplot, der Werte, nur MW Diff geht ein
    output$boxPlot1 = renderPlot({
        Gruppe2 = Gruppe2[1:500] + input$diff
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    #Erklaerung als Text
    #Reactive
#    Erklaerung1_reactive = eventReactive(input$quiz1, {
#        if (input$quiz1 == "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert") {
#           HTML(paste0("<b>", "Richtige Antwort", "</b>"))
#        }
#        else{
#            HTML( paste0("<strong>", "Falsche Antwort", "</strong>"))
#        }
#    })
    #Text Output
#    output$Erklaerung1 <- renderUI({
#        Erklaerung1_reactive()
#    })
#    
    #Button um in naestes Tab zu springen
   # Button1_reactive = eventReactive(input$quiz1, {
  #      if (input$quiz1 == "Eine kleine Differenz der Mittelwerte erzeugt einen großen p-Wert") {
  #          actionButton("Tab2", label = "Nächstes Tab")
  #      }
  #      else{
  #          paste0("")
 #       }
 #   })
    
    #Output id Button
  #  output$Button1 <- renderUI({
 #       Button1_reactive()
 #   })
    
    ######################  fuer Tab 2 SD ###################################################
    #Bei klingen des naestes Tab Button in Tab 1 springt man in Tab 2
    observeEvent(input$Tab2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
    output$p2 <- renderText({
        #nutze Trafo, z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        p_Wert(Gruppe1, Gruppe2)
    })
    
    #Boxplot, der Werte
    output$boxPlot2 = renderPlot({
        #nutze Trafo, z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    #Erklaerung als Text
    #Reactive
 #   Erklaerung2_reactive = eventReactive(input$quiz2, {
 #       if (input$quiz2 == 'Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert') {
 #           HTML(paste0("<b>", "Richtige Antwort", "</b>"))
 #       }
 #       else{
 #           HTML(paste0("<b>", "Falsche Antwort", "</b>"))
 #       }
#    })
    #Text Output
#    output$Erklaerung2 <- renderText({
#        Erklaerung2_reactive()
#    })
    
    #Button um in naestes Tab zu springen
 #   Button2_reactive = eventReactive(input$quiz2, {
 #       if (input$quiz2 == "Eine große Änderung der Standardabweichung erzeugt einen großen p-Wert") {
 #           actionButton("Tab3", label = "Nächstes Tab")
 #       }
 #       else{
 #           paste0("")
 #       }
 #   })
    
    #Button id
 #   output$Button2 <- renderUI({
#        Button2_reactive()
#    })
    
    #in vorheriges Tab springen
    observeEvent(input$vorher2, {
        updateTabsetPanel(session, "tabselected",
                          selected = "1")
    })
    
    ################################### fuer Tab 3 Anzahl #######################################
    observeEvent(input$Tab3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
    
    output$p3 = renderText({
        #Gruppe2 durch Trafo + abschneiden erzeugen
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        p_Wert(Gruppe1, Gruppe2)
    })
    
    #Boxplot, der Werte
    output$boxPlot3 = renderPlot({
        #Gruppe2 durch Trafo + abschneiden erzeugen
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    #Idee: man zieht 100 Mal die Gruppe2 und schaut wie oft das ergebniss signifikant ist
    #Vektor mit b einträgen erzeugen
    #Vektor = rep(0, 100)
    #Vektor[i] = rnorm(input$n, input$diff, input$sd)
    
    output$sigPlot = renderPlot({
        Stichproben = replicate(100, rnorm(input$n, input$diff3, input$sd2))     #Ziehe 100 Stichproben
        t = apply(Stichproben,
                  2 ,
                  t.test,
                  y = Gruppe1,
                  alternative = "two.sided")    #Liste die Listen enthält, mache den t-Test fuer alle Strichproben bezueglich Gruppe1
        #https://stackoverflow.com/questions/20428742/select-first-element-of-nested-list fuer lapply Befehl
        p_Wert = lapply(t, '[[', 3)             #Vektor mit den p_Werten erzeugen
        signifikant = sum(p_Wert < 0.05)        #Anzahl der Signifikanten und nicht signifikanten p_Werte
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
    #Erklaerung als Text
    #Reactive
#    Erklaerung3_reactive = eventReactive(input$quiz3, {
#        if (input$quiz3 == "Ein p-Wert < 0.05 ist signifikant") {
#            HTML(paste0("<b>", "Richtige Antwort", "</b>"))
#        }
#        else{
#            HTML(paste0("<b>", "Falsche Antwort", "</b>"))
#        }
#    })
    #Text Output
#    output$Erklaerung3 <- renderText({
#        Erklaerung3_reactive()
#    })
    
    #Button um in naestes Tab zu springen
#    Button3_reactive = eventReactive(input$quiz3, {
#        if (input$quiz3 == "Ein p-Wert < 0.05 ist signifikant") {
#            actionButton("Tab4", label = "Nächstes Tab")
#        }
#        else{
#            paste0("")
#        }
#    })
    
    #Button id
 #   output$Button3 <- renderUI({
 #       Button3_reactive()
#    })
    #in vorheriges Tab springen
    observeEvent(input$vorher3, {
        updateTabsetPanel(session, "tabselected",
                          selected = "2")
    })
    
    ######################## Tab 4 ####################################################
    observeEvent(input$Tab4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "4")
    })
    #in vorheriges Tab springen
    observeEvent(input$vorher4, {
        updateTabsetPanel(session, "tabselected",
                          selected = "3")
    })
}


shinyApp(ui = ui, server = server)









