/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM009.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : CONDITIONAL - IF APPLICABLE DEEMED CRITICAL FOR ANALYSIS: If the same Therapy is recorded in several entries, at least one item of the records must be different from each other.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM1001
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
/*CM009*/

/*Add code here*/

proc sort data = clntrial.cm1001 out = cm1001;
	by subjid cmdecod CMSTDAT;
run;
 
data CM009;
	set cm1001;
	by subjid cmdecod CMSTDAT;
	if (first.cmdecod and last.cmdecod) then delete;
	if cmdecod ne '';
run;

proc sort data = CM009;
	by subjid cmdecod CMSTDAT;
run;

data CM009;
	set CM009;
	by subjid cmdecod CMSTDAT;
	prev_edt=lag(CMENDAT);
    	if first.cmdecod then prev_edt= .; 
	if CMSTDAT lt prev_edt;
run;

data CM009 (KEEP = SUBJID CMTERM cmdecod CMSTDAT CMENDAT prev_edt);
	retain SUBJID CMTERM cmdecod CMSTDAT CMENDAT prev_edt;
	set CM009;
run;

/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "CONDITIONAL - IF APPLICABLE DEEMED CRITICAL FOR ANALYSIS: If the same Therapy is recorded in several entries, at least one item of the records must be different from each other.";
  proc print data=CM009 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM009 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

