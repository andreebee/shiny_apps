library(shiny)
library(tidyverse)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./translation.json")

# Define server logic required to draw the normal curves
server <- function(input, output) {
  
    t <- reactive({
        if (input$language=='en'){
        i18n$set_translation_language("en")
      } else{
        i18n$set_translation_language("de")
      }
    })
    
    output$title <- renderText({
      t()
      i18n$t("Plot")
    })
    
    output$multi <- renderUI({
      t()
      tagList(
        numericInput("mean1",i18n$t("Average of var1"),value=-2.5),
        numericInput("sd1",i18n$t("Standard Deviation of var1"),value=3,min=0),
        numericInput("mean2",i18n$t("Average of var2"),value=2),
        numericInput("sd2",i18n$t("Standard Deviation of var2"),value=3.5,min=0)
      )
    })
    
    output$distPlot <- renderPlot({
      
        # Assigning input to the variable to create the data frame which will be use to create graphs
        mean1 <- input$mean1
        sd1 <- input$sd1
        mean2 <- input$mean2
        sd2 <- input$sd2
        alph <- input$alpha
        
        # Creating the columns that are needed for the data frame which will be use to create graphs
        alpha <- qnorm(1-alph)
        x <- seq(min(mean1-3*sd1,mean2-3*sd2),max(mean1+3*sd1,mean2+3*sd2),length.out=1000)
        z <- rep(seq(min(mean1-3*sd1,mean2-3*sd2),max(mean1+3*sd1,mean2+3*sd2),length.out=1000),2)
        y1 <- dnorm(x, mean1, sd1)
        y2 <- dnorm(x, mean2, sd2)
        
        # Creating the the data frame which will be use to create graphs
        df <- data.frame(
            
            # Adding 1000 number of values of x within 3s interval for each curve 
            x=seq(min(mean1-3*sd1,mean2-3*sd2),max(mean1+3*sd1,mean2+3*sd2),length.out=1000),
            
            # Adding values of y to draw the curves using probability density function
            y=c(y1,y2),
            
            # Specifying related variable
            group=c(rep("var1",1000),rep("var2",1000))
        )
        
        # Adding columns for specifying the range of the alpha and 1-beta to shade in the graph
        df <- mutate(
            df,
            y1_max = ifelse(group=="var1"&(x-mean1)/sd1>alpha,y,0),
            y1_min = 0,
            y2_max = ifelse(x>(alpha*sd1+mean1),y,0),
            y2_min = 0
        )
        
        # draw 2 normal curves using the data frame
        ggplot(df,aes(x=x, y=y, group=group,fill=group,alpha=0.7)) +
            geom_area(position = "identity")+
            geom_line(aes(colour=group))+
            xlab("var1 & var2") + ylab("")+
            scale_alpha(guide = 'none')+
            
            # Adding vertical line for alpha
            geom_vline(xintercept=c(alpha*sd1+mean1))+
            
            # shading the alpha area
            geom_ribbon(aes(ymin = y2_min, ymax = y2_max), fill = "black")+
            
            # Shading the 1-beta area
            geom_ribbon(aes(ymin = y1_min, ymax = y1_max), fill = "green")
    })
}