/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS003.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
data ds;
set clntrial.DS1001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
if page in ('DS1001_LF2','DS1001_LF4','DS1001_LF5','DS1001_LF6','DS1001_LF7','DS1001_C1LF6') and 
DSSCAT in ('TREATMENT DISPOSITION','STUDY DISPOSITION','POST DISCONTINUATION FOLLOW-UP DISPOSITION');
keep SUBJID BLOCKID DSSTDAT1 DSDECOD DSCAT_1 DSSCAT;
run;
proc sql;
create table fin as select *,count(subjid) as cnt from ds
group by subjid
having cnt > 1
order by subjid;
quit; 
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data DS003;
retain SITEMNEMONIC SUBJID BLOCKID DSSTDAT DSDECOD DSCAT_1 DSSCAT;
set final;
DSSTDAT = DSSTDAT1;
format DSSTDAT date9.;
keep SITEMNEMONIC SUBJID BLOCKID DSSTDAT DSDECOD DSCAT_1 DSSCAT;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Summary";
  title2 "One summary date/record must exist for every patient";

proc print data=DS003 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS003 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

