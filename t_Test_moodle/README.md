# Embedding shiny app in moodle 
Considering that the moodle adds **Quiz navigation** on the right side of the exam, the width it dedicates to the shiny app is about **70%** of the width of the page; therefore, instead of using the **pageWithSidebar** layout, to keep the **siderpanel** and the **tabpanel** in one row next to each other, we need to use the **splitLayout**.
Example:
`splitLayout(cellArgs = list(style = "padding: 20px"),cellWidths = c("35%", "65%"), uiOutput("sliders"), plotOutput("boxPlot"))`
