# shiny_apps



Verbinden

### 1) RStudio mit Git

- In RStudio folgndes auswählen: new Project -> Version Control -> URL usw. eingeben
  	(Erstellt man eine neue Shiny App in diesem Project, wird diese automatisch in einem extra Ordner in dem Projekt auf dem PC abgespeichert)
	- Falls eine Fehlermeldung in RStudio auftritt wenn man den folgenden Schritt ausführen möchte, muss man [git lokal auf dem PC downloaden](https://git-scm.com/downloads) der Seite 

- Zum nachlesen der folgenden Schritte: https://happygitwithr.com/rstudio-git-github.html  

- Um auf Github hochzuladen: in RStudio oben auf Git und dann auf Push gehen

- Um Änderungen auf Git zu übertragen muss man folgende Schritte tun in RStudio (bei jeder Änderung): 
  	Speichern -> Git drücken/auswählen -> Commit drücken/auswählen -> Haken setzten -> Commit message einfügen -> push drücken/auswählen 


### 2) Git mit RStudio Connect
 
- Beim ersten Mal, in Rstudio lokal auf dem PC mit folgendem Befehl das Package "rsconnect" installieren
	```console
	install.packages("rsconnect") 
	```

- Zum nachlesen der folgenden Schritte: https://docs.rstudio.com/connect/user/git-backed/ 

- Als nächstes muss eine Mannifest Datei lokal erstellt werden, dies muss nur einmal getan werden:
   -Folgenden Befehl lokal in RStudio ausführen, Ordner_name muss gesetzt werden
   	```console
	rsconnect::writeManifest(appDir = "Ordnername")
	```
   -In RStudio Commiten

- Um die Shiny App in RStudio Connect hochzuladen muss in RStudio Connect folgendes getan werden, dies muss nur einmal getan werden:
	 Auf der Content Seite auf Publish drücken und da import von Git wählen -> URL einfügen und das was da angezeigt wird tun

- In RStudio Connect, kann man in der Shiny App manuell überprüfen, ob es neue Updates gibt:
	Auf der rechten Seite unter Info ganz unten, muss man "Update now" auswählen, aber es wird automatisch periodisch (alle 15min) nach Updates geschaut


### 3) To do zur Nutzung von private Repository
-  Wenn Git Repository private ist muss das noch autorisiert werden
	-> https://docs.rstudio.com/connect/admin/content-management/git-backed/
   		diesen Schritt verstehe ich nicht
		Irgendwie müssen von einem Admin, auf /etc/rstudio-connect/rstudio-connect.gcfg folgende Sachen gesetzt werden:

	```console
	[GitCredential]
	Host = github.com
	Username = accountName
	Password = <encrypted-string>
	Protocol = https
	```
		

#### Hinweis:
- Sind alle Apps in einem Ordner, kommt bei RStudio Connect ein Fehler, wenn man diese öffnen möchte

- Man muss die Apps wenn man sie bearbeiten möchte und dann die Änderung in git haben möchte in dem Projekt öffnen

- Kommt folgende Fehlermeldung:
	
	- Fehler in `if ((grepl("rmd", appMode, fixed = TRUE) || appMode == "static") &&  : 
  		Fehlender Wert, wo TRUE/FALSE nötig ist` Lösung: Dann ist der "Ordnername" in dem Befehl 
		rsconnect::writeManifest(appDir = "Ordnername") vermutlich falsch geschrieben


	- Fehler in `inferAppPrimaryDoc(appPrimaryDoc = appPrimaryDoc, appFiles = appFiles,  : 
  		Application mode static requires at least one document.`
 	Lösung: Dann ist die Shiny App nicht mit dem Namen App benannt, also den Namen der App in App ändern oder mit rsconnect::writeManifest(appDir = "test2",appPrimaryDoc = "test1.R") kann man eine Manifestdatei für eine bestimmte Datei erstellen

:warning: **Achtung:** 
Keine Umlaute in der App oder setze zu beginn ` options(encoding = "UTF-8") ` ( siehe z.B. wuerfeln)

