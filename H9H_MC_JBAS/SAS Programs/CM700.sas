/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM700.sas
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

proc sort data = clntrial.cm1001 out = cm1001;
	by subjid cmdecod CMSTDAT;
run;

data cm700a;
	set cm1001;
	by subjid cmdecod CMSTDAT;
	if (first.cmdecod and last.cmdecod) then delete;
	if cmdecod ne '';
run;

proc sort data = cm700a;
	by subjid cmdecod CMSTDAT;

data cm700 (KEEP = SUBJID cmdecod CMSTDAT CMENDAT prev_edt);
	set cm700a;
	by subjid cmdecod CMSTDAT;
	prev_edt=lag(CMENDAT);
    	if first.cmdecod then prev_edt= .; 
	if CMSTDAT lt prev_edt;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "No identical terms with duplicate and overlapping dates can be recorded";
  proc print data=CM700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CM700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
