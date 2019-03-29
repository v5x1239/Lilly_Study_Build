/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : One summary date/record must exist for every patient, unless the trial 
									is designed with study periods that require other summaries.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : DS1001, DS2001
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

proc Sql;
	Create table DS1 as 

	(Select 
	Coalesce(A.MERGE_DATETIME,B.MERGE_DATETIME) as MERGE_DATETIME,
	Coalesce(a.SUBJID,b.SUBJID) as SUBJID,
	Coalesce(a.BLOCKID,b.BLOCKID) as BLOCKID,
	DSSTDAT,
	'SUBJID is present in DS2001; but not in DS1001' as FLAG

	from Clntrial.DS1001 as A full Join Clntrial.DS2001 as b

	on A.SUBJID eq B.SUBJID 

	where B.SUBJID is null)

	Outer union corr

	(select 
		A.MERGE_DATETIME,
		A.SUBJID,
		A.BLOCKID, 
		A.DSSTDAT,
		'SUBJID has more than one DSSTDAT in DS1001' as FLAG2

	from clntrial.DS1_DUMP a

	group by SUBJID

	having count(DSSTDAT) GE 2)

	order by SUBJID, BLOCKID

;
	Create Table DS003 as Select
		strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,
		SUBJID,
		BLOCKID,
		DSSTDAT,
		FLAG,
		FLAG2

		from DS1

		where Datepart(MERGE_DATETIME) > input("&date",Date9.)

		order by SUBJID, BLOCKID

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

