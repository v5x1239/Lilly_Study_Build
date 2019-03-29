/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EXCMP022.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : AE Group ID must match with an existing Group ID in the AE CRF
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
	select a.subjid, a.aegrpid, a.aeterm,  b.AESTDAT
	from clntrial.ae4001a as a, clntrial.ae4001b as b
	where a.subjid=b.subjid and a.aegrpid= b.aegrpid;
quit;

proc sort data=ae;
	by subjid aegrpid;
run;

data ex (keep=SUBJID BLOCKID PAGE EXSPID EXTRT ECSTDAT ECENDAT ECDOSE ECDOSEU ECREASOC AEGRPREL);
	set clntrial.ex1001 (Where = (page='EX1001_F25'));
run;

	
proc sort data = ex (rename = (AEGRPREL=aegrpid)); 
	by subjid aegrpid;
run;


data EXCMP022;
	merge ex (in=a) ae (in=b);
	by subjid aegrpid;
	if a and not b;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "AE Group ID must match with an existing Group ID in the AE CRF";


proc print data=EXCMP022 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EXCMP022 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
