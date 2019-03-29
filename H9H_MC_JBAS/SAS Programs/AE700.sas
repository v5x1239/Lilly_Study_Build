/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE700.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for duplicate lab/ECG data.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : If an AE ID is recorded on there, then that AE must be on the AE page and should have a start date < Cycle 2 date
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AESTEX1001 
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
/*AE700*/

/*Add code here*/

proc sql;
	create table AE as 
	select a.subjid, a.aegrpid, a.aeterm,  b.AESTDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;
	quit;

proc sort data=clntrial.AESTEX10 (KEEP=SUBJID BLOCKID AESTEXID AEGRPID) out=aetex;
by subjid aegrpid;
run;


proc sort data=ae;
by subjid aegrpid;
run;


data aes;
	merge aetex (in=a where=(AESTEXID ne .)) ae (in=b);
	by subjid aegrpid;
	if a;
run;

data dov (KEEP = SUBJID VISDAT);
	set clntrial.SV1001;
	if blockid= 2;
run;

proc sort data=dov;
by subjid;
run;
proc sort data=aes;
by subjid;
run;

data AE700;
	merge aes (in=a) dov (in=b);
	if a;
	if AESTDAT ge VISDAT;
run;


/*Print AE700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If an AE ID is recorded on there, then that AE must";
title2 "be on the AE page and should have a start date < Cycle 2 date";
  proc print data=AE700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
