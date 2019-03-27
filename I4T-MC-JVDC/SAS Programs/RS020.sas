/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS020.sas
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
if TRGRESP eq 'PD'; 
keep subjid /*MERGE_DATETIME*/ RSSPID TRGRESP page;
run;
Proc sort;
by subjid RSSPID;
run;
data tu1;
set clntrial.tu2001b;
keep subjid LDIAM;
run;
Proc sort;
by subjid;
run;
data tu2;
set clntrial.tu1001b;
keep subjid LDIAM;
run;
Proc sort;
by subjid;
run;
data tu;
merge tu1 tu2;
by subjid;
run;
Proc sort;
by subjid;
run;
data mer;
merge rs(in = a) tu dm;
by subjid;
if a;
run;
data RS020;
retain /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID TRGRESP LDIAM; 
set mer;
if TRPERF eq '';
keep /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID TRGRESP LDIAM;
run;
Proc sort;
by subjid;
run;

/*Print RS020*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Target Response is Progressive Disease,  ensure that there was a 20% increase over the smallest sum on study or the appearance of new Tumor(s).  The sum must demonstrate an absolute increase of at least 5mm";
  proc print data=RS020 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS020 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
