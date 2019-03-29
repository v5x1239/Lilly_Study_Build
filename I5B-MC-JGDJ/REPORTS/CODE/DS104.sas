/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS104.sas
PROJECT NAME (required)           : I5B_MC_JGDJ
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A, AE4001B
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
data ds;
set clntrial.DS1001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
if page eq 'DS1001_F2';
keep SUBJID blockid DSSTDAT1 DSDECOD;
run;
proc sort;
by subjid blockid;
run;
data RS;
set clntrial.RS1001;
if RSDAT ne . then
RSDAT1 = datepart(RSDAT);
format RSDAT1 date9.;
if page eq 'RS1001_F1' and OVRLRESP ne '';
keep SUBJID blockid RSPERF OVRLRESP RSDAT1;
run;
proc sort;
by subjid blockid;
run;
data rds;
merge ds(in = a) rs(in = b);
by subjid blockid;
if a and b;
run;
proc sort;
by subjid;
run;
data fin;
merge rds(in = a) dm;
by subjid;
if a;
run;
data final;
set fin;
if (DSDECOD eq 'PROGRESSIVE DISEASE' and OVRLRESP ne 'PD') or (OVRLRESP eq 'PD' and DSSTDAT1 ne . and RSDAT1 ne . and DSSTDAT1 < RSDAT1);
run;
data DS104;
retain SITEMNEMONIC SUBJID blockid DSSTDAT DSDECOD RSPERF OVRLRESP RSDAT;
set final;
DSSTDAT = DSSTDAT1;
RSDAT = RSDAT1;
format DSSTDAT RSDAT date9.;
label DSSTDAT = 'Discontinuation date' DSDECOD = 'Subject status' RSPERF = 'Response assessment performed'
OVRLRESP = 'Overall response' RSDAT = 'Date of Response Assessment' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number';
keep SITEMNEMONIC SUBJID blockid DSSTDAT DSDECOD RSPERF OVRLRESP RSDAT;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "DS";
  title2 "If reason for discontinuation (disposition status at time of treatment discontinuation) is  ‘Progressive Disease’, Response for that assessment must =  PD.
	Also, the date of treatment discontinuation should be >= Response date of PD";

proc print data=DS104 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS104 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

