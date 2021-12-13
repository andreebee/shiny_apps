#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(R.utils)
library(shiny.i18n)

i18n <- Translator$new(translation_json_path = "./translation.json")

#i18n$set_translation_language("en")

# Define UI for application that draws two normal distributions using given mean and standard deviation
ui <- fluidPage(
    selectInput("language","please select language",c("en","de")),

    conditionalPanel(
      condition = "input.language == 'en'",
      conditionalPanel('false', i18n$set_translation_language("en")),
      titlePanel(i18n$t("Compare 2 normal distributions"))
    ),
    
    conditionalPanel(
      condition = "input.language == 'de'",
      conditionalPanel('false', i18n$set_translation_language("de")),
      titlePanel(i18n$t("Compare 2 normal distributions"))
    ),
    

    sidebarLayout(
        # For getting the mean and std of 2 variables
        # and specifying the alpha to shade the alpha and 1-beta in the graph
        sidebarPanel(
          conditionalPanel(
            condition = "input.language == 'de'",
            conditionalPanel('false', i18n$set_translation_language("de")),
            numericInput("mean1",i18n$t("Average of var1"),value=-2.5),
            numericInput("sd1","Standard Deviation of var1",value=3,min=0),
            numericInput("mean2","Average of var2",value=2),
            numericInput("sd2","Standard Deviation of var2",value=3.5,min=0),
            sliderInput("alpha","Alpha for Var1:",min = 0.01,max = 0.20,value = 0.05,step = 0.01)
          ),
          conditionalPanel(
            condition = "input.language == 'en'",
            conditionalPanel('false', i18n$set_translation_language("en")),
            numericInput("mean1",i18n$t("Average of var1"),value=-2.5),
            numericInput("sd1","Standard Deviation of var1",value=3,min=0),
            numericInput("mean2","Average of var2",value=2),
            numericInput("sd2","Standard Deviation of var2",value=3.5,min=0),
            sliderInput("alpha","Alpha for Var1:",min = 0.01,max = 0.20,value = 0.05,step = 0.01)
          )
        ),

        # Show plots of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw the normal curves
server <- function(input, output) {

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

# Run the application 
shinyApp(ui = ui, server = server)
