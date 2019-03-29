/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CLRM002.sas
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

Data clrm;
set clntrial.clrm001_;
SUBJID = input(SUBJ_ID,best.);
keep SITE_ID SUBJ_ID LAB_VISIT_NM CLLCTN_DTM ACCSSN_ID SUBJID;
run;
proc sort NODUP;
by subjid;
run;
proc sql;
create table DS as select distinct SUBJID,DATEPART(DSSTDAT) AS DSSTDAT FORMAT DATE9. from clntrial.DS2001
order by SUBJID;
quit;
data final;
merge CLRM(in = a) DS;
by subjid;
if a;
run;
proc sql;
create table CLRM002 as select SITE_ID, SUBJ_ID, LAB_VISIT_NM, DATEPART(CLLCTN_DTM) as CLLCTN_DTM FORMAT DATE9., ACCSSN_ID, DSSTDAT
from final
WHERE DATEPART(CLLCTN_DTM) < DSSTDAT
order by SUBJID;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "CLRM";
  title2 "Check for CLRM lab collection date prior to informed consent date";

proc print data=CLRM002 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set CLRM002 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

