/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU005.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If any Tumor Number & Location have been entered, at least one Tumor Assessment Entry must be present.
If no Tumor Assessment was entered, a query will be generated.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Add code here*/
proc sql;
	create table TU005 as 
	select distinct MERGE_DATETIME, subjid, TULNKID_NEW as TULNKID, 
	'Tumor Assessment Entry is missing-TU1001' as Message
		from clntrial.TU1001_D 
		where missing (TRSPID)
		union
	select distinct MERGE_DATETIME, subjid, TULNKID_TARGET as TULNKID, 
	'Tumor Assessment Entry is missing-TU2001' as Message
		from clntrial.TU2001_D 
		where missing (TRSPID)
			union
	select distinct MERGE_DATETIME, subjid, TULNKID_NONTARGET as TULNKID, 
	'Tumor Assessment Entry is missing-TU3001' as Message
		from clntrial.TU3001_D 
		where missing (TRSPID)
		order by subjid;
quit;
data TU005;
set TU005;
if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

/*Print TU005*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If any Tumor Number & Location have been entered, at";
title2 "least one Tumor Assessment Entry must be present. If no Tumor";
title3 "Assessment was entered, a query will be generated.";
	

proc print data=TU005 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU005 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




