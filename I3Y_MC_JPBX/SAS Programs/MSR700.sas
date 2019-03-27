/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR700.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : A patient’s drug compliance per cycle is repeatedly < 75% or > 125% (Note: a single occurrence for a patient is a minor deviation)
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
	create table MSR700 as
	select distinct MERGE_DATETIME,SUBJID, BLOCKID, page, EXVAMT, EXCONC, EXPDOSE,
	case 
	when not missing (EXVAMT) and not missing (EXCONC) and not missing (EXPDOSE) then 
	((EXVAMT * EXCONC)/EXPDOSE)*100
	else . end as per 'Compliance percentage'
	from clntrial.EX1001_D
	where datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;
	


/*Print MSR700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "A patient’s drug compliance per cycle is repeatedly < 75% or > 125%";


  proc print data=MSR700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
