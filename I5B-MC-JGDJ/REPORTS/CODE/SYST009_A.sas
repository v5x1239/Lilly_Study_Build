/*
Company (required) -              : ICON
CODE NAME (required)              : SYST009_A
PROJECT NAME (required)           :  
DESCRIPTION (required)            : Ensure regimens are numbered sequentially – using start dates as guidance – and not overlapping – ensuring that all drugs administered on the same dates have the same regimen number. 
SPECIFICATIONS (required)         : I5B-MC-JGDJ__eClinical Manual Data Verification Plan_V4_Draft_batch2
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : 
DATA INPUT                        : SYST009_
OUTPUT                            : SYST009_A
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan   Original version of the code
*/

/*libname clntrial oracle user="C197402" pass="Nature006" defer=no path=prd934 access=READONLY schema=I5B_MC_JGDJ;*/
proc sort data=clntrial.SYST009_ out=SYST009_;
	by SUBJID SYSTGRPID ;
	where page='SYST3001_LF1';
run;
data SYST009_1;
	set SYST009_;
	by SUBJID SYSTGRPID ;
	if last.SYSTGRPID;
run;
proc sort data=SYST009_1 ;
	by SUBJID SYSTSTDAT;
run;
data SYST009_2 ;
	set SYST009_1;
	by SUBJID SYSTSTDAT;
	prev_seq=lag (SYSTGRPID);
	if first.SUBJID then prev_seq=.;
run;
proc sql;
	create table SYST009_A as
	select datepart(MERGE_DATETIME) as MERGE_DATETIME, SITEMNEMONIC "Site Number", 
SUBJID "Subject Number", 
SYSTGRPID "Regimen number",
CMSPID "Medication number",
SYSTTRT "Medication therapy",
datepart (SYSTSTDAT) "Start date" format date9.,
datepart (SYSTENDAT) "End date" format date9. from SYST009_1 where SUBJID in (select SUBJID from  SYST009_2
where NOT MISSING (prev_seq) AND SYSTGRPID ne (prev_seq+1)) and datepart(MERGE_DATETIME) > input("&date",Date9.);
quit;

/*Print ONC_TU219_TU318*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "SYST009_A";
title2 "Ensure regimens are numbered sequentially – using start dates as guidance – and not overlapping – ensuring that all drugs administered on the same dates have the same regimen number. ";
  proc print data=SYST009_A noobs WIDTH=min label;  
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SYST009_A nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;


