/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS026.sas
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
	select /*a.merge_datetime,*/ SUBJID,BLOCKID,RSPERF,RSDAT,RSSPID,NTRGRESP
	from clntrial.RS1001
	where upcase(NTRGRESP) in ('NOT ASSESSED', 'NOT ALL EVALUATED')
	order by SUBJID; 
quit;
proc sql;
	create table TU as 
	select /*a.merge_datetime,*/ a.SUBJID,a.BLOCKID,/*a.TULNKID_NONTARGET,*/ b.TRSPID, b.TRDAT, b.TRPERF/*, b.TUMSTATE_NONTARGET*/
	from clntrial.TU3001a a left join clntrial.TU3001b b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID; 
quit;
proc sql;
	create table RSTU as 
	select /*a.merge_datetime,*/ a.SUBJID,a.BLOCKID,a.RSPERF,a.RSDAT,a.RSSPID,a.NTRGRESP,/*b.TULNKID_NONTARGET,*/ b.TRSPID, b.TRDAT, b.TRPERF/*, b.TUMSTATE_NONTARGET*/
	from RS a left join TU b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID; 
quit;
proc sql;
	create table RS026 as 
	select /*merge_datetime,*/SUBJID,BLOCKID,RSPERF,RSDAT,RSSPID,NTRGRESP/*,TULNKID_NONTARGET*/,TRSPID,TRDAT,TRPERF/*, b.TUMSTATE_NONTARGET*/
	from RSTU 
/*	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) */
	order by SUBJID,/*DSDECOD,TULNKID_NONTARGET,*/TRSPID;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS026*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Target Tumor Identification and Results";
title2 "If Non-Target response is Not assessed or Not All Evaluated, ensure that one or more Non-Target tumors have a tumor state of not assessable.";
  proc print data=RS026 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS026 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
