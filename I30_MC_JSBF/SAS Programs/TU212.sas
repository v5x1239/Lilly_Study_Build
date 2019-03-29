/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU212.sas
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
	create table TU as 
	select /*a.merge_datetime,*/ a.SUBJID, 
	a.BLOCKID, /*a.TULNKID_TARGET,*/b.TRLNKID,b.TRSPID
	from clntrial.TU2001a a left join clntrial.TU2001b b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID,/*a.TULNKID_TARGET,*/b.TRLNKID,b.TRSPID; 
quit;
data lag;
	set tu;
	sub = lag(SUBJID);
	/*tul = lag(TULNKID_TARGET);*/
	trl = lag(TRLNKID);
	trp = lag(TRSPID);
	if sub eq SUBJID and /*tul eq TULNKID_TARGET and*/ TRLNKID gt trl and trp gt TRSPID;
run;
proc sql;
	create table TU212 as 
	select /*merge_datetime,*/ SUBJID, BLOCKID, /*TULNKID_TARGET,*/TRLNKID,TRSPID
	from lag 
/*	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) */
	order by SUBJID,/*TULNKID_TARGET,*/TRLNKID,TRSPID;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print TU212*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Target Tumor Identification and Results";
title2 "Assessment number must be unique and sequential across assessments";
  proc print data=TU212 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU212 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
