/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EC020.sas
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
DATA INPUT                        : EC1001
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


proc sql;
	create table EC1001 as select
	SUBJID,
	BLOCKID,
	ECSPID,
	ECTRT,
	datepart(ECSTDAT) as ECSTDAT,
	datepart(ECENDAT) as ECENDAT	

	from clntrial.EC1001

	order by SUBJID, ECSPID
;
quit;

data EC_SEQ;
	set EC1001;
	by SUBJID ECSPID ECSTDAT ECENDAT;
	PRE_ECENDAT= lag(ECENDAT);
	if first.SUBJID then PRE_ECENDAT=.;
run;

proc Sql;
	Create table EC020 as Select
	/*strip(Put(Datepart(MERGE_DATETIME),Date9.)) as MERGE_DATETIME,*/
	SUBJID,
	BLOCKID,
	ECSPID,
	ECTRT,
	ECSTDAT Format = date9.,
	ECENDAT Format = date9.

	from EC_SEQ

	where ECSTDAT LE PRE_ECENDAT /*and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, ECSPID
	
;

quit;



ods csv file=&irfilcsv trantab=ascii;
  title1 "For the same treatment name, consecutive";
	title2 "entries must be detected across the CRF";

proc print data=EC020 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EC020 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
