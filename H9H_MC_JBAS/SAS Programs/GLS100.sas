/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS100.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : Check for duplicate lab/ECG data.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : GLS100
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
/*GLS100*/

/*Add code here*/

proc sort data=clntrial.LABRSLTA dupout = GLS100_ NODUPrecs out=xx;
by subjid blockid;
run;
proc sql;
	create table GLS100 as
	select b.MERGE_DATETIME, a.*
	from GLS100_ left a join clntrial.DM_DUMP b
on a.subjid=b.subjid
where datepart(MERGE_DATETIME) > input("&date",Date9.);
quit;

/*Print GLS100*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for duplicate lab/ECG data.";
  proc print data=GLS100 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS100 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
