/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR703.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Dosing:Incorrect dose reduction
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
	create table MSR703_1 as
	select distinct a.MERGE_DATETIME,a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.page, a.ECDOSE, b.DISDAT, b.DISPAMT, b.retdat, b.RETAMT,
	case 
	when not missing (DISPAMT) and not missing (RETAMT) then DISPAMT-RETAMT
	else .	end as cal_amnt
	from clntrial.EC1001_D a left join (select a.SUBJID, a.BLOCKID, a.BLOCKRPT, a.DISDAT, a.DISPAMT, b.retdat, b.RETAMT 
	from (select * from clntrial.DA1001_D where page='DA1001_F1') a left join (select * from clntrial.DA1001_D where page='DA1001_F2') b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID and a.BLOCKRPT=b.BLOCKRPT) b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID and a.BLOCKRPT=b.BLOCKRPT 
	where not missing (a.ECDOSE) and a.page='EC1001_F1' and datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print MSR703*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Dosing:Incorrect dose reduction";


  proc print data=MSR703_1 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR703_1 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




