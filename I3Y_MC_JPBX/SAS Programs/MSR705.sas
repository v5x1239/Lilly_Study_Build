/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR705.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Significant patient assessment or management issues
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
	create table MSR705 as
	select distinct a.MERGE_DATETIME,a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.page, a.EGPERF, a.EGSPID, a.EGDAT, c.VISDAT, 
	case 
	when not missing (EGDAT) and not missing (b.VISDAT) then datepart (b.VISDAT) - datepart (EGDAT)
	else . end as day_diff,
	case
	when not missing (calculated day_diff) and calculated day_diff > 7 then 'No. of Days between Baseline ECG and Baseline Date > 7'
	else '' end as Flag1,
	case 
	when not missing (EGDAT) and not missing (c.VISDAT) and datepart (EGDAT) < datepart (c.VISDAT) then
	'Baseline ECG Date < Randomization Date' else '' end as Flag2
	from (select * from clntrial.EG3001_D where BLOCKID='0') a left join (select * from clntrial.SV1001_D where BLOCKID='0')  b
	on a.SUBJID=b.SUBJID left join (select * from clntrial.SV1001_D where BLOCKID='1')  c
	on a.SUBJID=c.SUBJID
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print MSR705*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Significant patient assessment or management issues";


  proc print data=MSR705 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR705 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




