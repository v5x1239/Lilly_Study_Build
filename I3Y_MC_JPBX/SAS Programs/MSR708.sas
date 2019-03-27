/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR708.sas
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
	create table MSR708 as
	select distinct a.MERGE_DATETIME, a.SUBJID, a.BLOCKID, b.visdat, a.BLOCKRPT, a.page, a.EQ5D5LPERF, a.QSSPID, a.QSTPT,
	a.EQ5D5DT, 
	case
	when not missing (b.visdat) and not missing (EQ5D5DT) then datepart (b.visdat) - datepart (EQ5D5DT)
	else . end as diff,
	case 
	when upcase (QSTPT)='BASELINE' and EQ5D5LPERF='N' then 'Assessment Not Performed'
	when upcase (QSTPT)='BASELINE' and calculated diff >7 then '>7 Days'
	when upcase (QSTPT)='BASELINE' and calculated diff <=7 then '<=7 Days' 
	else '' end as Flag1,
	case 
	when upcase (QSTPT)='DAY 1' and EQ5D5LPERF='N' then 'Assessment Not Performed'
	when upcase (QSTPT)='DAY 1' and calculated diff >7 then '>7 Days'
	when upcase (QSTPT)='DAY 1' and calculated diff <=7 then '<=7 Days' 
	else '' end as Flag2,
	case 
	when upcase (QSTPT)='VISIT 801' and EQ5D5LPERF='N' then 'Assessment Not Performed'
	when upcase (QSTPT)='VISIT 801' and datepart (EQ5D5DT) between  datepart (b.visdat) and datepart (c.visdat) then 'V801 Assessment Data is available'
	else '' end as Flag3
	from  clntrial.EQ5D_D a left join clntrial.SV1001_D  b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join (select * from clntrial.SV1001_D where blockid='802') c
	on a.SUBJID=b.SUBJID 
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;



/*Print MSR708*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Significant patient assessment or management issues";


  proc print data=MSR708 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR708 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




