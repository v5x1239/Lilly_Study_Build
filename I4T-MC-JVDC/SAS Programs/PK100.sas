/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK100.sas
PROJECT NAME (required)           : I4T_MC_JVDC
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I4T_MC_JVDC;*/

data lab;
set clntrial.lab_pk_jvdc;
keep invid subjid blockid cllctdt cllcttm lbtestcd;
run;
Proc sort;
by subjid;
run;

Data ex1;
set clntrial.EX1001;
if page eq 'EX1001_F1'; 
EXSTDAT1 = datepart(EXSTDAT);
format EXSTDAT1 date9.;
keep subjid blockid EXSTDAT1 EXSTTIM EXENTIM;
run;
Proc sort;
by subjid blockid EXSTDAT1;
run;
Data ex2;
set clntrial.EX1001;
if page eq 'EX1001_F2'; 
EXSTDAT1 = datepart(EXSTDAT);
format EXSTDAT1 date9.;
EXSTTIMD = EXSTTIM;
EXENTIMD = EXENTIM;
keep subjid blockid EXSTDAT1 EXSTTIMD EXENTIMD;
run;
Proc sort;
by subjid blockid EXSTDAT1;
run;
data ex;
merge ex1 ex2;
by subjid blockid EXSTDAT1;
drop blockid;
run;
Proc sort;
by subjid;
run;
data mer;
merge lab(in = a) ex;
by subjid;
if a;
run;
data PK100;
retain invid subjid blockid cllctdt cllcttm lbtestcd EXSTDAT EXSTTIM EXENTIM EXSTTIMD EXENTIMD; 
set mer;
EXSTDAT = EXSTDAT1;
format EXSTDAT date9.;
keep invid subjid blockid cllctdt cllcttm lbtestcd EXSTDAT EXSTTIM EXENTIM EXSTTIMD EXENTIMD;
run;
Proc sort;
by subjid;
run;

/*Print PK100*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PK";
title2 "Query when post infusion times don't match the dosing date or if the collection time is earlier than the predose sample draw";
  proc print data=PK100 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set PK100 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
