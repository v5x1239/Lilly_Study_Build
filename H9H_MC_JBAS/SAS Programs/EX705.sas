/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX705.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : For dose reductions, ensure dose is reduced per protocol.  If reduced incorrectly, query to verify reduction.  Alert monitor to any incorrect dose reduction by site.
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
	by subjid extrt blockid exspid;
run;

data EX705;
	set ex1;
	by subjid extrt blockid exspid;
	prev_dos= lag (EXDOSE);
	if first.extrt then prev_dos=.;
	if EXDOSE ne . or prev_dos ne .;
	if EXDOSE lt PREV_DOS;
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For dose reductions, ensure dose is reduced per protocol.";
title2 "If reduced incorrectly, query to verify reduction.";
title3 "Alert monitor to any incorrect dose reduction by site."; 
  proc print data=EX705 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX705 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
