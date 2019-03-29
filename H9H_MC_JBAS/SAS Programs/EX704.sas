/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX704.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : For dose adjustments due to AE, ensure AE is logical for causing the dose adjustment.
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
	create table EX704 as 
	select a.subjid, a.blockid, a.page, a.exspid, a.exTRT, a.exSTDAT, a.exadj, a.AEGRPREL, b.aegrpid, b.aeterm,  b.AESTDAT, b.AEENDAT
	from clntrial.ex1001 as a, ae as b
	where a.subjid=b.subjid and a.AEGRPREL=b.aegrpid;
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For dose adjustments due to AE, ensure AE is logical for causing the dose adjustment"; 
  proc print data=EX704 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX704 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
