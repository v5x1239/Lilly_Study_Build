/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM009.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : If the same Therapy is recorded in several entries, at least one item of the records must be different from each other.
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
	create table CM009 (DROP=count) as
	select merge_datetime,SUBJID, CMSPID, CMTRT, CMTRADNM, CMSTDAT, CMONGO, CMENDAT, count(*) as Count
	from clntrial.CM1001_d
	group by SUBJID, CMTRADNM
	having count > 1;
quit;


/*Print CM009*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If the same Therapy is recorded in several entries,";
title2 "at least one item of the records must be different from each other.";
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
