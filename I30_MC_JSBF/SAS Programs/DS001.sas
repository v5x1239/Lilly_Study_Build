/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS001.sas
PROJECT NAME (required)           : I3O_MC_JSBF
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

/*Prem, use the below libame statment to call in the Clintrial raw datasets.*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I3O_MC_JSBF;*/

/*Prem, use the _all version of the raw dataset for programming*/

proc sql;
create table site as 
select /*a.merge_datetime,*/ SITEMNEMONIC, SUBJID
from clntrial.DM1001c 
order by SUBJID
; 
quit;
data ds1;
set clntrial.DS2001;
if page eq 'DS2001_LF1';
DSSTDAT_IC_LF1 = DSSTDAT;
format DSSTDAT_IC_LF1 date9.;
keep SUBJID DSSTDAT_IC_LF1;
run;
proc sort;
by subjid;
run;
data ds2;
set clntrial.DS1001;
if page eq 'DS1001_LF2';
DSSTDAT_LF2 = DSSTDAT;
format DSSTDAT_LF2 date9.;
keep SUBJID DSSTDAT_LF2;
run;
proc sort;
by subjid;
run;
data ds3;
set clntrial.DS2001;
if page eq 'DS2001_LF3';
DSSTDAT_IC_LF3 = DSSTDAT;
format DSSTDAT_IC_LF3 date9.;
keep /*merge_datetime*/ SUBJID DSSTDAT_IC_LF3;
run;
proc sort;
by subjid;
run;
data ds;
merge ds1 ds2 ds3;
by subjid;
run;
data all;
merge ds(in = a) site;
by subjid;
run;
data fin;
set all;
if (DSSTDAT_IC_LF3 ne . and DSSTDAT_IC_LF1 ne . and DSSTDAT_IC_LF3 < DSSTDAT_IC_LF1) or 
(DSSTDAT_IC_LF3 ne . and DSSTDAT_LF2 ne . and DSSTDAT_IC_LF3 > DSSTDAT_LF2);
run;

proc sql;
create table DS001 as 
select /*merge_datetime,*/ SUBJID,DSSTDAT_IC_LF1,DSSTDAT_IC_LF3,DSSTDAT_LF2
from fin
order by SITEMNEMONIC, SUBJID
;
quit;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "ICOT (Informed consent optional tissue)";
title2 "Optional IC Date must be >= Study Informed Consent Date and <= Treatment Discontinuation Date";
  proc print data=DS001 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS001 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
