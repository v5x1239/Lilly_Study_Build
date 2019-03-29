/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST023.sas
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


/*libname clntrial oracle user="Z2X0984" pass="Rithika0984" defer=no path=prd934 access=READONLY schema=I5B_MC_JGDJ;*/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
data syst;
set clntrial.sql320;
if SYSTSTDAT ne . then SYSTSTDAT1 = datepart(SYSTSTDAT);
if SYSTENDAT ne . then SYSTENDAT1 = datepart(SYSTENDAT);
format SYSTSTDAT1 SYSTENDAT1 date9.;
if page eq 'SYST3001_LF1';
keep SUBJID SYSTGRPID CMSPID SYSTTRT SYSTSTDAT1 SYSTENDAT1;
run;
proc sort nodup;
by subjid;
run;
data sv;
set clntrial.sv1001;
if VISDAT ne . then VISDAT1 = datepart(VISDAT);
format VISDAT1 date9.;
if blockid eq '1';
keep SUBJID blockid VISDAT1;
run;
proc sort nodup;
by subjid;
run;
data fin;
merge syst(in = a) sv(in = b) dm;
by subjid;
if a and b;
run;
data final;
set fin;
if VISDAT1 ne . and SYSTENDAT1 ne . then diff = VISDAT1 - SYSTENDAT1;
if diff ne . and diff lt 21;
run;
data SYST023;
retain SITEMNEMONIC SUBJID SYSTGRPID CMSPID SYSTTRT SYSTSTDAT SYSTENDAT blockid VISDAT;
set final;
SYSTSTDAT = SYSTSTDAT1;
SYSTENDAT = SYSTENDAT1;
VISDAT = VISDAT1;
format SYSTSTDAT SYSTENDAT VISDAT date9.;
label SYSTSTDAT = 'Start Date' SYSTENDAT = 'End Date' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number'
SYSTGRPID = 'Regimen number' CMSPID = 'CM number' SYSTTRT = 'Medication name' VISDAT = 'Visit Date' blockid = 'Visit number';
keep SITEMNEMONIC SUBJID SYSTGRPID CMSPID SYSTTRT SYSTSTDAT SYSTENDAT blockid VISDAT;
run;


ods csv file=&irfilcsv trantab=ascii;
  title1 "CM";
  title2 "Treatment End Date must be at least 21 days prior to cycle 1 date";

proc print data=SYST023 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set SYST023 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;



