
*import data from file;
proc import datafile="finalsuicide.csv" out=myd replace;
delimiter=',';
getnames=yes;
run;

Proc print data = myd (obs= 20);
run;

*Histogram of suicidesper100kpop to analyze the its distribution;
proc univariate normal;
var suicidesper100kpop;
histogram / normal (mu = est sigma = est);
run;

*Create dummy variables for different features;
data suicide;
set myd;

dsex = 1;
if sex = 'female' then dsex = 0;

dgeneration1 = 0;
if generation = 'Boomers' then dgeneration1 = 1;
dgeneration2 = 0;
if generation = 'Generation X' then dgeneration2 = 1;
dgeneration3 = 0;
if generation = 'Millenials' then dgeneration3 = 1;
dgeneration4 = 0;
if generation = 'Generation Z' then dgeneration4 = 1;

dage1 = 0;
if age = '15-24 years' then dage1 = 1;
dage2 = 0;
if age = '25-34 years' then dage2 = 1;
dage3 = 0;
if age = '35-54 years' then dage3 = 1;
dage4 = 0;
if age = '55-74 years' then dage4 = 1;
dage5 = 0;
if age = '75+ years' then dage5 = 1;

dyear1 = 0;
if year = 2007 then dyear1 = 1;
dyear2 = 0;
if year = 2008 then dyear2 = 1;
dyear3 = 0;
if year = 2009 then dyear3 = 1;
dyear4 = 0;
if year = 2010 then dyear4 = 1;

dcontinent1 = 0;
if continent = 'Africa' then dcontinent1 = 1;
dcontinent2 = 0;
if continent = 'Asia' then dcontinent2 = 1;
dcontinent3 = 0;
if continent = 'Oceania' then dcontinent3 = 1;

run;

Proc print data = suicide (obs= 20);
run;

*correlations;
proc corr;
var suicidesper100kpop population gdp_for_year_dollars gdp_per_capita_dollars;
run;

proc sgscatter;
matrix suicidesper100kpop population gdp_for_year_dollars gdp_per_capita_dollars;
run;

proc gplot;
plot suicidesper100kpop*(population gdp_for_year_dollars gdp_per_capita_dollars);
run;

*fit a regression model before the transformation;
proc reg;
model suicidesper100kpop= population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3 /stb vif tol;
run;


*Transform Y-variable;
data suicide;
set suicide;
lnsuicidesper100kpop = log(suicidesper100kpop);
run;
proc print data = suicide (obs=20);
run;
proc univariate normal;
var lnsuicidesper100kpop;
histogram / normal (mu = est sigma = est);
run;

*correlations after the transformation;
*Scatterplot for each x-variable;
proc sgscatter;
matrix lnsuicidesper100kpop population gdp_for_year_dollars gdp_per_capita_dollars;
run;

proc corr;
var lnsuicidesper100kpop population gdp_for_year_dollars gdp_per_capita_dollars;
run;

proc gplot;
plot lnsuicidesper100kpop*(population gdp_for_year_dollars gdp_per_capita_dollars);
run;

*Boxplots to evaluate if lnsuicideper100kpop vary by (age, generation, continent, year, and sex)
*Boxplot - by age;
proc sort;
by age;
RUN;
PROC BOXPLOT;
PLOT lnsuicidesper100kpop*age;
RUN;

*Boxplot - by generation;
proc sort;
by generation;
RUN;
PROC BOXPLOT;
PLOT lnsuicidesper100kpop*generation;
RUN;

*Boxplot - by continent;
proc sort;
by continent;
RUN;
PROC BOXPLOT;
PLOT lnsuicidesper100kpop*continent;
RUN;

*Boxplot - by year;
proc sort;
by year;
RUN;
PROC BOXPLOT;
PLOT lnsuicidesper100kpop*year;
RUN;

*Boxplot - by sex;
proc sort;
by sex;
RUN;
PROC BOXPLOT;
PLOT lnsuicidesper100kpop*sex;
RUN;

*fit a regression model after Y-transformation using lnsuicideper100kpop;
proc reg;
model lnsuicidesper100kpop= population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3 /stb vif tol;
run;

*Model assumptions;
* Residual plot: residuals vs x-variables;
plot student.*(population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;


*run model with outliers;
proc reg data = suicide;
model lnsuicidesper100kpop= population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3/influencec r;
plot student.*(population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3 predicted.);
plot npp.*student.;
run;

*deleting observations with outliers and/or influential points;
data new_suicide;
set suicide;
if _n_ in (84 218 667 1051 1132 1384 1562 1631 1812 2020 2153 2179) then delete;
run;

*rerunning the model without outliers using the new dataset and to check if there is still any;
proc reg data = new_suicide;
model lnsuicidesper100kpop= population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3/influencec r;
plot student.*(population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3 predicted.);
plot npp.*student.;
run;


***********************************************************************************
*Create selected column to split the data set to 70% training and 30% testing sets;
proc surveyselect data=new_suicide out=all_suicide seed=12345 samprate=0.7 outall;
run;
proc print data=all_suicide (obs=20);
run;

*create new variable new_y = lnsuicidesper100kpop for training set, and = NA for testing set;
data all_suicide;
set all_suicide;
if selected then new_y=lnsuicidesper100kpop;
run;
proc print data=all_suicide;
run;


*Model selection;

PROC REG data=all_suicide;
*CP selection method;
MODEL new_y=population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3/SELECTION = cp;
run;

PROC REG data=all_suicide;
*Stepwise selection method;
MODEL new_y=population gdp_for_year_dollars gdp_per_capita_dollars dsex 
dgeneration1 dgeneration2 dgeneration3 dgeneration4 dage1 dage2 dage3 dage4 dage5 dyear1 dyear2
dyear3 dyear4 dcontinent1 dcontinent2 dcontinent3/SELECTION = stepwise;
run;


*Fit a Regression model M3 based on the selection results;

proc reg data=all_suicide;
model new_y=population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2 /stb vif tol;
run;

*Model assumptions;
* Residual plot: residuals vs x-variables;
plot student.*(population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

*Check for Multicollinearity;
*Scatterplot for each x-variable;
proc sgscatter;
matrix new_y population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2;
run;

proc corr;
var new_y population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2;
run;

proc gplot;
plot new_y*(population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2);
run;



*run model M3 with outliers;
proc reg data = all_suicide;
model new_y= population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2/influencec r;
plot student.*(population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2 predicted.);
plot npp.*student.;
run;

*deleting 12 observations with influential points and an outlier;
data new_allsuicide;
set all_suicide;
if _n_ in (7 74 81 87 174 217 231 955 1127 1207 1314 2274) then delete;
run;

*rerunning the model without influential points or outliers using the new dataset new_allsuicide;
proc reg data = new_allsuicide;
model new_y= population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2/influencec r;
plot student.*(population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2 predicted.);
plot npp.*student.;
run;


**********************************
*Test performance of the new model;
*compute predicted values for Test set;
proc reg data= new_allsuicide;
model new_y=population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2;
output out=outm (where=(new_y=.)) p=yhat;
run;

proc print data=outm;
run;

*Difference between Observed and Predicted in Test Set;
data outm_sum;
set outm;
*d is different between observed and predicted values in test set;
d=lnsuicidesper100kpop-yhat;	
absd=abs (d);
run;


*Compute predictive statistics RMSE & MAE;
proc summary data=outm_sum;
var d absd;
output out=outm_stats std(d)=rmse mean(absd)=mae;
run;
proc print data=outm_stats;
run;

*correlation of observed and predicted values in test set;
proc corr data=outm;
var lnsuicidesper100kpop yhat;
run;

*******************************************
*Predict lnsuicidesper100kpop for 2 different cases;
*(a)Create prediction dataset;
DATA NEW;
INPUT population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2;
DATALINES;
100000 150000000000 1 1 0 1 0 1 0
100000 150000000000 0 1 0 1 0 0 1
PROC PRINT;
RUN;

*(b) Merge prediction dataset with original dataset;
DATA PRED;
SET NEW suicide ;
RUN;
PROC PRINT;
RUN;

*(c) Run prediction;
PROC REG data=PRED;
MODEL lnsuicidesper100kpop = population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2/p clm cli;
RUN;

*******************************************
*Fitting the Model with an Interaction Term;

*create an interaction term;
data inter_allsuicide;
set new_allsuicide;
pop_gdp = population*gdp_for_year_dollars;
run;

proc print data=inter_allsuicide (obs=10);
run;

*Check multicollinearity using peason correrlation;
proc corr;
var new_y population gdp_for_year_dollars dsex dgeneration3 dgeneration4 dage1 dage5 dcontinent1 dcontinent2 pop_gdp;
run;

*Center the data for population and gdp_for_year_dollars;
data suicide_centered;
set inter_allsuicide;
pop_c = 2569528 - population;
pop_gdp_c = pop_c*gdp_for_year_dollars;
gdp_c = 7.26759E11 - gdp_for_year_dollars;
gdp_pop_c = gdp_c*population;
run;

proc print data=suicide_centered;
run;

*Model Selection with interaction variables that are centered;
proc reg data=suicide_centered;
model new_y = gdp_pop_c gdp_c pop_gdp_c pop_c population gdp_for_year_dollars/selection=stepwise;
run;

proc reg data=suicide_centered;
model new_y = pop_gdp_c gdp_pop_c pop_c;
run;



