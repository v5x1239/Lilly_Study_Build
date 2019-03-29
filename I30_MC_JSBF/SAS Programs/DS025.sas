/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS025.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : When DSSCAT = "Study Disposition" and DSSTDAT is present, then the AE CRF should either have AEYN = No or at least one AE record should be present.
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

data ae;/*AE4001_F2_S1*/
set clntrial.AE4001;
if AEYN eq '' and AE4001/*_F2_S1*/ eq '';
keep /*merge_datetime*/ SUBJID AEYN AE4001/*_F2_S1*/;
run;
proc sort; by SUBJID; run;

data ds; /*DSSTDAT*/
set clntrial.DS1001;
if upcase(DSSCAT) eq "STUDY DISPOSITION" and DSSTDAT ne '';
keep /*merge_datetime*/ SUBJID DSSCAT DSSTDAT;
run;
proc sort; by SUBJID; run;

data DS025_(KEEP=/*merge_datetime*/ SUBJID DSSCAT DSSTDAT AEYN AE4001/*_F2_S1*/);
	merge ds (in=a) ae (in=b);
	by SUBJID;
	if a and b;
run;

proc sql;
create table DS025 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, a.DSSCAT, a.DSSTDAT,
	a.AEYN, a.AE4001/*_F2_S1*/ 
from DS025_ a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
/*where (datepart(a.merge_datetime) > input("&date", ? Date9.))*/
order by b.SITEMNEMONIC, a.SUBJID
; quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS025*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Date";
title2 "When DSSCAT = 'Study Disposition' and DSSTDAT is present, then the AE CRF should either have AEYN = No or at least one AE record should be present.";
  proc print data=DS025 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS025 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
