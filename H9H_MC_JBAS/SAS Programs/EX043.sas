/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX043.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If reason dose adjusted is an adverse event, AE Group ID must match with an existing Group ID in the AE CRF
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
	create table EX043a as 
	select a.subjid, a.blockid, a.page, a.exspid, a.exTRT, a.exSTDAT, a.exadj, a.AEGRPREL, b.aegrpid, b.aeterm,  b.AESTDAT, b.AEENDAT
	from clntrial.ex1001 as a, ae as b
	where a.subjid=b.subjid;
	quit;

data ex04b ex04c;
	set ex043a;
	if AEGRPREL ne .;
	if AEGRPREL = aegrpid then output ex04b;
	if AEGRPREL ne aegrpid then output ex04c;
run;

proc sort data=ex04b;
	by subjid;
run;

proc sort data=ex04c;
	by subjid;
run;

data EX043;
	merge ex04c (in=a) ex04b (in=b);
	by subjid;
	if a and not b;
run;





/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If reason dose adjusted is an adverse event, AE Group ID must match"; 
  title2 "with an existing Group ID in the AE CRF";
  proc print data=EX043 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX043 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
