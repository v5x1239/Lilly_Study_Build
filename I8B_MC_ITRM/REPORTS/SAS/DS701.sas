/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS701.sas
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
id = AEGRPID_RELREC;
if DSDECOD in ('ADVERSE EVENT','DEATH') and AEGRPID_RELREC ne .;
keep SUBJID BLOCKID DSSTDAT1 DSDECOD AEGRPID_RELREC id;
run;
proc sort;
by subjid id;
run;
data ae1;
set clntrial.AE3001a;
keep SUBJID AEGRPID AETERM AEDECOD;
run;
proc sort;
by subjid AEGRPID;
run;
data ae2;
set clntrial.AE3001b;
if AESTDAT ne . then
AESTDAT1 = datepart(AESTDAT);
if AEENDAT ne . then
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESPID AESTDAT1 AEONGO AEENDAT1
AESEV AESER AESDTH AEREL AEOUT;
run;
proc sort;
by subjid AEGRPID;
run;
data ae;
merge ae1 ae2;
by subjid AEGRPID;
id = AEGRPID;
run;
proc sort;
by subjid id;
run;
data mer;
merge ds(in = a) ae(in = b);
by subjid id;
if a;
run;
proc sort;
by subjid;
run;
data final;
merge mer(in = a) dm;
by subjid;
if a;
run;
data DS701;
retain SITEMNEMONIC SUBJID BLOCKID DSSTDAT DSDECOD AEGRPID_RELREC
AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT AESEV AESER AESDTH AEREL AEOUT;
set final;
length flag $100.;
DSSTDAT = DSSTDAT1;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
format DSSTDAT AESTDAT AEENDAT date9.;
if AEGRPID eq . then flag = 'There is no matching AEGRPID in AE3001_LF1';
keep SITEMNEMONIC SUBJID BLOCKID DSSTDAT DSDECOD AEGRPID_RELREC
AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT AESEV AESER AESDTH AEREL AEOUT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Summary";
  title2 "Reason for discontinuation is selected as adverse event however the adverse event for that AE Group ID has been deleted.";

proc print data=DS701 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS701 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

