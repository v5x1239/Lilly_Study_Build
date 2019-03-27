/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU003.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Look for non Screen Failure patients with no tumor data recorded, but have a Visit 0 present.
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
	create table TU003 as 
	select distinct b.MERGE_DATETIME, A.subjid, b.TULNKID_NEW as TULNKID, 
	'Non Screen Failure patients with no tumor data recorded - TU1001' as Message
		from clntrial.DM1001 as A, clntrial.TU1001_D as B
		where missing (b.TULNKID_NEW)
		union
	select distinct b.MERGE_DATETIME, A.subjid, b.TULNKID_TARGET as TULNKID, 
	'Non Screen Failure patients with no tumor data recorded - TU2001' as Message
		from clntrial.DM1001 as A, clntrial.TU2001_D as B
		where missing (b.TULNKID_TARGET)
			union
	select distinct b.MERGE_DATETIME, A.subjid, b.TULNKID_NONTARGET as TULNKID, 
	'Non Screen Failure patients with no tumor data recorded - TU3001' as Message
		from clntrial.DM1001 as A, clntrial.TU3001_D as B
		where missing (b.TULNKID_NONTARGET)
		union
	select distinct b.MERGE_DATETIME, A.subjid, put(b.RSSPID, best.) as TULNKID, 
	'Non Screen Failure patients with no tumor data recorded - RS1001' as Message
		from clntrial.DM1001 as A, clntrial.RS1001_D as B
		where missing (b.RSSPID)
		order by subjid;
quit;

data TU003;
set TU003;
if datepart(MERGE_DATETIME) > input("&date",Date9.);
run;

/*Print TU003*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Look for non Screen Failure patients with no tumor data";
	title2 " recorded, but have a Visit 0 present.";

proc print data=TU003 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU003 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




