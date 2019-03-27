/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU336.sas
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
spid = RSSPID;
if page eq 'RS1001_F1' and NTRGRESP ne 'NOT ASSESSED'; 
keep subjid RSSPID NTRGRESP spid;
run;
Proc sort;
by subjid spid;
run;

data tu;
set clntrial.tu3001b;
spid = TRSPID;
if TUMSTATN eq 'NOT ASSESSABLE'; 
keep subjid TUMSTATN TRSPID TRLNKID spid;
run;
Proc sort;
by subjid spid;
run;
data rstu;
merge tu(in = a) rs(in = b);
by subjid spid;
if a and b;
run;
data TU336;
retain SITEMNEMONIC subjid TRSPID TRLNKID TUMSTATN RSSPID NTRGRESP; 
merge rstu(in=a) dm;
keep SITEMNEMONIC subjid TRSPID TRLNKID TUMSTATN RSSPID NTRGRESP;
if a;
run;
Proc sort;
by subjid;
run;
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print TU336*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Tumor Identification";
title2 "If none of the non-target tumors were assessed, Non-target response should be Not Assessed.";
  proc print data=TU336 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU336 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
