### Ziel:

library(shiny)
library(ggplot2)
?conditionalPanel
#Gruppen zu beginn ziehen, damit sie gleich bleiben und nur die veraenderungen der Parameter einen Einfluss haben und nicht der Zufall
Gruppe1 = rnorm(500)   
Gruppe2 = rnorm(1000) #mehr erzeugen, damit die Stichprobe auch bei der Variation der Anzhal gleich bleibt

ui <- shinyUI(pageWithSidebar(
    headerPanel("Zweiseitiger t-Test"),
        sidebarPanel(
            conditionalPanel(condition = "input.tabselected ==1", 
                             sliderInput(
                inputId = "diff",
                label = "Differnz",
                min = 0,
                max = 1,
                step = 0.1,
                value = 0.5)),
            
            conditionalPanel(condition="input.tabselected ==2",
                             # Add a slider
                             sliderInput(
                                 inputId = "diff2",
                                 label = "Differnz",
                                 min = 0,
                                 max = 1,
                                 step = 0.1,
                                 value = 0.5),
                             # Add a slider
                             sliderInput(
                                 inputId = "sd",
                                 label = "Standardabweichung",
                                 min = 0,
                                 max = 10,
                                 step = 0.1,
                                 value = 5)
                             ),
            conditionalPanel("input.tabselected ==3",
                             sliderInput(
                                 inputId = "diff3",
                                 label = "Differnz",
                                 min = 0,
                                 max = 1,
                                 step = 0.1,
                                 value = 0.5),
                             
                             # Add a slider
                             sliderInput(
                                 inputId = "sd2",
                                 label = "Standardabweichung",
                                 min = 0,
                                 max = 10,
                                 step = 0.1,
                                 value = 5),
                             
                             # Add a slider
                             sliderInput(
                                 inputId = "n",
                                 label = "Anzahl",
                                 min = 0,
                                 max = 1000,
                                 value = 500)
                             )),
        
        mainPanel(
            
            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(#type = "tabs",
                        tabPanel("Differenz", 
                                 value=1,
                                
                                 "Hier sieht man, welchen Effektes hat, wenn sich die 
    Differenz der Mittelwerte zweier normalverteilten 
    Stichproben ändert. ",
                                
                                 
                                 plotOutput("boxPlot1"), 
                                 HTML(paste0("<b>","p-Wert","</b>")),
                                 textOutput("p1"),
                                 
                                 "Erklärung: Der Effekt ist einmal in dem Boxplot zu erkennen,
    bei einem kleinem Effekt, sind diese nah ander und in dem p-Wert 
    des t-Tests. Der p-Wert sagt aus, ob der Unterschied signifikant ist oder nicht,
    aber er sagt nichts über die Stärke des Unterschieds aus. "),
                        
                        tabPanel("Differenz und Standardabweichung",
                                 value =2,
                                 
                                 "Hier sieht man, welchen Effekt es hat, wenn sich die 
    Standardabweichung ändert. Gruppe 1 bleibt fest. ",
                                 
                                 
                                 
                                 plotOutput("boxPlot2"),
                                 HTML(paste0("<b>","p-Wert","</b>")),
                                 textOutput("p2"),
                                 
                                 "Erklärung: "),
                        
                        tabPanel("Differenz, Standardabweichung und Anzahl",
                                 value =3,
                                 
                                 "Hier sieht man, welchen Effekt es hat, wenn sich die 
    Anzahl der Merkmalsträger ändert. Gruppe 1 bleibt fest. ",
                                 
                                 
                                
                                 
                                 plotOutput("boxPlot3"),
                                 HTML(paste0("<b>","p-Wert","</b>")),
                                 textOutput("p3"),
                                 plotOutput("sigPlot"),
                                 
                                 "Erklärung: "
                                 
                                
              ),    
              id = "tabselected"
            )
        )
    )
    )
 


server = function(input, output) {
    ################### Funktionen schreiben #########################################    
    #Boxplot mit Hilfe einer Funktion erzeugen
    #Eingabe: zwei Stichproben
    #Ausgabe: boxplot der Stichproben
    BoxPlot = function(Gruppe1, Gruppe2){
        
        #Data frame bauen, um boxplot nach Gruppen getrennt mit ggplot zu erzeugen
        Wert = c(Gruppe1, Gruppe2)
        Gruppe = c(rep("1", length(Gruppe1)), rep("2", length(Gruppe2)))
        daten = data.frame(Gruppe, Wert)
        
        #Boxplot mit zwei Var erstellen
        ggplot(daten, aes(x = Gruppe , y =Wert , fill = factor(Gruppe)))+   #benoetigt DataFrame
            geom_boxplot()+
            labs(title = "Auswirkung der Änderung")+
            ylim(-5, 5) +
            geom_jitter(width = 0.1, alpha = 0.2)
    }
    
    #p-Wert berechnung als Funktion
    #Eingabe: Stichproben von denen der p-Wert berechnet werden soll
    #Ausgabe: kurzer Text: "p-Wert des zweiseitigen t-Tests: " und der p-Wert
    p_Wert = function(Gruppe1, Gruppe2){
        p = t.test(Gruppe1, Gruppe2, alternative = "two.sided" )$p.value   #2 Seitiger t-Test
        p = round(p, digits=10) #runden
        if(p< 0.001){
            p= "<0.001"
        }
        else{
            p=p
        }
        paste("p-Wert des zweiseitigen t-Tests: ", p)
    }
    
    #########################Output fuer einzelne Tabs definieren #####################   
    ########################## fuer ersten Tab ( MW Differenz)
    output$p1 = renderText({
        #Gruppe 2 durch anddieren der Differenz der Mittelwerte erzeugen, abschneiden, damit Gruppe1 und Gruppe2 gleiche Anzahl an Werten besitzen
        Gruppe2 = Gruppe2[1:500] + input$diff
        p_Wert(Gruppe1,Gruppe2)
    })
    
    #Boxplot, der Werte, nur MW Diff geht ein
    output$boxPlot1 = renderPlot({
        Gruppe2 = Gruppe2[1:500] + input$diff
        BoxPlot(Gruppe1, Gruppe2)
        
    })
    
    ######################  fuer Tab 2 SD
    
    output$p2 = renderText({
        #nutze Trafo, z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        p_Wert(Gruppe1,Gruppe2)
    })
    
    #Boxplot, der Werte
    output$boxPlot2 = renderPlot({
        #nutze Trafo, z=x-mu/sigam -> x= z*sigma +mu
        Gruppe2 = Gruppe2[1:500] * input$sd + input$diff2
        BoxPlot(Gruppe1, Gruppe2)
    })
    
    ################################### fuer Tab 3 Anzahl
    
    output$p3 = renderText({
        #Gruppe2 durch Trafo + abschneiden erzeugen
        Gruppe2 = Gruppe2[1:input$n] * input$sd2 + input$diff3
        p_Wert(Gruppe1,Gruppe2)
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
    # Vektor[i] = rnorm(input$n, input$diff, input$sd)
    
    output$sigPlot = renderPlot({
        Stichproben = replicate( 100, rnorm(input$n, input$diff3, input$sd2))     #Ziehe 100 Stichproben
        t = apply(Stichproben, 2 , t.test, y=Gruppe1, alternative="two.sided")  #Liste die Listen enthält, mache den t-Test fuer alle Strichproben bezueglich Gruppe1
        p_Wert = lapply(t, '[[', 3)        #Vektor mit den p_Werten erzeugen
        signifikant = sum(p_Wert<0.05)        #Anzahl der Signifikanten und nicht signifikanten p_Werte
        nicht_signifikant = sum(p_Wert>=0.05)
        
        barplot(c(signifikant, nicht_signifikant),ylim=c(0, 100) ,main="Anzahl der signifikanten und nicht signifikanten Abweichungen",
                xlab= ("signifikant/nicht signifikant"),ylab="Anzahl", col= c(3, 7))
        legend(1, 95, legend=c("signifikanter p-Wert", "kein signifikanter p-Wert"),
               fill=c(3, 7), cex=0.8)
        
    })
}


shinyApp(ui = ui, server = server)











