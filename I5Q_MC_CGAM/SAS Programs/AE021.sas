/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE021.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If identical term is recorded on AE and MH CRFs, start dates must not match
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
data ae;
	set clntrial.ae_dump;
	term=strip(AETERM);
run;
data mh;
	set clntrial.MH7001_D;
	term=strip(MHTERM);
run;
proc sort data=ae;
	by SUBJID term;
run;
proc sort data=mh;
	by SUBJID term;
run;
data ae021 (KEEP=merge_datetime SUBJID AEGRPID AETERM AEDECOD MHTERM MHDECOD);
	merge ae (in=a) mh (in=b);
	by SUBJID term;
	if a and b;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

	


/*Print AE021*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If identical term is recorded on AE and MH CRFs,";
title2 "start dates must not match";
  proc print data=AE021 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE021 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
