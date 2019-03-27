/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR704.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Continue on therapy after PD (more than 10 days after imaging) 
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
proc sort data=clntrial.Ex1001_D out=ec (keep=SUBJID EXENDAT);
	by SUBJID EXENDAT;
	where page='EX1001_LF1';
run;
data ec1;
	set ec;
	by SUBJID EXENDAT;
	if last.SUBJID;
run;

proc sql;
	create table MSR704 as
	select distinct a.MERGE_DATETIME,a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.page, a.RSPERF, a.RSSPID, a.OVRLRESP, a.OVRLRESP_NRP, a.RSDAT, 
	b.EXENDAT, 
	case 
	when not missing (RSDAT) and not missing (EXENDAT) then datepart (RSDAT) - datepart (EXENDAT)
	else . end as day_diff
	from clntrial.RS1001_D a left join ec1 b
	on a.SUBJID=b.SUBJID
	where OVRLRESP='PD' and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print MSR704*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Continue on therapy after PD (more than 10 days after imaging)";


  proc print data=MSR704 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR704 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




