/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SAE701.sas
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
Data ex;
	set clntrial.EX1001;
	if page eq 'EX1001_F2';
	keep subjid AEGRPID_RELREC2;
run;
proc sort;
	by subjid;
run;
Data sv;
	set clntrial.sv1001;
	keep subjid VISDAT;
run;
proc sort;
	by subjid;
run;
data sae;
	set clntrial.sae2001a clntrial.sae2001b clntrial.sae2001c;
	if page eq 'SAE2001_LF1';
	keep subjid merge_datetime SAEAEACN;
run;
proc sort;
	by subjid;
run;
data fin;
	merge sae(in = a) ex dm sv;
	by subjid;
	if a;
run;
data SAE701;
	retain MERGE_DATETIME SITEMNEMONIC SUBJID SAEAEACN AEGRPID_RELREC2 VISDAT;
	set fin;
	where datepart(MERGE_DATETIME) > input("&date", ? Date9.);
	keep MERGE_DATETIME SITEMNEMONIC SUBJID SAEAEACN AEGRPID_RELREC2 VISDAT;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print SAE701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Serious Adverse Events";
title2 "Check the Action Taken with Study Treatment with the exposure forms";
  proc print data=SAE701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SAE701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
