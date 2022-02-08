*compute predictions;
data pred;
input balance age education homeVal wealth;
datalines;
. 34 13 160000 140000
;

*join datasets;
data predict;
set pred Bankingfull_new1;
run;

proc print;
run;

proc reg;
model balance= age education homeVal wealth/p clm cli;
run;

*a;
*import data from file;
proc import datafile="S:\HW5\College.csv" out=myd replace;
delimiter=',';
getnames=yes;
run;

*Create dummy variable for Private;
data college;
set myd;
numprivate = 1;
if Private = 'No' then numprivate = 0;
run;

Proc print data = college (obs= 20);
run;

title "HISTOGRAM of Grad_Rate";
proc univariate normal;
var Grad_Rate;
histogram / normal (mu = est sigma = est);
run;

*b;
proc sgscatter;
matrix Grad_Rate numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend;
run;

proc gplot;
plot Grad_Rate*(numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend);
run;

proc corr;
var Grad_Rate numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend;
run;

*c;
*Boxplot - by Private;
proc sort;
by Private;
RUN;

PROC BOXPLOT;
PLOT Grad_Rate*Private;
RUN;

proc sort;
by Elite10;
RUN;

*Boxplot - by Elite;
PROC BOXPLOT;
PLOT Grad_Rate*Elite10;
RUN;

*d;
*Model 1- full model with all predictors; 
proc reg;
model Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend /stb;
run;

*e;
proc reg;
model Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend /vif tol;
run;


*f;
PROC REG data=college ;
*Backward selection method;
MODEL Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend/SELECTION = adjrsq;
run;

PROC REG data=college ;
*CP selection method;
MODEL Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Books Personal PhD Terminal S_F_Ratio perc_alumni Expend/SELECTION = cp;
run;


*g;
PROC REG data=college ;
MODEL Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD perc_alumni Expend;
run;

*First Model;
PROC REG data=college ;
MODEL Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend;
run;

*h;
plot student.*(numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

*i;
proc reg data = college;
model Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend/influence r;
plot student.*(numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend predicted.);
plot npp.*student.;
run;

*j;
*deleting Multiple observations;
data college_new;
set college;
if _n_ in (29 63 119 140 256 238 274 277 287 437 439 492 559 568 738 743 771) then delete;
run;

*rerunning the model without outlier using the new dataset;
proc reg data = college_new;
model Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend/influence r;
plot student.*(numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend predicted.);
plot npp.*student.;
run;

*k;
proc reg data = college_new;
model Grad_Rate=numprivate Accept_pct Elite10 F_Undergrad P_Undergrad Outstate Room_Board Personal PhD Terminal perc_alumni Expend/stb;
run;
