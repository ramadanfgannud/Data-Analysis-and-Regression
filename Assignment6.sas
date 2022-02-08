*a;
proc import datafile="S:\HW6\churn_train.csv" out=myd replace;
delimiter=',';
getnames=yes;
run;

Proc print data=myd (obs= 20);
run;

*Boxplot - by AGE;
proc sort;
by CHURN;
RUN;

PROC BOXPLOT;
PLOT AGE*CHURN;
RUN;

*Boxplot - by PCT_CHNG_BILL_AMT*CHURN;
PROC BOXPLOT;
PLOT PCT_CHNG_BILL_AMT*CHURN;
RUN;

*Create dummy variable for Gender;
data churn;
set myd;
numGender = 1;
if GENDER = 'F' then numGender = 0;
EDUCATION1 = EDUCATION;
If EDUCATION = '.' then EDUCATION1 = 0;
run;

Proc print data=churn (obs= 20);
run;

*b;
*fit full logistic model;
PROC LOGISTIC data=churn;
MODEL CHURN (EVENT = '1') = EDUCATION1 LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT COMPLAINT numGender/STB;
RUN;

*d;
*(a) Create prediction dataset;
DATA NEW;
INPUT LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT COMPLAINT numGender EDUCATION1;
DATALINES;
0 4 43 1.04 1.19 1 1 0
PROC PRINT;
RUN;

*(b) Merge prediction dataset with original dataset;
DATA PRED;
SET NEW churn;
RUN;
PROC PRINT;
RUN;

*(c) Run prediction;
PROC LOGISTIC data=PRED;
MODEL CHURN (EVENT = '1') = LAST_PRICE_PLAN_CHNG_DAY_CNT TOT_ACTV_SRV_CNT AGE PCT_CHNG_IB_SMS_CNT PCT_CHNG_BILL_AMT COMPLAINT numGender EDUCATION1;
OUTPUT OUT=PRED P=PHAT LOWER=LCL UPPER=UCL;
RUN;

*(d) Print predicted probabilities and confidence intervals;

PROC PRINT data=PRED;
RUN;
