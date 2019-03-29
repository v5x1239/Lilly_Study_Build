/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DA043.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : Returned date must be greater than or equal to dispense date in same visit.
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8X_MC_JECA;*/


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/


proc Sql;
	Create table DA001A as Select
	SUBJID, BLOCKID, BLOCKRPT, PAGE, PAGERPT, DASPID, datepart(DADAT_DIS) as DADAT_DIS
	from clntrial.DA1001
	where strip(upcase(PAGE)) in ('DA1001_LF1') 
	order by subjid, blockid, DASPID
;

	Create table DA001B as Select
	SUBJID,BLOCKID, BLOCKRPT, PAGE, PAGERPT, DASPID, datepart(DADAT_RET) as DADAT_RET
	from clntrial.DA1001
	where strip(upcase(PAGE)) in ('DA1001_LF2')
	order by subjid, blockid, DASPID
;
	Create table dm as Select
	SITEMNEMONIC, SUBJID
	from clntrial.Dm1001c
	order by subjid
;
quit;
data da;
	merge da001a(in = a) da001b(in = b);
	by subjid blockid DASPID;
	if a and b;
run;
data da1;
	merge da(in = a) dm;
	by subjid;
	if a;
run;
proc sql;
	Create table DA043 as Select
	SITEMNEMONIC,
	SUBJID, 
	BLOCKID,
	DASPID,
	DADAT_DIS Format=date9.,
	DADAT_RET Format=date9.
	from DA1
	where DADAT_DIS GE DADAT_RET 
	
;

quit;



ods csv file=&irfilcsv trantab=ascii;
  title1 "Returned date must be greater than or equal to dispense date in same visit.";

proc print data=DA043 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DA043 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
