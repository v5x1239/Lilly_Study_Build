/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS704.sas
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
set clntrial.ds1001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
if page eq 'DS1001_LF4' and DSDECOD eq 'SCREEN FAILURE';
keep SUBJID DSSTDAT1 DSDECOD;
run;
proc sort;
by SUBJID;
run;
data cm1;
set clntrial.cm1001;
if page in ('CM1001_LF1','CM1001_LF2','CM1001_C1LF2','CM1001_C2LF2','CM1001_C3LF2');
keep subjid CMTRT;
run;
proc sort;
by SUBJID;
run;
data cm2;
set clntrial.cm2001;
if page in ('CM2001_LF2');
keep subjid CMTRT;
run;
proc sort;
by SUBJID;
run;
data cm;
set cm1 cm2;
by subjid;
run;
proc sort;
by SUBJID;
run;
data pde;
set clntrial.PDE1001;
if page in ('PDE1001_F1');
keep subjid PDEOCCUR;
run;
proc sort;
by SUBJID;
run;
data inj;
set clntrial.INJSR100;
if page in ('INJSR1001_F1');
keep subjid IISRYN;
run;
proc sort;
by SUBJID;
run;
data ex1;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT_EX1F4 = datepart(EXSTDAT);
format EXSTDAT_EX1F4 date9.;
if page in ('EX1001_LF4');
keep SUBJID EXSTDAT_EX1F4;
run;
proc sort;
by subjid;
run;
data ex3;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT_EX1C1F4 = datepart(EXSTDAT);
format EXSTDAT_EX1C1F4 date9.;
if page in ('EX1001_C1LF4');
keep SUBJID EXSTDAT_EX1C1F4;
run;
proc sort;
by subjid;
run;
data ex2;
set clntrial.ex1001;
if EXENDAT ne . then
EXENDAT_EX1F5 = datepart(EXENDAT);
format EXENDAT_EX1F5 date9.;
if page in ('EX1001_LF5');
keep SUBJID EXENDAT_EX1F5;
run;
proc sort;
by subjid;
run;
data ex5;
set clntrial.ex1001;
if EXENDAT ne . then
EXENDAT_EX1C1F5 = datepart(EXENDAT);
format EXENDAT_EX1C1F5 date9.;
if page in ('EX1001_C1LF5');
keep SUBJID EXENDAT_EX1C1F5;
run;
proc sort;
by subjid;
run;
data ex4;
set clntrial.ex1001;
if page in ('EX1001_F1');
keep SUBJID EXTRTINT;
run;
proc sort;
by subjid;
run;
data dsex;
merge ds(in = a) ex1 ex2 ex3 ex4 ex5 cm pde inj dm;
by subjid;
if a;
run;
data DS704;
retain SITEMNEMONIC SUBJID DSSTDAT DSDECOD EXSTDAT_EX1F4 EXENDAT_EX1F5 
EXSTDAT_EX1C1F4 EXTRTINT EXENDAT_EX1C1F5 CMTRT PDEOCCUR IISRYN;
set dsex;
DSSTDAT = DSSTDAT1;
format DSSTDAT date9.;
keep SITEMNEMONIC SUBJID DSSTDAT DSDECOD EXSTDAT_EX1F4 EXENDAT_EX1F5 
EXSTDAT_EX1C1F4 EXTRTINT EXENDAT_EX1C1F5 CMTRT PDEOCCUR IISRYN;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Summary";
  title2 "If DSDECOD = Screen Failure, the following LOG visits should not contain data:
EX, CM, PRND, INJSR";

proc print data=DS704 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS704 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

