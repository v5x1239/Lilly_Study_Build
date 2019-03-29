/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU219.sas
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
	create table DS as 
	select /*a.merge_datetime,*/ a.SUBJID,a.DSDECOD
	from clntrial.DS1001 a left join clntrial.SS1001 b
	on a.SUBJID=b.SUBJID
	where upcase(DSDECOD) not in ('LOST TO FOLLOW UP','DEATH','PROGRESSIVE DISEASE')
	order by a.SUBJID; 
quit;
proc sql;
	create table TU as 
	select /*a.merge_datetime,*/ a.SUBJID,/*a.TULNKID_TARGET,*/ b.TRSPID, b.TRDAT
	from clntrial.TU2001a a left join clntrial.TU2001b b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID; 
quit;
data tu1;
	format date date9.;
	set tu;
	date = datepart(TRDAT);
	/*format date date9.;*/
run;
proc sort;
	by subjid date;
run;
data tu2;
	set tu1;
	by subjid date;
	if last.subjid;
run;
proc sql;
	create table DSTU as 
	select /*a.merge_datetime,*/ a.SUBJID,a.DSDECOD,/*b.TULNKID_TARGET,*/ b.TRSPID, b.TRDAT,b.date
	from DS a left join TU2 b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID; 
quit;
data fin;
	set dstu;
	current = today();
	format current date9.;
	if date ne . then diff = current - date;
	if diff gt 49;
run;

proc sql;
	create table TU219 as 
	select /*merge_datetime,*/SUBJID,DSDECOD,/*TULNKID_TARGET,*/TRSPID,TRDAT
	from fin 
/*	where datepart(MERGE_DATETIME) > input("&date", ? Date9.) */
	order by SUBJID,DSDECOD,/*TULNKID_TARGET,*/TRSPID;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print TU219*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Target Tumor Identification and Results";
title2 "Look for missing tumor data for patients who have not died/Lost to Follow-up and don't have objective Progressive Disease reported and haven't had a scan within 42 (+/- 7) days since their last scan";
  proc print data=TU219 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU219 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
