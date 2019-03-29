/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX700.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Ensure first dose date of study therapy is >= Randomization date from IWRS.
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
proc sort data=clntrial.ex1001 out=ex1;
	by subjid exstdat;
run;

data ex2;
	set ex1;
	by subjid exstdat;
	if first.subjid;
run;

data ivrs;
	set clntrial.SBJCTSTS (KEEP=SUBJID RNDDTTXT);
run;

proc sort data=IVRS;
	by subjid;
run;

proc sort data=ex2;
	by subjid;
run;

data ex700;
	merge ex2 (in=a) IVRS (in=b);
	by subjid;
	if a;
	if exstdat ne . and RNDDTTXT ne .;
	if exstdat lt RNDDTTXT;
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure first dose date of study therapy is >= Randomization date from IWRS."; 
  proc print data=EX700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
