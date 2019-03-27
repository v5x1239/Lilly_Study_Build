/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST503.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Ensure regimen IDs are assigned logically (when considering dates of treatments, PD dates, etc.  -- neo/palliative may not necessarily have a PD date or a response, but adj should have both)
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
	create table SYST503  as
	select distinct SUBJID, blockid, page, SYSTGRPID, SYSTRSRGM, SYSTRSDAT, BESTRESP_SYST, 
	SYSTMDLY, SYSTGRPID, CMSPID, SYSTTRT, SYSTSTDAT, SYSTENDAT, SYSTCAT
	from clntrial.SYST3B_D 
	where datepart(MERGE_DATETIME) > input("&date",Date9.) 
	order by SUBJID;
quit;




/*Print SYST503*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure regimen IDs are assigned logically";



  proc print data=SYST503 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SYST503 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




