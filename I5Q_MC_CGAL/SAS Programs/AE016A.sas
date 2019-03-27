/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE016A.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If identical term is recorded on AE and MH CRFs, start dates must not match
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
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

*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I5Q_MC_CGAL;

data ae;
set clntrial.ae_dump;
AESTDAT1 = datepart(AESTDAT);
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AETERM AEDECOD AELLT AESTDAT1 AEENDAT1;
run;
proc sort;
by AELLT AEGRPID AESTDAT1 AEENDAT1;
run;
data lag;
set ae;
by AELLT AEGRPID AESTDAT1 AEENDAT1;
llt = lag(AELLT);
prid = lag(AEGRPID);
Sartdt_lag = lag(AESTDAT1);
Stopdt_lag = lag(AEENDAT1);
format Sartdt_lag Stopdt_lag date9.;
run;
Data fin;
	set lag;
	length flag $20.;
	if llt eq AELLT and prid ne AEGRPID 
	and (((AESTDAT1 ne . and Sartdt_lag ne .) and (AESTDAT1 ge Sartdt_lag)
	and (AESTDAT1 ne . and  Stopdt_lag ne . and AESTDAT1 le Stopdt_lag))
	or 
	(((AEENDAT1 ne . and Sartdt_lag ne . ) and (AEENDAT1 ge Sartdt_lag)) and 
	((AEENDAT1 ne . and Stopdt_lag ne . ) and (AEENDAT1 le Stopdt_lag))
	or ((AESTDAT1 ne . and  Sartdt_lag ne .) and AESTDAT1 eq Sartdt_lag))) 
	then Flag = 'OVERLAPING';
	if llt eq AELLT and prid ne AEGRPID
	and AESTDAT1 eq Sartdt_lag  and AEENDAT1 ge Stopdt_lag then flag = 'DUPLICATE';
	Drop sublag PTNM_lag calAEID_lag Sartdt_lag Stopdt_lag;
Run;
data AE016A;
retain SUBJID AEGRPID AETERM AEDECOD AELLT AESTDAT AEENDAT;
set fin;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
format AESTDAT AEENDAT date9.;
keep SUBJID AEGRPID AETERM AEDECOD AELLT AESTDAT AEENDAT flag;
run;
	
/*Print AE016A*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Adverse Events";
title2 "Separate Events (different AE group IDs) with the same LLT term and the same or overlapping date, should be verified.";
  proc print data=AE016A noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE016A nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
