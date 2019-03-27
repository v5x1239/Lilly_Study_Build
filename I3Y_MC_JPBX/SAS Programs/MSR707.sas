/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR707.sas
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
	create table MSR707 as
	select distinct a.MERGE_DATETIME, a.SUBJID, a.BLOCKID, b.visdat, a.BLOCKRPT, a.page, a.ECOGPSPERF, a.QSSPID, a.QSTPT,
	a.ECOGPSDAT, a.ECOGPSTATUS,
	case
	when not missing (b.visdat) and not missing (ECOGPSDAT) then datepart (b.visdat) - datepart (ECOGPSDAT)
	else . end as diff,
	case 
	when upcase (QSTPT)='BASELINE' and ECOGPSPERF='N' then 'ECOG Not Performed'
	when upcase (QSTPT)='BASELINE' and calculated diff >7 then '>7 Days'
	when upcase (QSTPT)='BASELINE' and calculated diff <=7 then '<=7 Days' 
	else '' end as Flag1,
	case 
	when upcase (QSTPT)='DAY 1' and ECOGPSPERF='N' then 'ECOG Not Performed'
	when upcase (QSTPT)='DAY 1' and calculated diff >7 then '>7 Days'
	when upcase (QSTPT)='DAY 1' and calculated diff <=7 then '<=7 Days' 
	else '' end as Flag2,
	case 
	when upcase (QSTPT)='VISIT 801' and ECOGPSPERF='N' then 'ECOG Not Performed'
	when upcase (QSTPT)='VISIT 801' and datepart (ECOGPSDAT) between  datepart (b.visdat) and datepart (c.visdat) then 'V801 ECOG Data is available'
	else '' end as Flag3
	from  clntrial.ECOG_D a left join clntrial.SV1001_D  b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join (select * from clntrial.SV1001_D where blockid='802') c
	on a.SUBJID=b.SUBJID 
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;


/*Print MSR707*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Significant patient assessment or management issues";


  proc print data=MSR707 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR707 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




