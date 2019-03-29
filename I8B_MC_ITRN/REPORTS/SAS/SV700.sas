/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SV700.sas
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
data sv;
set clntrial.sv1001;
if VISDAT ne . then
VISDAT1 = datepart(VISDAT);
format VISDAT1 date9.;
if input(BLOCKID,best.) ge 801;
label OCCUR = 'VISITOCCUR';
keep SUBJID BLOCKID VISDAT1 OCCUR VISDATMD;
run;
proc sort;
by SUBJID;
run;
data ex;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
if EXENDAT ne . then
EXENDAT1 = datepart(EXENDAT);
format EXSTDAT1 EXENDAT1 date9.;
if page in ('EX1001_LF4','EX1001_C1LF4','EX1001_C1LF5');
keep SUBJID EXSTDAT1 EXENDAT1 page;
run;
proc sort;
by subjid;
run;
data ex1;
set ex;
if EXSTDAT1 ne . then
EXSTDAT_EX1F4 = EXSTDAT1;
format EXSTDAT_EX1F4 date9.;
if page eq 'EX1001_LF4';
keep SUBJID EXSTDAT_EX1F4;
run;
proc sort;
by subjid;
run;
data ex2;
set ex;
if EXSTDAT1 ne . then
EXSTDAT_EX1C1F4 = EXSTDAT1;
format EXSTDAT_EX1C1F4 date9.;
if page eq 'EX1001_C1LF4';
keep SUBJID EXSTDAT_EX1C1F4;
run;
proc sort;
by subjid;
run;
data ex3;
set ex;
if EXENDAT1 ne . then
EXENDAT_EX1C1F5 = EXENDAT1;
format EXENDAT_EX1C1F5 date9.;
if page eq 'EX1001_C1LF5';
keep SUBJID EXENDAT_EX1C1F5;
run;
proc sort;
by subjid;
run;
data ex0;
merge ex1 ex2 ex3;
by subjid;
run;
proc sort;
by subjid;
run;
data svex;
merge sv(in = a) ex0(in = b);
by subjid;
if a;
run;
data fin;
set svex;
if BLOCKID eq '801' and VISDAT1 ne . and  EXSTDAT_EX1F4 ne . then V801O = VISDAT1 - EXSTDAT_EX1F4;
if BLOCKID eq '801' and VISDAT1 ne . and  EXSTDAT_EX1C1F4 ne . then V801D = VISDAT1 - EXSTDAT_EX1C1F4;
if BLOCKID eq '802' and VISDAT1 ne . and  EXENDAT_EX1C1F5 ne . then V802 = VISDAT1 - EXENDAT_EX1C1F5;
if BLOCKID eq '803' and VISDAT1 ne . and  EXENDAT_EX1C1F5 ne . then V803 = VISDAT1 - EXENDAT_EX1C1F5;
label V801O = 'V801 (open label)' V801D = 'V801 (double blind)' V802 = 'V802' V803 = 'V803';
run;
proc sort;
by SUBJID;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data SV700;
retain SITEMNEMONIC SUBJID BLOCKID VISDAT OCCUR VISDATMD EXSTDAT_EX1F4 
EXSTDAT_EX1C1F4 EXENDAT_EX1C1F5 V801O V801D V802 V803;
set final;
VISDAT = VISDAT1;
format VISDAT date9.;
keep SITEMNEMONIC SUBJID BLOCKID VISDAT OCCUR VISDATMD EXSTDAT_EX1F4 
EXSTDAT_EX1C1F4 EXENDAT_EX1C1F5 V801O V801D V802 V803;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Subject Visits";
  title2 "Confirm follow up visits are in range:
V801 (open label) - 30 weeks after first treatment dose +/- 7 days
V801 (double blind) - 56 weeks after first treatment dose +/- 7 days
V802 - 17 weeks +/- 14 days after last treatment dose visit
V803 - 30 weeks +/- 14 days after last treatment dose visit";

proc print data=SV700 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set SV700 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

