/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS007a.sas
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8K_MC_JPDA;*/

data dm;
	Set clntrial.DM1001c;
	keep SITEMNEMONIC SUBJID;
run;
proc sort nodup;
	by SUBJID;
run;
data ae1;
	set clntrial.AE3001a;
	keep /*merge_datetime*/ SUBJID AEGRPID AETERM AEDECOD;
run;
proc sort;
	by SUBJID AEGRPID;
run;
data ae2;
	set clntrial.AE3001b;
	if upcase(AESER) eq 'Yes';
	keep SUBJID AEGRPID AESPID AESTDAT AEONGO AEENDAT AESER;
run;
proc sort;
	by SUBJID AEGRPID;
run;
data ae;
	merge ae1 ae2;
	by SUBJID AEGRPID;
run;
proc sort;
	by SUBJID;
run;
data ds(keep=SUBJID BLOCKID DSDECOD AEGRPID DSSTDAT);
	set clntrial.DS1001;
	where DSDECOD eq 'ADVERSE EVENT';
	AEGRPID = AEGRPREL;
run;
proc sort;
	by SUBJID AEGRPID;
run;
data mer;
	merge ds(in = a) ae;
	by SUBJID AEGRPID;
	if a;
run;
proc sort;
	by SUBJID;
run;
data fin;
	merge mer(in = a) dm;
	by SUBJID;
	if a;
run;
data DS007a;
	retain /*merge_datetime*/ SITEMNEMONIC SUBJID BLOCKID DSDECOD DSSTDAT AEGRPID AETERM AESTDAT AEONGO AEENDAT AESER;
	set fin;
	if (datepart(AEENDAT) <= (datepart(DSSTDAT) + 30)) or AEENDAT eq .;
	keep /*merge_datetime*/ SITEMNEMONIC SUBJID BLOCKID DSDECOD DSSTDAT AEGRPID AETERM AESTDAT AEONGO AEENDAT AESER;
run;


	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS007a*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Event";
title2 "If  status is Adverse Event, then AE Stop date  for all non-serious events must be less or equal Discontinuation Date or Ongoing.";
  proc print data=DS007a noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS007a nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
