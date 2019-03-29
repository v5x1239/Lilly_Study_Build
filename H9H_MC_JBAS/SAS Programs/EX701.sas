/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX701.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If no doses are present for patient, ensure patient is either a SF or IIT. 
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
proc sort data=clntrial.dm1001 out=dm;
by subjid;
run;

proc sort data=clntrial.ex1001 out=ex1;
	by subjid;
run;

proc sort data=clntrial.DS1001 out=DS;
	by subjid;
run;

data ex1;
	merge ex1 (in=a) ds (in=b  keep= subjid DSSTDAT);
	by subjid;
	if page='DS1001_F1';
	if DSSTDAT = '';

data EX701;
	merge dm (in=a keep= subjid) ex1 (in=b);
	by subjid;
	if a and not b;
run;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If no doses are present for patient, ensure patient is either a SF or IIT."; 
  proc print data=EX701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
