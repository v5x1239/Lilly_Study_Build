/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM021.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If Ongoing 'YES' and indication reported is Adverse Event, the End Date of the Adverse Event (AEGRPID) must also be 'Ongoing'.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001_f1
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
	select a.subjid, a.aegrpid, a.aeterm,  b.AESTDAT, b.AEENDAT, b.AEONGO
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= input (b.aegrpid, 8.);
	quit;

data cm;
	set clntrial.cm1001;
	if CMONGO = 'Y' and CMINDC = 'ADVERSE EVENT';
run;

proc sql;
	create table CM021 as 
	select a.subjid, a.cmspid, a.CMTRT, a.CMSTDAT, a.CMENDAT, a.cmongo, a.CMINDC, a.CMAEGID, b.aegrpid, b.aeterm,  b.AESTDAT, b.AEENDAT, b.AEONGO
	from cm as a, ae as b
	where a.subjid=b.subjid and a.CMAEGID= b.aegrpid; *and b.AEONGO ne 'Y';
	quit;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Ongoing 'YES' and indication reported is Adverse Event, the End Date of the Adverse Event (AEGRPID) must also be 'Ongoing'. ";
  proc print data=CM021 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM021 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
