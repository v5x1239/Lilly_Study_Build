/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE026.sas
PROJECT NAME (required)           : H8A_MC_LZBE
DESCRIPTION (required)            : 
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

*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=H8A_MC_LZBE;

/*Prem, use the _all version of the raw dataset for programming*/

data dm;
	set clntrial.DM1001c;
	keep SITEMNEMONIC SUBJID;
run;
proc sort;
	by subjid;
run;
Data ds1;
	set clntrial.DS1001;
	if page eq 'DS1001_LF4';
	keep subjid DSDECOD DSSTDAT DTHDAT;
run;
proc sort;
	by subjid;
run;
Data ds2;
	set clntrial.DS1001;
	if page eq 'DS1001_LF6';
	keep subjid DSDECOD DSSTDAT DTHDAT;
run;
proc sort;
	by subjid;
run;
Data ds3;
	set clntrial.DS1001;
	if page eq 'DS1001_LF7';
	keep subjid DSDECOD DSSTDAT DTHDAT;
run;
proc sort;
	by subjid;
run;
Data ds4;
	set clntrial.DS1001;
	if page eq 'DS1001_LF8';
	keep subjid DSDECOD DSSTDAT DTHDAT;
run;
proc sort;
	by subjid;
run;
Data ds;
	set ds1 ds2 ds3 ds4;
run;
proc sort;
	by subjid;
run;
data sae;
	set clntrial.sae2001a clntrial.sae2001b clntrial.sae2001c;
	if page eq 'SAE2001_LF1';
	keep subjid /*merge_datetime SAEAEACN*/;
run;
proc sort;
	by subjid;
run;
data fin;
	merge sae(in = a) ds dm;
	by subjid;
	if a;
run;
data AE026;
	retain /*MERGE_DATETIME*/ SITEMNEMONIC SUBJID SAESDTH SAESDTH SAEDTHDAT DSDECOD
	DSSTDAT DTHDAT
;
	set fin;
	*where datepart(MERGE_DATETIME) > input("&date", ? Date9.);
	keep /*MERGE_DATETIME*/ SITEMNEMONIC SUBJID SAEAEACN AEGRPID_RELREC2 VISDAT;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print AE026*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Serious Adverse Events";
title2 "Check the Action Taken with Study Treatment with the exposure forms";
  proc print data=AE026 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE026 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
