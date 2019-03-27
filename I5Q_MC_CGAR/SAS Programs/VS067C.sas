/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : VS067C.sas
PROJECT NAME (required)           : I5Q_MC_CGAR
DESCRIPTION (required)            : 
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I5Q_MC_CGAR;*/

data vs;
set clntrial.vs1001;
if WEIGHT ne . then diff = (0.55*WEIGHT) + 32;
if WEIGHT ne . then diff1 = (0.65*WEIGHT) + 85;
if VSPERF eq 'Y';
keep SUBJID BLOCKID VSPERF WEIGHT HIPCIR diff diff1;
run;
data VS067C;
retain SUBJID BLOCKID VSPERF WEIGHT HIPCIR;
set vs;
if (HIPCIR lt diff) or (HIPCIR gt diff1);  
keep SUBJID BLOCKID VSPERF WEIGHT HIPCIR;
run;

/*Print VS067C*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Vital signs: Physical Characteristics";
title2 "Hip Circumference must be between valid range of 32 + 0.55 x weight in kg to 85 + 0.65 x weight in kg inclusive";
  proc print data=VS067C noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set VS067C nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
