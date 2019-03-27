/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SV005.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Check that visit dates (including unscheduled visit dates) are consistent with protocol requirements, including visit interval ranges.
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
proc sort data=clntrial.SV1001_D out=sv;
	by 	SUBJID BLOCKID BLOCKRPT;
run;
data sv1;
	set sv;
	by SUBJID BLOCKID BLOCKRPT;
	prev_dt= lag (visdat);
	if first.SUBJID then prev_dt=.;
run;

proc sql;
	create table SV005 as
	select distinct MERGE_DATETIME,SUBJID, BLOCKID, BLOCKRPT, visdat, VISITNUM, 
	case
	when not missing (visdat) and not missing (prev_dt) then datepart (visdat)-datepart (prev_dt)
	else . end as diff
	from sv1
	where datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print SV005*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check that visit dates are consistent with protocol";
  title2 "requirements, including visit interval ranges.";


  proc print data=SV005 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SV005 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




