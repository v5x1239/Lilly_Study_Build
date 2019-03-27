/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE026.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If DS reason for discontinuation is 'Death', Death Date must be equal to the End Date of the Fatal Event. (AESDTH='YES')
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
	select distinct a.MERGE_DATETIME, a.subjid,a.AEGRPID,a.AETERM, a.AEDECOD, a.AELLT, b.AESTDAT, b.AEENDAT, b.AESDTH
			from clntrial.AE4_D as a left join clntrial.AE4001B as b
					on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
					where b.AESDTH='Y'
	order by a.subjid,	a.AEGRPID,b.AESTDAT;
quit;

proc sql;
	create table AE026 as 
	select distinct a.MERGE_DATETIME, A.subjid, a.AEGRPID,a.AETERM, a.AEDECOD,a.AESTDAT,a.AEENDAT, a.AESDTH, b.DTHDAT
		from AE015a_ as A lef join clntrial.DS1001 as b
		on a.subjid=b.subjid
		where datepart (AEENDAT) ne datepart (DTHDAT);
quit;

data AE026 ;
	set AE026 ;
	if datepart(MERGE_DATETIME) > input("&date",Date9.);
run ;

/*Print AE026*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If DS reason for discontinuation is 'Death', Death Date must";
	title2 "be equal to the End Date of the Fatal Event. (AESDTH='YES')";

proc print data=AE026 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE026 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




