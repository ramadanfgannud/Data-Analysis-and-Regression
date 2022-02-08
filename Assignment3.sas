proc reg;
model balance=age income;
* Residual plot: residuals vs x-variables;
plot student.*(age income);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;

* a;
data HouseSlaes;
infile "S:\HW3\HouseSales.txt" delimiter = '09'x missover firstobs=2;
input region $ type $ price cost;
numtype = 1;
if type = 'T' then numtype = 0;
numregion = 1;
if region = 'S' then numregion = 0;
run;
proc print;
run;

*b;
proc sgscatter;
matrix price cost numtype numregion;
run;

proc gplot;
plot price*(cost numtype numregion);
run;

proc corr;
var price cost numtype numregion;
run;

*Model 1- full model with all predictors; 
proc reg;
model price= cost numtype numregion /stb;
run;

*c;
*Model 2: remove numregion because it's not sig;
proc reg;
model price= cost numtype /stb;
run;

*d;
proc reg;
model price=cost numtype;
* Residual plot: residuals vs x-variables;
plot student.*(cost numtype);
* Residual plot: residuals vs pred. values;
plot student.*predicted.;

* Normal probability plot or QQ plot;
plot npp.*student.;
run;
	
	*g;
	proc reg;
model price= cost numtype numregion /stb;
run;
