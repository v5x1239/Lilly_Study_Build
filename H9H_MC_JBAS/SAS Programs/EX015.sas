/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX015.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : For the same treatment name, consecutive entries must be detected across the CRF. i.e.- start date of the second entry must be at least 1 day after the end date of the previous entry.
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


proc sort data=clntrial.ex1001 (where=(page in ('EX1001_F7', 'EX1001_F13')))  out=ex015a;
	by subjid extrt blockid exspid exstdat;
run;

data ex015 (DROP=prev_en);
	set ex015a;
	by subjid extrt blockid exspid exstdat;
	prev_en= lag(exendat);
	if first.extrt then prev_en= .;
	if exstdat le prev_en;
run;




/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "For the same treatment name, consecutive entries must be detected across the CRF.";
title2 "i.e.- start date of the second entry must be at least";
title3 "1 day after the end date of the previous entry.";
  proc print data=EX015 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX015 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
