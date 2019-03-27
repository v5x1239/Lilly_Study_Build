/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : HO500.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If "NO" is selected, then no transfusions should be entered.  
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
	create table HO500  as
	select distinct SUBJID, blockid, page, HOSPID, HOSTDAT, HOONGO, HOENDAT, REASHCS, AEGRPID_RELREC, HOCAT, 
	case 
	when HOYN='N' and not missing (HOSPID) then 'NO is selected, however hospitalizations entered' 
	when HOYN ne 'N' and missing (HOSPID) then 'NO is not selected, however hospitalizations not entered' 
	else '' end as Flag
	from clntrial.HO2001_D 
	where datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;



/*Print HO500*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If NO is selected, then no transfusions should be entered.";


  proc print data=HO500 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set HO500 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




