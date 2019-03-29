/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE027.sas
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8K_MC_JPDA;*/

/*Prem, use the _all version of the raw dataset for programming*/

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
	keep SUBJID AEGRPID AESPID AESTDAT AEONGO AEENDAT;
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
data mer;
	merge ae(in = a) dm;
	by SUBJID;
	if a;
run;
proc sort;
	by SUBJID AEGRPID AESPID;
run;
data lag;
	set mer;
	by SUBJID AEGRPID AESPID;
	sub = lag(SUBJID);
	prid = lag(AEGRPID);
	spid = lag(AESPID);
	st = lag(AESTDAT);
	en = lag(AEENDAT);
	format st en datetime20.;
run;
data fin;
	set lag;
	if sub eq SUBJID and prid eq AEGRPID and spid ne AESPID
	and st ge AEENDAT;
run;
data ae027;
	retain /*merge_datetime*/ SITEMNEMONIC SUBJID AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT;
	set fin;
	keep /*merge_datetime*/ SITEMNEMONIC SUBJID AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT;
run;


	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print AE027*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Adverse Event";
title2 "Events within the same AEGRPID must have a change in Severity or in Seriousness  in consecutive chronologic entries.";
  proc print data=AE027 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE027 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
