/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE027.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A, AE4001B
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Sushil Kumar     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Proc Sql;
	Create Table AE as Select

		A.SUBJID, A.AEGRPID,A.AESPID, A.AETERM, A.AEDECOD, A.AETOXGR, A.AESER /*,
		strip(Put(Datepart(A.MERGE_DATETIME),Date9.)) as MERGE_DATETIME*/

	From Clntrial.AE_DUMP as A 
;

create table ae1 as select a.*,b.SITEMNEMONIC from ae as a left join clntrial.DM1001c as b

	on a.SUBJID eq b.SUBJID 
	
;


	Create Table AE027 as Select

		/*MERGE_DATETIME,*/ SITEMNEMONIC,SUBJID, AEGRPID, AESPID,AETERM, AEDECOD, AETOXGR, AESER

	From AE1

	Group By SUBJID, AEGRPID

	Having Count(AEGRPID) GE 2 /*and (input(MERGE_DATETIME,Date9.) > input("&date",Date9.))*/

	Order by SUBJID, AEGRPID
;
Quit;


ods csv file=&irfilcsv trantab=ascii;
  title1 "Events within the same AEGRPID must have a change in";
  	title "Severity or in Seriousness  in consecutive chronologic entries";

proc print data=AE027 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE027 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

