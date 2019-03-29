/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE701.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If 'Not Applicable', is selected for Action Taken with study Treatment, the AE Start Date must be >= V6
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
proc sort data=clntrial.ae_dump (DROP=BLOCKID) out=ae;
	where AEACN= 'Not Applicable';
	by subjid;
run;
proc sort data=clntrial.SV1001 (KEEP=subjid BLOCKID VISDAT) out=sv;
	by subjid;
run;

data AE701 (KEEP=merge_datetime SUBJID AEGRIPID AETERM AEDECOD AESTDAT AEACN BLOCKID VISDAT);
	merge ae (in=a) sv (in=b);
	by SUBJID;
	if a;
	if BLOCKID ge 6;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);

run;

	


/*Print AE701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'Not Applicable', is selected for Action Taken";
title2 "with study Treatment, the AE Start Date must be >= V6";
  proc print data=AE701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
