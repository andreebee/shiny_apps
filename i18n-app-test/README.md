# Create a shiny app in different languages 
This app is a sample to create an app in different languages
- Create the app with separate ui and server file, otherwise, rconnect returns error
- Use translations.json as a template to translate the text in the app
- Set the json file to i18n by adding `i18n <-languageServer('langSelect', "./translations.json")` outside the server
- In UI, add a selectInput to give users the option to choose language
- In server, create a reactive variable `t` to switch between language according to the language selectinput
- To add translation in the ui, use `uiOutput` and translate the text in the server by calling the reactive variable `t()` and using `i18n$t( "text" )`
- To add translation in the server call use `t()` and use `i18n$t( "text" )`
For more information check the `ui.r`, `server.r` and `translations.json` file of this sample