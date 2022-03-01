
# To do:

1.  Does the boxplot show the median (as usual)? Since we are comparing the means, it would be good to show them as well.  
- Remove boxplot or move to background? Draw mean line.  
- The mean line should be spanning the whole points cloud and the box plot with thin line.  
Behzad Feb 15, 2022: Done.  
Andre Feb 18, 2022: Looks good. Please check start and endpoint again, seems to be moved in my case: Horizontal lines should be symmetric wrt. vertical lines within groups.  
Behzad Feb 19, 2022: Done.  
Andre Feb 21, 2022:  Add "Erwartungswert Gruppe 1" on the left and right side of the lines  
**Behzad Feb 22, 2022:** Done.  

2a. It is not clear what happens when you change the difference. Do you only shift the existing sample? It looks like it, but sometimes the data shifts up, but the box seems to move down.  
- Test it to avoid this.  
- Try test packages for shiny apps.  
Behzad Feb 15, 2022: For each combination of: difference, standard deviation and sample size, I calculated the p-value, and save them in a dataset. unfortunately even for the same sample size and difference it is possible that increasing the sd leads to a lower p value!  
Andre Feb 18, 2022:  can we make steps in sd larger (e.g. by 1) to avoid  this or make it less likely?  
Behzad Feb 19, 2022: Done.  
Andre Feb 21, 2022:  will talk to Martin  
Behzad Feb 22, 2022: max: 9 per group!  
**Andre March 1, 2022:**  Add actual mean and sd and visualization to investigate the reason and find relevant combinations.  

2b. I assume the difference is the difference of the theoretical normal distributions?  
- Yes, reformulate: Differenz der Erwartungswerte zweier Populationen + Effekt der.  
Behzad Feb 15, 2022: Not done. I think by changing this for the first tab we need few changes in the other tabs.  
**Andre Feb 18, 2022:**  Done. I have changed a couple of formulations.  
 
3.  The y-range in the plot is constant, but you can easily shift the data out of range (same with increasing standard deviation), which is visually irritating because you cannot see all the data.  
- change ymax to -10; 10 or so, such that for non-significant sd, most points still visible.  
- Find the best combination for small and large sample size (Andre).  
**Andre Feb 21, 2022:**  Done. 

4.  Some of the explanations of the answers are a little confusing, since they do not all refer to the problem in the current tab.   
- Reformulate explanations, make it shorter, focus on what we see on tab (Andre).  
Andre Feb 18, 2022: Done. I simplified the formulations of the choices and explanations. Please double-check that it is all correct. Further, I moved the "next tab" "previous tab" buttons below the text. Can you please find a way to avoid that "Falsche Antwort" shows up right in the beginning when no choice is made yet?  
**Behzad Feb 19, 2022:** Done.  

5.  The p-value peaks at standard deviation of around 5, similar for the size of the sample, but it should grow monotonically with standard deviation and sample size apart from random sampling effects. Or are we missing something?  
- set defaults: m=1, [0; 2] sd=7 [0.1; 15?] n=200 [50; 500?] larger range for Wert?  
- done.  
**Behzad Feb 21, 2022:**  see 2a.  

6.  We do not understand the bar chart about the probabilities of significant p-values  
- Anzahl -> Anteil, remove yellow chart, title: Anteil signifikanter P-Werte für 1000 Simulationen, maybe transpose figure so scale is horizontally, maybe move to next tab? Explain simulation idea  
- Removing p value on y and change the order in the legend  
- Moving it to a new tab and adding a check box to add to the bar chart the p values > Checkbox: Einzelne P-Werte anzeigen  
Behzad Feb 15, 2022: I moved it to the 4th tab and added the check box. we probably need to change the color, add explanation and so on.  
Andre Feb 18, 2022: I cannot see the checkbox and I cannot access the 4th tab.  
Behzad Feb 19, 2022: Done, It was because of changing the right answers only in the UI.  
**Andre March 1, 2022:** will add explanation for the 4th tab.  

7.  The answers in the third tab are not mutually exclusive (Andre).  
**Andre Feb 18, 2022:**  see 4.  

8.  Shortcut to move to the 3rd tab for developing purposes  
**Behzad Feb 15, 2022:** Done.  

9. Update documentation regarding not having same wording for the right answer of different questions  
**Behzad Feb 22, 2022:** Done.  

10. Short term To do:  
-	sketch tab zero (Andre).  
-	think of having one tail test instead if 2-sided (Andre).  
-	Add tab 0 about not difference.  
-	explain that we talk about diff of population (Andre).  
**Andre March 1, 2022:** will find an example to give users the chance to have better understanding  
 
11. Long term To do:  
-	create a score for correct answers, give back at last tab  
Behzad Feb 21, 2022:**  Done.  
**Andre March 1, 2022:** Change the scoring calculation: for each question user gain 1 only if they answer correctly at their first attempt. And add a readme file  

-	integrate with moodle, so we can see the results for each student  
**Andre Feb 21, 2022:**  Only questions and the third tab.  

-	add star rating for the app  
Andre Feb 21, 2022:  change the slider, start from 1 and only integer, only one submission should be possible and save the submissions on dropbox  
**Behzad March 1, 2022:** it needs improvement!  