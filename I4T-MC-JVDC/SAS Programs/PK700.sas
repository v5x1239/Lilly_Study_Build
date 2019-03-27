/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK700.sas
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
set clntrial.lab_pk_j;
CLLCTDT1 = datepart(CLLCTDT);
format CLLCTDT1 date9.;
cllm = compress(put(cllcttm,best.),'');
if length(cllm) eq 3 then cllcttm1 = '0'||substr(cllm,1,1)||':'||substr(cllm,2,2);
if length(cllm) eq 4 then cllcttm1 = substr(cllm,1,2)||':'||substr(cllm,3,2);
block_lab = blockid;
keep invid subjid blockid RQSTN_NBR block_lab CLLCTDT1 cllcttm1 lbtestcd;
run;
Proc sort;
by subjid blockid;
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
run;
Proc sort;
by subjid blockid;
run;
data mer;
merge lab(in = a) ex;
by subjid blockid;
if a;
run;
data PK700;
retain invid subjid block_lab CLLCTDT cllcttm lbtestcd RQSTN_NBR blockid EXSTDAT EXSTTIM EXENTIM EXSTTIMD EXENTIMD; 
set mer;
cllcttm =cllcttm1;
CLLCTDT = CLLCTDT1;
EXSTDAT = EXSTDAT1;
format EXSTDAT CLLCTDT date9.;
keep invid subjid block_lab CLLCTDT cllcttm lbtestcd RQSTN_NBR blockid EXSTDAT EXSTTIM EXENTIM EXSTTIMD EXENTIMD;
run;
Proc sort;
by subjid;
run;

/*Print PK700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PK";
title2 "Query when post infusion times don't match the dosing date or if the collection time is earlier than the predose sample draw";
  proc print data=PK700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set PK700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
