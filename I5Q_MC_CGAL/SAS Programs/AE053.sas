/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE053.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If 'Drug Withdrawn' the Treatment End Date must be >= Event's Start Date. 
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
proc sort data=clntrial.ae_dump (keep=merge_datetime SUBJID AEGRPID AETERM AEDECOD AESTDAT AEACN) out=ae;
	by SUBJID;

run;
proc sort data=clntrial.EX1001_D (keep=SUBJID EXSTDAT) out=ex;
	by SUBJID;
run;

data AE053;
	merge ae (in=a) ex (in=b);
	by SUBJID ;
	if a;
	if AEACN='Drug Withdrawn';
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

/*Print AE053*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Drug Withdrawn'  the Treatment End Date";
title2 " must be >= Event's Start Date.";
  proc print data=AE053 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE053 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
