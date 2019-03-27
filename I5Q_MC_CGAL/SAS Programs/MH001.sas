/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH001.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If no is selected, then no past and/or concomitant diseases or past surgeries must be recorded.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
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

proc sort data=clntrial.MH7001_D (keep=SUBJID MHYN MHTERM MHDECOD MERGE_DATETIME)   out=MH7001;
	where MHYN eq 'N' and MHTERM ne '';
	by SUBJID;
run;


data MH001;
	set MH7001;
	message="No is selected, But past and/or concomitant diseases or past surgeries is recorded.";
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;
	


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If no is selected, then no past and/or concomitant";
  title2 "diseases or past surgeries must be recorded.";

  proc print data=MH001 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH001 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
