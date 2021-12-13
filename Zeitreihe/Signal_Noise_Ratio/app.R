#Aim of this app: Students understand what it means when a signal is overlaid by a WN
#For this purpose, the signal function can be changed by hand and the variance and the EW of the WN can be varied

#https://github.com/Appsilon/shiny.i18n/blob/master/examples/basic/app_json.R
#Maybe solve with conditional panels



library(shiny)
library(ggplot2)
library(Matrix) #to use bandSparse to create band matrix
library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)
library(R.utils) #for bilingual
#source("C:/Users/lisaa/OneDrive/Desktop/GitHub/shiny_apps/global.R")  #for bilingual
source("C:/Users/lisaa/OneDrive/Desktop/GitHub/shiny_apps//binarySelector.R")  #for bilingual


# File with translations
#i18n <- Translator$new(translation_json_path ="C:/Users/lisaa/OneDrive/Desktop/GitHub/shiny_apps/Zeitreihe/Signal_Noise_Ratio/Übersetzung.json")
#i18n$set_translation_language("en") # here you select the default translation to display




ui <- fluidPage(
    languageSelector("langSelect"),
  #  i18n = languageServer('langSelect',"C:/Users/lisaa/OneDrive/Desktop/GitHub/shiny_apps/Zeitreihe/Signal_Noise_Ratio/Übersetzung.json")
#,
#i18n <-languageBinaryServer('langSelect'),
# shiny.i18n::usei18n(i18n),
#  div(style = "float: right;",
#      selectInput('langSelect',
#                  i18n$t("Change language"),
#                  choices = i18n$get_languages(),
#                  selected = i18n$get_key_translation()
#                  )
#  ),

    
    # App title ----

    titlePanel("Test"
               ),
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            conditionalPanel(
                condition = "input.langSelect==German",
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "variance",
                        label = "Variance WhiteNoise" ,
                        min = 0,
                        max = 3,
                        step = 0.1,
                        value = 1),
            #verbatimTextOutput("value"),
            sliderInput(inputId = "mean",
                        label = "Expected value WhiteNoise",
                        min = 0,
                        max = 3,
                        step = 0.1,
                        value = 0),
            textInput(inputId = "formula",
                      label = "Signal function",
                      value = "2*cos(2*pi*x/(50+0.6*pi))",
                      width = NULL,
                      placeholder = NULL
                      
            ),
            ) 
        ),
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            plotOutput(outputId = "distPlot"),
            textOutput(outputId = "snratio")
            
        )
    )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
   # i18n = languageServer('langSelect', "C:/Users/lisaa/OneDrive/Desktop/GitHub/shiny_apps/Zeitreihe/Signal_Noise_Ratio/Übersetzung.json")
    #i18n <-languageBinaryServer('langSelect')
    x    = seq(from=1, to=100)
    
    
    
    #updateNumericInput(session, "variance", value = x)
    output$distPlot <- renderPlot({
        #create var-cov matrix
        #create multivariate Gaussian Vector
        w = rnorm(n = 100, mean = input$mean, sd = input$variance)
        s = eval(parse(text=input$formula))
        ws = w + s
        snratio = (var(s) - (mean(s)^2)) / (input$variance - (input$mean^2))
        ts.plot(as.ts(ws), gpars=list(ylim=c(-10, 10), main="Trajektorie", ylab="")
        )
        abline(h=0, lty=2)
    })
    output$snratio <- renderText({
        w = rnorm(n = 100, mean = input$mean, sd = input$variance)
        s = eval(parse(text=input$formula))
        ws = w + s
        snratio = round((var(s)) / (input$variance), 2)
        
       paste(
           #p(i18n()(c("The Signal-to-noise ratio is", "Die Signal-to-noise ratio ist"))),
                snratio,
           p(i18n()$t("Title3"))
           )
        
    })
    
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
