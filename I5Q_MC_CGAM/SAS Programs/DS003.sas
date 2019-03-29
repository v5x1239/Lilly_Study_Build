/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : One summary date/record must exist for every patient, unless the trial is designed with study periods that require other summaries.
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

/*Add code here*/
proc sql;
	create table ds003 as
	Select merge_datetime, SUBJID, BLOCKID, DSSCAT
	From clntrial.DS1_dump
	group by SUBJID, DSSCAT
	having count (DSSCAT) gt 1;
quit;

data ds003;
	set ds003;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;
	


/*Print DS003*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "One summary date/record must exist for every patient, unless";
 title2 "the trial is designed with study periods that require other summaries.";
  proc print data=DS003 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS003 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
