* a;
data Bankingfull;
infile "S:\HW4\Bankingfull.txt" delimiter = '09'x missover firstobs=2;
input age education income homeVal wealth balance;
run;
proc print;
run;

proc sgscatter;
matrix balance age education income homeVal wealth;
run;

*b;
proc corr;
var balance age education income homeVal wealth;
run;

* c;
proc reg;
model balance= age education income homeVal wealth /vif tol;
run;


data Bankingfull_new;
set Bankingfull;
drop income;
run;

proc print data = Bankingfull_new;
run;

* d;
proc reg;
model balance= age education homeVal wealth /vif tol;
run;

* d-b;
* Residual plot: residuals vs x-variables;
plot student.*(age education homeVal wealth);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

proc sgscatter;
matrix balance age education homeVal wealth ;
run;

proc gplot;
plot balance*(age education homeVal wealth );
run;

proc corr;
var balance age education homeVal wealth;
run;

* d-c;
*run model with outlier - use the second model;
proc reg data = Bankingfull_new;
model balance= age education homeVal wealth/influencec r;
plot student.*( age education homeVal wealth predicted.);
plot npp.*student.;
run;

*deleting Multiple observations;
data bankingfull_new1;
set bankingfull_new;
if _n_ in (38 77 84 85 91 102) then delete;
run;

*rerunning the model without outlier using the new dataset;
proc reg data = Bankingfull_new1;
model balance= age education homeVal wealth/influencec r;
plot student.*( age education homeVal wealth predicted.);
plot npp.*student.;
run;

* d-d;
proc reg data = Bankingfull_new1;
model balance= age education homeVal wealth/stb;
run;


* a;
data Bankingfull;
infile "S:\HW4\Bankingfull.txt" delimiter = '09'x missover firstobs=2;
input age education income homeVal wealth balance;
run;
proc print;
run;

proc sgscatter;
matrix balance age education income homeVal wealth;
run;

*b;
proc corr;
var balance age education income homeVal wealth;
run;

* c;
proc reg;
model balance= age education income homeVal wealth /vif tol;
run;


data Bankingfull_new;
set Bankingfull;
drop income;
run;

proc print data = Bankingfull_new;
run;

* d;
proc reg;
model balance= age education homeVal wealth /vif tol;
run;

* d-b;
* Residual plot: residuals vs x-variables;
plot student.*(age education homeVal wealth);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

proc sgscatter;
matrix balance age education homeVal wealth ;
run;

proc gplot;
plot balance*(age education homeVal wealth );
run;

proc corr;
var balance age education homeVal wealth;
run;

* d-c;
*run model with outlier - use the second model;
proc reg data = Bankingfull_new;
model balance= age education homeVal wealth/influencec r;
plot student.*( age education homeVal wealth predicted.);
plot npp.*student.;
run;

*deleting Multiple observations;
data bankingfull_new1;
set bankingfull_new;
if _n_ in (38 77 84 85 91 102) then delete;
run;

*rerunning the model without outlier using the new dataset;
proc reg data = Bankingfull_new1;
model balance= age education homeVal wealth/influencec r;
plot student.*( age education homeVal wealth predicted.);
plot npp.*student.;
run;

* d-d;
proc reg data = Bankingfull_new1;
model balance= age education homeVal wealth/stb;
run;

*import data from file;
proc import datafile="S:\HW4\pgatour2006.csv" out=myd replace;
delimiter=',';
getnames=yes;
run;

Proc print;
run;

* a;
proc sgscatter;
matrix PrizeMoney DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
run;

proc gplot;
plot PrizeMoney*(DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound);
run;

proc corr;
var PrizeMoney DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound;
run;

* b;
title "HISTOGRAM of PrizeMoney";
proc univariate normal;
var PrizeMoney;
histogram / normal (mu = est sigma = est);
run;

data myd;
set myd;
lnPrizeMoney = log(PrizeMoney);
run;
Proc print;
run;

* c;
title "HISTOGRAM of lnPrizeMoney";
proc univariate normal;
var lnPrizeMoney;
histogram / normal (mu = est sigma = est);
run;

proc reg;
model lnPrizeMoney= DrivingAccuracy GIR PuttingAverage BirdieConversion PuttsPerRound /stb;
run;

* d-a;
*rerunning the model after removing insig DrivingAccuracy;
 proc reg;
model lnPrizeMoney= GIR PuttingAverage BirdieConversion PuttsPerRound /stb;
run;

*rerunning the model again after removing insig DrivingAccuracy & PuttingAverage;
 proc reg;
model lnPrizeMoney= GIR BirdieConversion PuttsPerRound /stb;
run;

* d-b;
* Residual plot: residuals vs x-variables;
plot student.*(GIR BirdieConversion PuttsPerRound);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

proc sgscatter;
matrix lnPrizeMoney GIR BirdieConversion PuttsPerRound ;
run;

proc gplot;
plot lnPrizeMoney*(GIR BirdieConversion PuttsPerRound );
run;

proc corr;
var lnPrizeMoney GIR BirdieConversion PuttsPerRound;
run;

*run model with outlier ;
proc reg data = myd;
model lnPrizeMoney=GIR BirdieConversion PuttsPerRound/influencec r;
plot student.*( GIR BirdieConversion PuttsPerRound predicted.);
plot npp.*student.;
run;

*deleting Multiple observations;
data myd_new;
set myd;
if _n_ in (40 185) then delete;
run;

*rerun model use the second model;
proc reg data = myd_new;
model lnPrizeMoney=GIR BirdieConversion PuttsPerRound/influencec r;
plot student.*( GIR BirdieConversion PuttsPerRound predicted.);
plot npp.*student.;
run;

proc reg data = myd_new;
model lnPrizeMoney=GIR BirdieConversion PuttsPerRound;
run;
