/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS028.sas
PROJECT NAME (required)           : I4T_MC_JVDC
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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

data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;

Data rs;
set clntrial.RS1001;
if page eq 'RS1001_F1' and OVRLRESP ne ''; 
keep subjid RSSPID OVRLRESP;
run;
Proc sort;
by subjid RSSPID;
run;
data lag;
retain resp;
set rs;
by subjid RSSPID;
if OVRLRESP eq 'CR' then resp = 'CR';
if first.subjid then resp = '';
run;
data fin;
set lag;
length flag $ 100.;
if resp eq 'CR' and OVRLRESP ne 'CR' then flag = 'CR in previous cycle and cannot be SD or PR';
run;
data fin1;
merge fin(in=a) dm;
by subjid;
if a;
run;
data RS028;
retain SITEMNEMONIC subjid RSSPID OVRLRESP; 
set fin1;
keep SITEMNEMONIC subjid RSSPID OVRLRESP flag;
run;
Proc sort data = RS028;
by subjid RSSPID;
run;

/*Print RS028*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Overall response is confirmed “Complete response”, subsequent responses cannot be Stable Disease or Partial Response.";
  proc print data=RS028 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS028 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
