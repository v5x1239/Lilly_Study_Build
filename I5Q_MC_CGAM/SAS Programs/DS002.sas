/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS002.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Final Visits Date where DSSCAT = Study Disposition (excluding DS_HEPSUM) >= visit dates appropriate for the  Disposition Event Period.  Ensure that there are no visits after the summary (with the exception of post-study follow-up visits) and no visits after post-study follow-up summary.  Include screen failures and lost to follow-ups.
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
	create table DS002 as
	select a.*, b.VISDAT, b.BLOCKID
	from (select a.merge_datetime, a.SUBJID, a.BLOCKID, b.VISDAT
		from (select * from clntrial.DS1_DUMP where upcase (DSSCAT) = 'STUDY DISPOSITION') a inner join clntrial.sv_dump b
	on a.SUBJID=b.SUBJID and a.blockid=b.blockid) a inner join clntrial.sv_dump b
	on a.SUBJID=b.SUBJID
	where a.VISDAT lt b.VISDAT and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by a.SUBJID;
quit;



	


/*Print DS002*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Final Visits Date where DSSCAT = Study Disposition (excluding DS_HEPSUM) >=";
  title2 "visit dates appropriate for the  Disposition Event Period.  Ensure that";
  title3 "there are no visits after the summary (with the exception of post-study";
  title4 "follow-up visits) and no visits after post-study follow-up summary.";
  title5 "Include screen failures and lost to follow-ups.";
title2 "can be recorded";
  proc print data=DS002 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS002 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
