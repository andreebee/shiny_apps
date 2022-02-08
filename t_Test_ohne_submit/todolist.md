
# To do:

1.	Does the boxplot show the median (as usual)? Since we are comparing the means, it would be good to show them as well. 
- Remove boxplot or move to background? Draw mean line.
- The mean line should be spanning the whole points cloud and the box plot with thin line.
 
2a. It is not clear what happens when you change the difference. Do you only shift the existing sample? It looks like it, but sometimes the data shifts up, but the box seems to move down. 

- Test it to avoid this.
- Try test packages for shiny apps.
 
2b. I assume the difference is the difference of the theoretical normal distributions?  

- Yes, reformulate: Differenz der Erwartungswerte zweier Populationen + Effekt der.
 
3. The y-range in the plot is constant, but you can easily shift the data out of range (same with increasing standard deviation), which is visually irritating because you cannot see all the data.

- change ymax to -10; 10 or so, such that for non-significant sd, most points still visible.
- Find the best combination (Andre).

4. Some of the explanations of the answers are a little confusing, since they do not all refer to the problem in the current tab.

- Reformulate explanations, make it shorter, focus on what we see on tab (Andre).
 
5. the p-value peaks at standard deviation of around 5, similar for the size of the sample, but it should grow monotonically with standard deviation and sample size apart from random sampling effects. Or are we missing something?

- set defaults: m=1, [0; 2] sd=7 [0.1; 15?] n=200 [50; 500?] larger range for Wert?
- done.

6. We do not understand the bar chart about the probabilities of significant p-values

- Anzahl -> Anteil, remove yellow chart, title: Anteil signifikanter P-Werte für 1000 Simulationen, maybe transpose figure so scale is horizontally, maybe move to next tab? Explain simulation idea
- Removing p value on y and change the order in the legend 
- Moving it to a new tab and adding a check box to add to the bar chart the p values > Checkbox: Einzelne P-Werte anzeigen


7.	The answers in the third tab are not mutually exclusive (Andre).

8.	Shortcut to move to the 3rd tab for developing purposes 

# Short term To do:

-	sketch tab zero (Andre).
-	think of having one tail test instead if 2-sided (Andre).
-	Add tab 0 about not difference.
-	explain that we talk about diff of population (Andre).
 
# Long term To do:

-	create a score for correct answers, give back at last tab
-	integrate with moodle, so we can see the results for each student
-	add star rating for the app
