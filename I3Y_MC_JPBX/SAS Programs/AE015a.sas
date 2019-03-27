/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE015a.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Entries within the same event (AEGRPID) must have consecutive gapless durations:Start Date second chronologic entry= End Date previous chronologic entry.
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
	create table AE015a_ as 
	select distinct a.MERGE_DATETIME, a.subjid,a.AEGRPID,a.AETERM, a.AEDECOD, b.AESTDAT, b.AEENDAT
			from clntrial.AE4_D as a left join clntrial.AE4001B as b
					on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
	order by a.subjid,	a.AEGRPID,b.AESTDAT;
quit;
data AE015a;
	set AE015a_;
	by subjid AEGRPID AESTDAT;
	prev_dt=lag (AEENDAT);
	if first.subjid then prev_dt=.;
	if AESTDAT=prev_dt;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;


/*Print AE015a*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Entries within the same event (AEGRPID) must have consecutive";
  title2 "gapless durations: Start Date second chronologic entry= End Date";
  title3 " previous chronologic entry.";

proc print data=AE015a noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE015a nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




