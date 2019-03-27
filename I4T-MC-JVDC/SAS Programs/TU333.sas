/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : TU333.sas
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
if page eq 'RS1001_F1'; 
keep subjid RSSPID OVRLRESP spid;
run;
Proc sort;
by subjid spid;
run;
data tu1;
set clntrial.tu2001b;
spid = TRSPID;
TRLNKID_t = TRLNKID;
if TUMSTATT eq 'ABSENT'; 
keep subjid TUMSTATT TRSPID TRLNKID_t spid;
run;
Proc sort;
by subjid spid;
run;
data tu2;
set clntrial.tu3001b;
spid = TRSPID;
TRLNKID_NT = TRLNKID;
if TUMSTATN eq 'ABSENT'; 
keep subjid TUMSTATN TRSPID TRLNKID_nt spid;
run;
Proc sort;
by subjid spid;
run;
data tu;
merge tu1(in = a) tu2(in = b);
by subjid spid;
if a and b;
run;
Proc sort;
by subjid spid;
run;
data rstu;
merge tu(in = a) rs(in = b);
by subjid spid;
if a;
run;
data TU333;
retain SITEMNEMONIC subjid RSSPID OVRLRESP TRSPID TRLNKID_NT TUMSTATN TRLNKID_T TUMSTATT; 
merge rstu(in=a) dm;
keep SITEMNEMONIC subjid RSSPID OVRLRESP TRSPID TRLNKID_NT TUMSTATN TRLNKID_T TUMSTATT;
if a;
run;

Proc sort;
by subjid;
run;

/*Print TU333*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Tumor Identification";
title2 "Overall Response cannot be Complete Response unless all tumors (Target and Non-Target) are measured and are absent.";
  proc print data=TU333 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set TU333 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
