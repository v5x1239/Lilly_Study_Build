/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE027.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Events within the same AEGRPID must have a change in Severity or in Seriousness  in consecutive chronologic entries.
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
	create table AE027 as 
	select distinct a.MERGE_DATETIME, a.subjid,a.AEGRPID,a.AETERM, a.AEDECOD, b.AESER
			from clntrial.AE4_D as a left join clntrial.AE4001B as b
					on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
	group by a.subjid, a.AEGRPID
	having count (AEGRPID) gt 1;
quit;

data AE027 ;
	set AE027 ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;


/*Print AE027*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Events within the same AEGRPID must have a change in Severity";
	title2 " or in Seriousness  in consecutive chronologic entries.";

proc print data=AE027 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE027 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




