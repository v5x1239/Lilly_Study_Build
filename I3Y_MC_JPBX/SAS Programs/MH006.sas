/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH006.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If identical term is entered in MH and AE forms that is not ongoing on the MH form, then the AE start date must be greater than 1 day after MH stop date 
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
	create table MH006 as 
	select distinct a.MERGE_DATETIME, A.subjid, A.MHTERM, a.MHDECOD,a.MHSTDAT, a.MHENDAT, b.AETERM,b.AEDECOD,b.AESTDAT
		from clntrial.mh8001_d as A left join (select a.subjid,a.AETERM, a.AEDECOD, b.AESTDAT 
					from clntrial.AE4001A as a left join clntrial.AE4001B as b
					on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID) b
		on a.subjid=b.subjid and a.MHDECOD=b.AEDECOD
		where not missing (AESTDAT) and not missing (MHENDAT) and datepart (AESTDAT) le datepart (MHENDAT);
quit;


/*Print MH006*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If identical term is entered in MH and AE forms that is not";
  title2 "ongoing on the MH form, then the AE start date must be";
  title3 "greater than 1 day after MH stop date";

proc print data=MH006 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH006 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




