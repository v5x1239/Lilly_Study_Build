/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC100.sas
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
set clntrial.lab_repo;
yr = datepart(BRTHDT);
format yr date9.;
year = year(yr);
keep invid subjid visid RQSTN_NBR BRTHDT SEX year visit_date;
run;
Proc sort;
by subjid;
run;

Data dm;
set clntrial.dm1001a_;
sex_dm = sex;
keep subjid sex_dm brthdatyy;
run;
Proc sort;
by subjid;
run;
data mer;
merge lab(in = a) dm;
by subjid;
if a;
run;
data REC100;
retain invid subjid visid visit_date RQSTN_NBR BRTHDT SEX sex_dm brthdatyy; 
set mer;
length flag $ 50.;
if sex ne sex_dm or year ne brthdatyy then flag = 'Gender or DOB is different';
keep invid subjid visid visit_date RQSTN_NBR BRTHDT SEX sex_dm brthdatyy flag;
run;
Proc sort;
by subjid;
run;

/*Print REC100*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PK";
title2 "Check the consistency of sex and birth years between GLS and the CRF.";
  proc print data=REC100 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC100 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
