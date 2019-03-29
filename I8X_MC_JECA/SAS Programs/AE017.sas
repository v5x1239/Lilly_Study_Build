/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE017.sas
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
		SUBJID, AETERM, AEGRPID, AEDECOD /*, strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME*/

	From Clntrial.AE_DUMP

	Group by SUBJID, AEDECOD

	Having count(AEDECOD) GE 2

	order by SUBJID, AEGRPID, AEDECOD
;
	Create Table AE017 as Select

	/*MERGE_DATETIME,*/ SUBJID, AETERM, AEGRPID, AEDECOD

	From AE

	Group By AEGRPID

	Having Count(AEGRPID) GE 2 /*and (input(MERGE_DATETIME,Date9.) > input("&date",Date9.))*/

	Order by SUBJID, AEGRPID, AEDECOD
;
Quit;


ods csv file=&irfilcsv trantab=ascii;
  title1 "Events with the same AEGRPID must have";
	title2 "the same AEDECOD (Preferred Term) across the study";

proc print data=AE017 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE017 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

