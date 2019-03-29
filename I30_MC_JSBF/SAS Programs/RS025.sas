/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS025.sas
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
	where upcase(NTRGRESP) in ('NON COMPLETE RESPONSE/NON PROGRESSIVE DISEASE')
	order by SUBJID; 
quit;

proc sql;
	create table TU as 
	select /*a.merge_datetime,*/ a.SUBJID,a.BLOCKID,/*a.TULNKID_NONTARGET,*/ b.TRSPID, b.TRDAT, b.TRPERF/*, b.TUMSTATE_NONTARGET*/
	from clntrial.TU3001a a left join clntrial.TU3001b b
	on a.SUBJID=b.SUBJID
	/*where upcase(TUMSTATE_NONTARGET) eq 'UNEQUIVOCAL PROGRESSION'*/
	order by a.SUBJID; 
quit;
proc sql;
	create table RSTU as 
	select /*a.merge_datetime,*/ a.SUBJID,a.BLOCKID,a.RSPERF,a.RSDAT,a.RSSPID,a.NTRGRESP,/*b.TULNKID_NONTARGET, */b.TRSPID, b.TRDAT, b.TRPERF/*,b.TUMSTATE_NONTARGET*/
	from RS a left join TU b
	on a.SUBJID=b.SUBJID and a.RSSPID = b.TRSPID
	order by a.SUBJID; 
quit;
proc sql;
	create table RS025 as 
	select /*merge_datetime,*/SUBJID,BLOCKID,RSPERF,RSDAT,RSSPID,NTRGRESP,/*TULNKID_NONTARGET,*/TRSPID,TRDAT,TRPERF/*, b.TUMSTATE_NONTARGET*/
	from RSTU 
/*	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) */
	order by SUBJID,/*DSDECOD,TULNKID_NONTARGET,*/TRSPID;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS025*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Target Tumor Identification and Results";
title2 "If Non-Target Response is Non Complete Response/Non Progressive Disease, ensure that none of the Non-Target Tumors have a tumor state of Unequivocal Progression";
  proc print data=RS025 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS025 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
