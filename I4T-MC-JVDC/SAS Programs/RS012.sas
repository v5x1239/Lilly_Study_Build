/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS012.sas
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I4T_MC_JVDC;*/


data dm;
set clntrial.DM1001c;
keep SITEMNEMONIC subjid;
run;
Proc sort;
by subjid;
run;

Data rs;
set clntrial.RS1001;
spid = RSSPID;
if OVRLRESP ne ''; 
keep subjid /*MERGE_DATETIME*/ RSSPID OVRLRESP page spid;
run;
Proc sort;
by subjid SPID;
run;
data tu1;
set clntrial.tu2001b;
if TRPERF in ('N','');
keep subjid TRPERF TRLNKID TRPERF TRSPID;
run;
Proc sort;
by subjid TRLNKID TRSPID;
run;
data tu2;
set clntrial.tu3001b;
if TRPERF in ('N','');
keep subjid TRLNKID TRPERF TRSPID;
run;
Proc sort;
by subjid TRLNKID TRSPID;
run;
data tu;
set tu1 tu2;
by subjid TRLNKID TRSPID;
spid = TRSPID;
run;
proc sort nodup;
by subjid spid;
where TRLNKID ne '';
run;
data mer;
merge rs(in = a) tu;
by subjid spid;
if a;
run;
Proc sort;
by subjid;
run;
data fin;
merge mer(in = a) dm;
by subjid;
if a;
run;
data RS012;
retain /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID OVRLRESP TRPERF; 
set fin;
keep /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID OVRLRESP TRPERF;
run;
Proc sort;
by subjid;
run;

/*Print RS012*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "Ensure there are not responses without Tumor data to support them. Except for Non-Radiological Progression";
  proc print data=RS012 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS012 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
