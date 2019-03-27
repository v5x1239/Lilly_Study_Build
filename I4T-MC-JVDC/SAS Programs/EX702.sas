/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX702.sas
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


data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;
data sv;
set clntrial.sv1001;
visdat1 = datepart(visdat);
format visdat1 date9.;
label visdat1 = 'Date of Visit';
keep subjid blockid visdat1;
run;
Proc sort;
by subjid blockid;
run;
Data ex;
set clntrial.ex1001;
if EXENTIM ne '' and EXSTTIM ne '' then diff = ((input(EXENTIM,time5.) - input(EXSTTIM,time5.))/60)/60; 
keep subjid /*MERGE_DATETIME*/ EXENTIM EXSTTIM diff blockid;
run;
Proc sort;
by subjid blockid;
run;
data mer;
merge ex(in = a) sv;
by subjid blockid;
if a;
run;
Proc sort;
by subjid;
run;
data mer1;
merge mer(in = a) dm;
by subjid;
if a;
run;
data EX702;
retain /*MERGE_DATETIME*/ SITEMNEMONIC subjid EXENTIM EXSTTIM visdat1; 
set mer1;
if diff ne . and diff ne 1;
keep /*MERGE_DATETIME*/ SITEMNEMONIC subjid EXENTIM EXSTTIM visdat1;
run;
Proc sort;
by subjid;
run;

/*Print EX702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii ;
  title1 "Exposure";
title2 " infusion time > or < 1 hour?";
  proc print data=EX702 noobs WIDTH=min label; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
