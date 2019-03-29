/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : REC700.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Review GLS Time Compared to Injection Time
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Ensure that the lab sample, ECG, and vital signs dates and times are prior to the three Injection dates and times collected on the CRF.
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

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Add code here*/
proc sql;
	create table REC700 as
	select distinct a.merge_datetime, a.SUBJID, a.EXSTDAT, input(strip(strip(a.EXSTTIMHR)||':'||strip(a.EXSTTIMMI)),time8.) as EXSTTIM format time8., b.TSTCDNME, b.CLLCTDT, b.CLLCTTM
	from clntrial.EX1001_D a inner join clntrial.LABRSLTA b
	on a.SUBJID=b.SUBJID and input(a.blockid, 8.)=b.blockid
	where datepart (a.EXSTDAT) le datepart (b.CLLCTDT) and calculated EXSTTIM le timepart (b.CLLCTDT) and datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by a.SUBJID;

quit;
	


/*Print REC700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure that the lab sample, ECG, and vital signs dates";
  title2 "and times are prior to the three Injection dates and";
  title3 "times collected on the CRF.";

  proc print data=REC700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set REC700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
