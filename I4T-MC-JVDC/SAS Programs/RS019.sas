/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS019.sas
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
if TRGRESP ne ''; 
keep subjid RSSPID TRGRESP spid;
run;
Proc sort;
by subjid SPID;
run;
data tu;
set clntrial.tu2001b;
spid = trspid;
keep subjid trspid TRLNKID LDIAM SAXIS spid;
run;
Proc sort;
by subjid SPID;
run;
data mer;
merge rs(in = a) tu;
by subjid SPID;
if a;
run;
data fin;
merge mer(in = a) dm;
by subjid;
if a;
run;
data RS019;
retain SITEMNEMONIC subjid LDIAM SAXIS RSSPID TRGRESP; 
set fin;
keep SITEMNEMONIC subjid LDIAM SAXIS RSSPID TRGRESP;
run;
Proc sort;
by subjid;
run;

/*Print RS019*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Target Response is Partial Response, ensure that sum of the longest diameter of target tumors has a decrease of = 30% from baseline sum";
  proc print data=RS019 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS019 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
