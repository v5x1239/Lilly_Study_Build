/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : IWRS700.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : For SF, ensure IWRS does not indicate that study drug was dispensed. If dispensed, query site to verify no drug was given to patient.  Alert study team and IWRS if dispensing via the system occurred but patient not treated.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IVRS
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

data ds1001;
	set clntrial.DS1001;
	if DSDECOD='SCREEN FAILURE';
run;

data IWRS700 (KEEP=subjid message);
	merge DS1001 (in=a keep=subjid) clntrial.IVRSTSA (in=b keep=subjid) ; 
	if a and b;
	message='For SF, study drug was dispensed';
run;

proc sort data=IWRS700 noduprecs;
by subjid;
run;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For SF, ensure IWRS does not indicate that study drug was dispensed.";
title2 "If dispensed, query site to verify no drug was given to patient.";
title3 "Alert study team and IWRS if dispensing via the system occurred";
title4 "but patient not treated.";
  proc print data=IWRS700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set IWRS700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
