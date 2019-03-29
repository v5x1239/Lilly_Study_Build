/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
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
proc sql;
	create table ds as select SUBJID, BLOCKID, DSDECOD, /*DSCAT_1,*/ DSSCAT,count(DSSCAT) as cnt from clntrial.DS1001
	group by SUBJID
	order by SUBJID;
quit;
data ds1;
	set ds;
	if cnt gt 1;
run;
data DS003;
	retain /*merge_datetime*/ SITEMNEMONIC SUBJID BLOCKID DSDECOD /*DSCAT_1*/ DSSCAT;
	set ds1;
	keep /*merge_datetime*/ SITEMNEMONIC SUBJID BLOCKID DSDECOD /*DSCAT_1*/ DSSCAT;
run;


	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS003*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Event";
title2 "One summary date/record must exist for every patient.";
  proc print data=DS003 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS003 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
