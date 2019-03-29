/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM009.sas
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
DATA INPUT                        : CM1001
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


data dm;
set clntrial.DM1001C;
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
proc sort data=clntrial.CM1001 out= CM1001;
	by SUBJID BLOCKID BLOCKRPT;
	where not missing(CMTRADNM);
run;

proc sql;
	create table CM as select /*MERGE_DATETIME,*/ SUBJID, CMSPID, CMTRT, CMTRADNM, CMSTDAT, CMONGO, CMENDAT

	from CM1001

	group by SUBJID, CMTRT, CMTRADNM

	having count(CMTRADNM) GE 2
;
quit;

proc sort data=CM;
	by SUBJID CMTRADNM CMSTDAT CMENDAT;
run;

data CM_SEQ;
	set CM;
		by  SUBJID CMTRADNM CMSTDAT CMENDAT;
		 if first.CMTRADNM then SEQ=1;
		 	else SEQ+1;
run;

proc sql;
	create table CM_LAP as select a.*, b.CMSTDAT as CMST, b.CMENDAT as CMED,
	(case
		when datepart(a.CMSTDAT) between datepart(b.CMSTDAT) and datepart(b.CMENDAT) then 1
		else .
	end) as Flag

	from CM_SEQ as a left join CM_SEQ as b

	on a.SUBJID eq b.SUBJID and a.CMTRADNM eq b.CMTRADNM and a.SEQ eq (b.seq+1)
;
quit;

proc sql;
	create table CM0091 as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SUBJID,
	CMSPID,
	CMTRT,
	CMTRADNM,
	datepart(CMSTDAT) as CMSTDAT format =date9.,
	CMONGO,
	datepart(CMENDAT) as CMENDAT format =date9.

	from CM_LAP

	/*where Flag eq 1 and datepart(MERGE_DATETIME) > input("&date",Date9.))*/

	order by SUBJID, CMSPID, CMTRADNM, CMSTDAT, CMENDAT
;
quit;
data cm009;
retain SITEMNEMONIC SUBJID;
merge cm0091(in = a) dm;
by subjid;
if a;
run;


/*Print VS011*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If the same Therapy is recorded in several entries,";
title2 "at least one item of the records must be different from each other.";

  proc print data=CM009 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM009 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
