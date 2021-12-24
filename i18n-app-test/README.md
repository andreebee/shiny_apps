# Create a shiny app in different languages 
This app is a sample to create an app in different languages
- Create the app with separate ui and server file, otherwise, rconnect returns error
- Use translations.json as a sample to translate the text in the app
- Set the json file to i18n by adding `i18n <-languageServer('langSelect', "./translations.json")` to the server
- If you are adding a new language, update `../global.R` file by adding the new language to the `langList`
- TO add translation in the ui, use `uiOutput` and translate the text in the server by using `i18n()$t( "related message ID" )`
- TO add translation in the server use `i18n()$t( "related message ID" )`
For more information check the `ui.r`, `server.r` and `translations.json` file of this sample
