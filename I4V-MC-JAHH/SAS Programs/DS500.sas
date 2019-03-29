/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS500.sas
PROJECT NAME (required)           : I4V_MC_JAHH
DESCRIPTION (required)            : Check the Treatment Discontinuation Status (from  DS1001_LF8) against the Discontinuation Status 
									on all DS1001 forms where DSSCAT = "Study Disposition" (excluding DS1001_LF4) to ensure a logical 
									relationship between responses.  
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A_F1, AE4001B_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data DS500a(keep=/*MERGE_DATETIME*/ SUBJID PAGE_LF8 DSSCAT_LF8) ;
format PAGE_LF8 $50. DSSCAT_LF8 $100.;
set clntrial.ds1001;
where page = "DS1001_LF8" and DSSCAT = "TREATMENT DISPOSITION";
PAGE_LF8 = page;
DSSCAT_LF8 = DSSCAT;
proc sort nodupkey; by subjid; run;

data DS500b(keep=SUBJID PAGE DSSCAT) ;
set clntrial.ds1001;
where page ne "DS1001_LF4" and DSSCAT = "STUDY DISPOSITION";
proc sort; by subjid; run;

data DS500;
retain SUBJID PAGE_LF8 DSSCAT_LF8 PAGE DSSCAT;
merge ds500a(in=a) ds500b(in=b);
by subjid;
if a and b;
run;

/**/
/*proc sql;*/
/*create table DS500 as */
/*select a.merge_datetime, b.SITEMNEMONIC, a.SUBJID, a.PAGE_LF8, a.DSSCAT_LF8, a.PAGE, a.DSSCAT*/
/*from DS500_ a left join clntrial.INF_SITE b*/
/*on a.SUBJECT_ID=b.SUBJECT_ID*/
/*where datepart(a.MERGE_DATETIME) > input("&date", ? Date9.)*/
/*order by b.SITEMNEMONIC, a.SUBJID*/
/*; */

ods csv file=&irfilcsv trantab=ascii;
  title1 "Check the Treatment Discontinuation Status (from  DS1001_LF8) against the Discontinuation Status"; 
  title2 "on all DS1001 forms where DSSCAT = Study Disposition (excluding DS1001_LF4) to ensure a logical";
  title3 "relationship between responses.";
  proc print data=DS500 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS500 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

