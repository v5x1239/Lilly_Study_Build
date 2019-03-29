/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : If the same Therapy is recorded in several entries, at least one item of the records must be different from each other..
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : DS1001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Sushil kumar     Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/


proc Sql;
	Create table DS003 as Select
	/*strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,*/
	SUBJID,
	BLOCKID,
	DSSTDAT,
	DSDECOD,
	DSCAT1,
	DSSCAT

	from (select * from clntrial.DS1001 where strip(upcase(DSSCAT)) in ('TREATMENT DISPOSITION' 'STUDY DISPOSITION'))

	group by SUBJID, DSSCAT

	having count(DSSCAT) GE 2 /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/
	
;

quit;



ods csv file=&irfilcsv trantab=ascii;
  title1 "One summary date/record must exist for every patient, unless";
	title2 "the trial is designed with study periods that require other summaries.";

proc print data=DS003 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS003 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
