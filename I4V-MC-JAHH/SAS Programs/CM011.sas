/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM011.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : If several Concomitant Therapy Forms, the therapy must be appropriately reported on each of them, 
									according to CRF instructions and Protocol specifications. (I.e.- specific CRF for Psychotropic, Stimulants …).
									During Lilly review - please provide values for this check
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 11
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001 CMSI1001
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


proc sort data=clntrial.CMSI1A out= CMSI1001A;
	by SUBJID BLOCKID BLOCKRPT;
run;

proc sort data=clntrial.CMSI1B out= CMSI1001B;
	by SUBJID BLOCKID BLOCKRPT;
run;

proc sql;
	create table CMSI1001 as select /*a.MERGE_DATETIME,*/ a.SUBJID, a.CMGRPID, a.CMTRT, CMSPID, CMSTDAT, CMONGO, CMENDAT, a.PAGE

	from CMSI1001A as a left join CMSI1001B as b

	on a.SUBJID eq b.SUBJID and a.CMGRPID eq b.CMGRPID
;
quit;

data CM;
	set CM1001 CMSI1001;
run;	

proc sql;
	create table CM011 as select distinct
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
  title1 "If several Concomitant Therapy Forms, the therapy must be appropriately reported on each of them,";
title2 "according to CRF instructions and Protocol specifications. (I.e.- specific CRF for Psychotropic, Stimulants …).";

  proc print data=CM011 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM011 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
