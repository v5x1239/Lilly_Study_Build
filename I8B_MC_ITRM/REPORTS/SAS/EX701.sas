/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX701.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
data ds;
set clntrial.DS1001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
keep SUBJID DSSTDAT1;
run;
proc sort;
by subjid;
run;
data ex1;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
format EXSTDAT1 date9.;
if page eq 'EX1001_F1';
keep SUBJID BLOCKID EXSPID EXSTDAT1;
run;
proc sort;
by subjid EXSPID;
run;
data ex2;
set clntrial.ex1001;
if EXENDAT ne . then
EXENDAT1 = datepart(EXENDAT);
format EXENDAT1 date9.;
if page eq 'EX1001_F1';
keep SUBJID BLOCKID EXSPID EXENDAT1;
run;
proc sort;
by subjid EXSPID;
run;
data ex;
merge ex1(in = a) ex2(in = b);
by subjid EXSPID;
run;
data fin;
set ex;
if EXSTDAT1 ne . and EXENDAT1 ne . then diff = EXENDAT1 - EXSTDAT1;
run;
proc sort;
by subjid;
run;
data final;
merge fin(in = a) ds dm;
by subjid;
if a;
run;
data EX701;
retain SITEMNEMONIC SUBJID BLOCKID EXSPID EXENDAT EXSTDAT diff DSSTDAT;
set final;
length flag $100.;
DSSTDAT = DSSTDAT1;
EXSTDAT = EXSTDAT1;
EXENDAT = EXENDAT1;
format DSSTDAT EXSTDAT EXENDAT date9.;
if diff ne . and diff > 14 then flag = 'Days treatment interrupted is > 14';
label diff = 'Days treatment interrupted';
keep SITEMNEMONIC SUBJID BLOCKID EXSPID EXENDAT EXSTDAT diff DSSTDAT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Study Treatment";
  title2 "Ensure start date of treatment is not greater than 14 days after end date.  
	If treatment is interrupted more than 14 days during lead-in, patient to be discontinued from the study. 
	If during treatment phase, study drug to be discontinued but patient can remain in the study";

proc print data=EX701 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX701 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

