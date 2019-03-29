/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX702_A.sas
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
data sv1;
set clntrial.sv1001;
if VISDAT ne . then
VISDAT1 = datepart(VISDAT);
format VISDAT1 date9.;
label OCCUR = 'VISITOCCUR';
keep SUBJID BLOCKID VISDAT1 OCCUR VISDATMD;
run;
proc sort;
by SUBJID BLOCKID;
run;
data sv2;
set clntrial.sv1001;
if BLOCKID eq '2' then block = BLOCKID;
if BLOCKID eq '2';
keep subjid block BLOCKID;
run;
proc sort;
by SUBJID BLOCKID;
run;
data sv;
merge sv1 sv2(in = a);
by subjid BLOCKID;
if a;
run;
proc sort;
by SUBJID;
run;
data ex;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
format EXSTDAT1 date9.;
if EXSTDAT ne . and page in ('EX1001_LF4');
formname = 'EX_FDOL';
keep SUBJID EXSTDAT1 page formname;
run;
proc sort;
by subjid;
run;
data ds;
set clntrial.ds1001;
if DSSTDAT1 ne . then
DSSTDAT1 = DSSTDAT;
format DSSTDAT1 date9.;
if page in ('DS1001_LF4','DS1001_LF5');
keep SUBJID DSSTDAT1;
run;
proc sort;
by subjid;
run;
data dsex;
merge ex(in = a) sv ds;
by subjid;
if a;
run;
data fin;
set dsex;
length flag $2000.;
if BLOCK ne '2' or DSSTDAT1 ne . then flag = 'First Dose of Study Treatment has been entered, however the subject has not completed the first treatment visit';
run;
proc sort;
by SUBJID;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data EX702_A;
retain SITEMNEMONIC SUBJID formname EXSTDAT VISDAT BLOCKID OCCUR VISDATMD DSSTDAT;
set final;
EXSTDAT = EXSTDAT1;
VISDAT = VISDAT1;
DSSTDAT = DSSTDAT1;
format VISDAT EXSTDAT DSSTDAT date9.;
keep SITEMNEMONIC SUBJID formname EXSTDAT VISDAT BLOCKID OCCUR VISDATMD DSSTDAT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Study Treatment";
  title2 "Ensure that EX_FDOL is only entered if subject completed V2 and was not a screen failure nor LTFU, and ensure EX_FD is only entered if subject has completed V8";

proc print data=EX702_A noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX702_A nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

