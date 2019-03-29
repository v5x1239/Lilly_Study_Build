/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS031.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Ensure "assessment number within visit" are sequential for multiple assessments performed.
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
	create table RS as 
	select /*a.merge_datetime,*/ SUBJID,BLOCKID,RSPERF,RSDAT,RSSPID,OVRLRESP
	from clntrial.RS1001
	where upcase(OVRLRESP) in ('PROGRESSIVE DISEASE')
	order by SUBJID; 
quit;

proc sql;
	create table DS as 
	select /*a.merge_datetime,*/ SUBJID,DSSTDAT, DSDECOD
	from clntrial.Ds1001
	where upcase(DSDECOD) eq 'PROGRESSIVE DISEASE'
	order by SUBJID; 
quit;
proc sql;
	create table RSDS as 
	select /*a.merge_datetime,*/ a.SUBJID,a.BLOCKID,a.RSPERF,a.RSDAT,a.RSSPID,a.OVRLRESP,b.DSSTDAT,b.DSDECOD
	from RS a left join DS b
	on a.SUBJID=b.SUBJID and a.RSDAT > b.DSSTDAT
	order by a.SUBJID; 
quit;
proc sql;
	create table RS031 as 
	select /*merge_datetime,*/SUBJID,BLOCKID,RSPERF,RSDAT,RSSPID,OVRLRESP,DSSTDAT,DSDECOD
	from RSDS
/*	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) */
	order by SUBJID,DSDECOD;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS031*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "RS (Response)";
title2 "When Overall Response is PD and reason for discontinuation is PD, date of Response Assessment must be <= date of discontinuation";
  proc print data=RS031 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS031 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
