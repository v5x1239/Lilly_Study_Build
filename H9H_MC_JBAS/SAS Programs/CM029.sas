/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM029.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : CONDITIONAL - IF DEEMED CRITICAL FOR ANALYSIS:  If 'Adverse Event' is selected as Indication, and the AE Group ID entered matches an AE Group ID in Study Adverse Events CRF, then the start date of the medication must be <= the end date of the associated Event ID.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
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
	select a.subjid, a.aegrpid, a.aeterm,  b.AESTDAT, b.AEENDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;
	quit;
proc sql;
	create table CM029 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMINDC, a.CMAEGID, b.aegrpid, b.aeterm,  b.AESTDAT, b.AEENDAT
	from clntrial.cm1001 as a, ae as b
	where a.subjid=b.subjid and a.CMAEGID= b.aegrpid and b.AEENDAT ne . and b.AEENDAT lt a.CMSTDAT;
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Adverse Event' is selected as Indication, and the AE Group ID";
title2 "entered matches an AE Group ID in Study Adverse Events CRF, then";
title3 "the start date of the medication must be <= the end date of the"; 
title4 "associated Event ID.";
  proc print data=CM029 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM029 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
