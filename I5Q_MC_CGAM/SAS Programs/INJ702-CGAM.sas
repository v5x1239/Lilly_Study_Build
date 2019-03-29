/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : INJ702.sas
PROJECT NAME (required)           : I5Q-MC-CGAM
DESCRIPTION (required)            : Review for missed injections at visit 3, 6, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20 to confirm the patient did not continue in the trial on treatment
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Review for missed injections at visit 3, 6, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20 to confirm the patient did not continue in the trial on treatment
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : External LAB, vitals, ex
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code
2.0  Joe Cooney       Added DSDCDSCAT_SUBJ_SPCFY per study team request. PRISM: 7736 - 20180416

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Add code here*/
proc sql;
	create table INJ702 as
	select distinct a.merge_datetime, a.SUBJID, a.BLOCKID, a.EXOCCUR, b.BLOCKID as BLOCKID_, b.PAGE, b.DSSCAT, b.DSDECOD, b.DSTERM, b.DSDCDSCAT_SUBJ_SPCFY
	from clntrial.EX1001_D a inner join clntrial.DS1_DUMP b
	on a.SUBJID=b.SUBJID
	where upcase (a.EXOCCUR) eq 'N' and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by a.SUBJID;

quit;
	


/*Print INJ702*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Review for missed injections at visit 3, ";
  title2 "6, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20";
  title3 "to confirm the patient did not continue in the trial on treatment";

  proc print data=INJ702 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set INJ702 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
