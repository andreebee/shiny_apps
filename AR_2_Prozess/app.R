library(shiny)
library(ggplot2)
library(Matrix) #to use bandSparse to create band matrix
library(MASS)   #to use mvrnorm to create multivar Gaussian vector
#library(graphics)

ui <- fluidPage(
    
    # App title ----
    titlePanel("AR(2)-Prozesse: Parameter, Stationaritaet und Visualisierung"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Slider for the number of bins ----
            sliderInput(inputId = "phi_1",
                        label = "\u03d51",
                        min = -2,
                        max = 2,
                        step = 0.05,
                        value = 1.3),
            sliderInput(inputId = "phi_2",
                        label = "\u03d52",
                        min = -2,
                        max = 2,
                        step = 0.05,
                        value = -0.4),
            htmlOutput(outputId = "textOutput")
            
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            # Output: Histogram ----
            
            plotOutput(outputId = "plotOutput2",height="70%",width = "70%"),
            plotOutput(outputId = "plotOutput")
            
            
        )
    )
)

server <- function(input, output) {
    output$textOutput <- renderUI({
        
        #Definiere Characteristische Funktion
        z=c(1,-input$phi_1,-input$phi_2)
        #Nullstellen
        a <- polyroot(z)
        
        #Fallunterscheidung da unterschiedliche Gleichungssysteme geloest werden.
        
        if(all(round(Im(a),1))==0 && input$phi_2 != 0){
            #falls z1 = z2 aber reel Fall b
            if(Re(a[1]) == Re(a[2])){
                x=1 #Schalter text
                #Loese GLS rho(1)=1/z_1*(1+C_2) nach C auf
                K <- c(1/a[1]) 
                b <- c(input$phi_1/(1-input$phi_2)-(1/Re(a[1])))
                C <- solve(K, b) 
                
            }
            
            #falls z1 != z2 aber reel Fall a
            if(Re(a[1]) != Re(a[2]) && input$phi_2 != 0){
                x=2 #Schalter
                #Loese GLS rho(1)=1/z_1*(1+C_1)+1/z_2*(1+C_2) nach C_1,C_2 auf
                #         rho(0)=C_1+C_2
                #A*C=b 
                
                K <- rbind(c(1,1), c(1/Re(a[1]), 1/Re(a[2]))) #Matrix A
                b <- c(1, input$phi_1/(1-input$phi_2))        #b
                C <- solve(K, b)
                
                
            }
        }
        
        #falls Loesung komplex Fall c
        if(a[1]!=a[2] && all(round(Im(a),1)) != 0 && input$phi_2 != 0){
            x=3 #Schalter text
            
            a1 = a[1]
            r=Mod(a1) #r=1/|z_1|
            theta=Arg(a1) # theta
            #Loese GLS rho(1)=1/|z_1|*(cos(theta)+C_2*sin(theta))
            
            K <- sin(theta)/r #Matrix A
            b <- input$phi_1/(1-input$phi_2)-cos(theta)/r #b
            C <- solve(K,b)
            
            ptheta=(2*pi)/theta #periode
            
        }
        if (input$phi_2 == 0){
            x=4 # Schalter
            #Wenn Phi_2=0, dann ist es ein AR(1) Prozess -> Fehlermeldung
        }
        #verschiedene text outputs je nach Fall.
        text1=""
        if(x==1){text1=c("Die Charakteristische Funktion","hat reelle Loesungen","z1=z2=",round(Re(a[1]),3))} #,"und ","C2=",round(C,3)
        if(x==2){
            text1=c("Die Charakteristische Funktion hat reelle Loesungen","z1=",round(Re(a[1]),3),";","z2=",round(Re(a[2]),3))} #,"und","C1=",round(C[1],3),"C2=",round(C[2],3)
        if(x==3){
            text1=c("Die Charakteristische Funktion hat komplexe Loesungen","z1=",round(a[1],3),";","z2=",round(a[2],3))} #,"und","C2=",round(C,3)
        if(x==4){
            text1="Wenn Phi_2=0 ist es ein AR(1), kein AR(2)-Prozess. Bitte anderes Phi_2 waehlen."}
        
        ##Warnung wegen Zulaessigkeit
        text2=""
        text3=""
        text4=""
        if(input$phi_1+input$phi_2 >= 1){
            text2="Warnung: phi_1+phi_2 sind nicht < 1"
        }
        if(input$phi_2-input$phi_1 >= 1){
            text3="Warnung: phi_2-phi_1 sind nicht < 1"
        }
        if(Mod(input$phi_2) >= 1){
            text4="Warnung: |phi_2| ist nicht < 1"
        }
        str1 <- paste(text1,collapse = ' ')
        str2 <- paste(text2,collapse = ' ')
        str3 <- paste(text3,collapse = ' ')
        str4 <- paste(text4,collapse = ' ')
        HTML(paste(str1,str2,str3,str4,sep = '<br/>'))
        
        
        
        
        
        
        
    })
    output$plotOutput2 <- renderPlot({
        #Erzeuge einen Ar2 Prozess Manuell.
        par(mfcol=c(1,2))
        
        plot(input$phi_1,input$phi_2,xlim=c(-2,2),ylim = c(-2,2),col=2,type="p",pch=4,xlab= expression(paste(phi,1)),ylab= expression(paste(phi,2)))
        title(main = ("Parameter mit Stationaritaetsdreieck"),  line = 0.8, cex.main = 0.8)
        q <- seq(from=-2,to=0,by=0.02)
        w <- seq(from=0,to=2,by=0.02)
        e <- seq(from=-2,to=2,by=0.02)
        
        q_t <- q+1
        w_t <- -w+1
        e_t <- -0.25*e^2
        
        lines(q,q_t)
        lines(w,w_t)
        lines(e,e_t)
        lines(c(-2,2),c(-1,-1))
        text(0,0.4,"real")
        text(0,-0.4,"complex")
        
        u <- complex(real=0,imaginary = 0)
        plot(u,type = "n",xlim=c(-2,2),ylim = c(-2,2),xlab="Re(z)",ylab = "Im(z)")
        title(main = ("Loesungen mit Einheitskreis"),  line = 0.8, cex.main = 0.8)
        library(berryFunctions)
        circle(0,0, r=1)
        abline(h=0)
        abline(v=0)
        z=c(1,-input$phi_1,-input$phi_2)
        a <- polyroot(z)
        points(a,col=2)
        
        
        
        
    },height = 250, width = 500)
    
    output$plotOutput <- renderPlot({
        #Erzeuge einen Ar2 Prozess Manuell.
        ar2=rep(0,200)
        sigma_e=1
        #X_t=phi_1*X_{t-1}+phi_2*X_{t-2}+epsilon
        #Start erst bei 3, damit vorrangegangene Werte existieren.
        for (i in 3:200) {
            ar2[i]=ar2[i-1]*input$phi_1+ar2[i-2]*input$phi_2+rnorm(1,0,sigma_e)
            
        }
        ar2_ts <- ts(ar2[3:200])
        if(max(ar2_ts) <= 10 && min(ar2_ts) >= -10){plot(ar2_ts, ylim=c(-10, 10))}
        else{plot(ar2_ts)}
        title(main = ("Simulation des Prozesses"),  line = 0.8, cex.main = 0.8)
        
        
        
    },height = 250,width = 500)
    
    
    
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
