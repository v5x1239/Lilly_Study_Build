/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM030.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
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
	where a.subjid=b.subjid and a.aegrpid= input (b.aegrpid, 8.);
	quit;
proc sql;
	create table cm030 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMENDAT, a.CMINDC, a.CMAEGID, b.aegrpid, b.aeterm,  b.AESTDAT, b.AEENDAT
	from clntrial.cm1001 as a, ae as b
	where a.subjid=b.subjid and a.CMAEGID= b.aegrpid and a.CMENDAT gt (3+b.AEENDAT) ;
	quit;
/*data cm030;
	set cm;
	diff = datdif (AESTDAT, CMSTDAT, 'act\act');
	if diff gt 3;
run;*/

/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Adverse Event' is selected as Indication, and the AE Group ID entered matches an AE Group ID in Study Adverse Events CRF, then the end date of the medication must be <= 3 days after AE's End Date.";
  proc print data=CM030 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM030 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
