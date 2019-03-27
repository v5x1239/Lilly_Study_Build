/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR701.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Docetaxel dose delay is not >35 days from last prior dose
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


proc sort data=clntrial.EX1001_D out=ex1;
	by SUBJID BLOCKID;
run;


data ex2;
	set ex1;
	by SUBJID BLOCKID;
	prev_d=lag (EXPTRDT);
	if first.SUBJID then prev_d=.;
	if substr(upcase(EXREASDLY), 1,1)='Y';
run;

proc sql;
	create table MSR701 (drop=diff) as
	select distinct MERGE_DATETIME,SUBJID, BLOCKID, page, EXREASDLY,EXPTRDT, prev_d,
	case 
	when not missing (EXPTRDT) and not missing (prev_d) then EXPTRDT-prev_d
	else . end as diff
	from ex2
	where calculated diff lt 35 and datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;

quit;


/*Print MSR701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Docetaxel dose delay is not >35 days from last prior dose";


  proc print data=MSR701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
