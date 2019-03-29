/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM025.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : CONDITIONAL - IF DEEMED CRITICAL FOR ANALYSIS:  If Adverse Event and an AE group ID are selected and the group ID entered matches an AE group ID in the study Adverse Events CRF, then the start date of the associated event must be >= medication's start date.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required � study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : mh8001_f1
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

proc sql;
	create table AE as 
	select a.subjid, a.aegrpid, a.aeterm,  b.AESTDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;
	quit;
proc sql;
	create table CM025 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMINDC, a.CMAEGID, b.aegrpid, b.aeterm,  b.AESTDAT
	from clntrial.cm1001 as a, ae as b
	where a.subjid=b.subjid and a.CMAEGID= b.aegrpid and b.AESTDAT lt a.CMSTDAT;
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "CONDITIONAL - IF DEEMED CRITICAL FOR ANALYSIS:  If Adverse Event and an AE group ID are selected and the group ID entered matches an AE group ID in the study Adverse Events CRF,";
  title2 "then the start date of the associated event must be >= medication's start date.";
  proc print data=CM025 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM025 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
