/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : LSXX.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Ensure measurements at Visit 0 (baseline) meet target vs. non-target criteria.

SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : TU2001, TU5001,TU3001, TU6001      
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
/*LSXX*/

proc sort data=clntrial.TU2001B (KEEP=SUBJID) out=LSXX;
	by subjid;
run;



/*Print LSXX*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure measurements at Visit 0 (baseline) meet target vs. non-target criteria.";
  proc print data=LSXX noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set LSXX nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
