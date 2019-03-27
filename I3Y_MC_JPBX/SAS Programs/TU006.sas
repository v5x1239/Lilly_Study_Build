/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU006.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Check there are NOT more than 2 tumors per organ are recorded in Target CRF.
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
	create table TU006 as 
	select distinct MERGE_DATETIME, subjid, TULNKID_NEW as TULNKID, TULOC ,
	'More than 2 tumors per organ-TU1001' as Message
		from clntrial.TU1001_D 
		group by subjid
		having count (TULOC) gt 2
		union
	select distinct MERGE_DATETIME, subjid, TULNKID_TARGET as TULNKID, TULOC,
	'More than 2 tumors per organ--TU2001' as Message
		from clntrial.TU2001_D 
		group by subjid
		having count (TULOC) gt 2
		
		order by subjid;
quit
data TU006 ;
	set TU006 ;
if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

/*Print TU006*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check there are NOT more than 2 tumors per";
title2 "organ are recorded in Target CRF.";

	

proc print data=TU006 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU006 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




