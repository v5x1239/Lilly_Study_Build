/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM008.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If the same Therapy is recorded in several entries, at least one item of the records must be different from each other.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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
	create table CM009 as 
	select distinct MERGE_DATETIME, subjid, CMSPID, CMTRT, CMTRADNM, CMSTDAT, CMONGO, CMENDAT
		from clntrial.CM1001_D
		group by  subjid,CMTRADNM
		having count (CMTRADNM) gt 1;
		
quit;
data cm009;	
set cm009;
if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;


/*Print CM008*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If the same Therapy is recorded in several entries, at least";
	title2 " one item of the records must be different from each other.";


proc print data=cm009 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set cm009 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




