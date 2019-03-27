/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE072.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : When patient died, all Adverse Events must have a stop date prior to the death date OR checked YES, except the Adverse Event, indicated as the cause of death.
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
	order by a.subjid,	a.AEGRPID,b.AESTDAT;
quit;

proc sql;
	create table AE072 as 
	select distinct a.MERGE_DATETIME, A.subjid, a.AEGRPID,a.AETERM, a.AEDECOD,a.AEENDAT, a.AESDTH, b.DSDECOD,b.DTHDAT
		from AE015a_ as A left join clntrial.DS1001 as b
		on a.subjid=b.subjid
		where b.DSDECOD='DEATH' and datepart(MERGE_DATETIME) > input("&date",Date9.);
quit;


/*Print AE072*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "When patient died, all Adverse Events must have a stop date";
	title2 "prior to the death date OR checked YES, except the";
	title2 "Adverse Event, indicated as the cause of death.";

proc print data=AE072 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE072 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




