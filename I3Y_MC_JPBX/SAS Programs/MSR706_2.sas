/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR706.sas
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
data lb;
	set clntrial.LABRSLTA;
	if length (strip(put(CLLCTTM, ??best.))) eq 3 then lbtm=compress('0'||strip(put(CLLCTTM, ??best.)));
		else lbtm=strip(put(CLLCTTM, ??best.));
	lbtm_=input(compress(substr(lbtm, 1,2)||':'||substr(lbtm, 3,4)), time5.);
	format lbtm_ time5.;
run;
proc sql;
	create table MSR706 as
	select distinct a.MERGE_DATETIME,a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.page, (a.ECSTDAT+7) as C1D8_dt, a.ECSTTIM, b.RQSTNTYP , b.VISID, b.CLLCTDT,
	b.lbtm_,
	case
	when not missing (ECSTTIM) and not missing (lbtm_) then (lbtm_-input(ECSTTIM, time5.))/3600
	else . end as diff
	from  (select * from clntrial.EC1001_D where page='EC1001_F1 ' and BLOCKID='1') a inner join lb b
	on a.SUBJID=b.SUBJID and datepart (ECSTDAT)+7=CLLCTDT
	where RQSTNTYP='ECG' and calculated diff lt 4 and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;



/*Print MSR706*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Significant patient assessment or management issues";


  proc print data=MSR706 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR706 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




