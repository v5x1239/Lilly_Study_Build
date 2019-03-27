/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SAE702.sas
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
Data ex1;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F1 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F1 date9.;
	if page eq 'EX1001_F1';
	keep subjid EXSTDAT_EX1001_F1;
run;
proc sort;
	by subjid;
run;
Data ex2;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F2 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F2 date9.;
	if page eq 'EX1001_F2';
	keep subjid EXSTDAT_EX1001_F2;
run;
proc sort;
	by subjid;
run;
Data ex3;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F3 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F3 date9.;
	if page eq 'EX1001_F3';
	keep subjid EXSTDAT_EX1001_F3;
run;
proc sort;
	by subjid;
run;
Data ex4;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F4 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F4 date9.;
	if page eq 'EX1001_F4';
	keep subjid EXSTDAT_EX1001_F4;
run;
proc sort;
	by subjid;
run;
Data ex5;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F5 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F5 date9.;
	if page eq 'EX1001_F5';
	keep subjid EXSTDAT_EX1001_F5;
run;
proc sort;
	by subjid;
run;
Data ex6;
	set clntrial.EX1001;
	EXSTDAT_EX1001_F6 = datepart(EXSTDAT);
	format EXSTDAT_EX1001_F6 date9.;
	if page eq 'EX1001_F6';
	keep subjid EXSTDAT_EX1001_F6;
run;
proc sort;
	by subjid;
run;
data ex;
	merge ex1 ex2 ex3 ex4 ex5 ex6;
	by subjid;
run;
proc sort;
	by subjid;
run;
data sae;
	set clntrial.sae2001a clntrial.sae2001b clntrial.sae2001c;
	if page eq 'SAE2001_LF1';
	keep subjid merge_datetime SAEEXDOSDAT;
run;
proc sort;
	by subjid;
run;
data fin;
	merge sae(in = a) ex dm;
	by subjid;
	if a;
run;
data SAE702;
	retain MERGE_DATETIME SITEMNEMONIC SUBJID SAEEXDOSDAT EXSTDAT_EX1001_F1 EXSTDAT_EX1001_F2
	EXSTDAT_EX1001_F3 EXSTDAT_EX1001_F4 EXSTDAT_EX1001_F5 EXSTDAT_EX1001_F6;
	set fin;
	where datepart(MERGE_DATETIME) > input("&date", ? Date9.);
	keep MERGE_DATETIME SITEMNEMONIC SUBJID SAEEXDOSDAT EXSTDAT_EX1001_F1 EXSTDAT_EX1001_F2
	EXSTDAT_EX1001_F3 EXSTDAT_EX1001_F4 EXSTDAT_EX1001_F5 EXSTDAT_EX1001_F6;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print SAE702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Serious Adverse Events";
title2 "Check the Date of Last Treatment Administration (prior to SAE) with the exposure forms";
  proc print data=SAE702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SAE702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
