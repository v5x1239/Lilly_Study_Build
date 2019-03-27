/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST501.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : If regimen dates overlap, ensure that this is logical (eg hormone therapy overlaps with chemo).
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
proc sort data=clntrial.SYST3B_D out=s1;
	by SUBJID SYSTGRPID CMSPID SYSTSTDAT SYSTENDAT;
	where PAGE='SYST3001_LF1';
run;
data s2;
	set s1;
	by SUBJID SYSTGRPID CMSPID SYSTSTDAT SYSTENDAT;
	prev_st=lag (SYSTSTDAT);	
	pre_en=lag (SYSTENDAT);
	if first.SUBJID then do;
		prev_st=.;
		pre_en=.;
	end;
run;
proc sql;
	create table SYST501  as
	select distinct SUBJID, blockid, page, SYSTGRPID, SYSTRSRGM, SYSTRSDAT, BESTRESP_SYST, 
	SYSTMDLY, SYSTGRPID, CMSPID, SYSTTRT, SYSTSTDAT, SYSTENDAT, SYSTCAT,
	case
	when not missing (SYSTSTDAT) and not missing (prev_st) and not missing (pre_en) and datepart (SYSTSTDAT) gt datepart (prev_st) 
		and datepart (SYSTSTDAT) lt datepart (pre_en) then 'OVERLAPS' 
	else '' end as flag 
	from s2
	where datepart(MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;




/*Print SYST501*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If regimen dates overlap, ensure that this is";
title2 "logical (eg hormone therapy overlaps with chemo).";


  proc print data=SYST501 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SYST501 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




