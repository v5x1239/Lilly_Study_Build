/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM010A.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : If the same Therapy is recorded in Prior Therapy CRF (E.g.- CM2001), Prior Therapy's End Date must be < CM Start Date.
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001 CM2001
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


proc sort data=clntrial.CM1001 out= CM1001;
	by SUBJID BLOCKID BLOCKRPT;
	where not missing(CMTRT);
run;

proc sort data=clntrial.CM2001 out= CM2001;
	by SUBJID BLOCKID BLOCKRPT;
	where not missing(CMTRT);
run;

data CM;
	set CM1001 CM2001;
run;	

proc sql;
	create table CM010A as select 
/*	strip(put(datepart(MERGE_DATETIME),date9.)) as MERGE_DATETIME,*/
	SUBJID,
	PAGE,
	CMSPID,
	CMTRT,
	datepart(CMSTDAT) as CMSTDAT format =date9.,
	CMONGO,
	datepart(CMENDAT) as CMENDAT format =date9.

	from CM

/*	where (input(MERGE_DATETIME,Date9.) > input("&date",Date9.))*/

	order by SUBJID, CMSPID, CMSTDAT, CMENDAT
;
quit;


/*Print VS011*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If the same Therapy is recorded in Prior Therapy CRF ";
title2 "(E.g.- CM2001), Prior Therapy's End Date must be < CM Start Date.";

  proc print data=CM010A noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM010A nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
