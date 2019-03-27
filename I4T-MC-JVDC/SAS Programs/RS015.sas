/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS015.sas
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

Data rs1;
set clntrial.RS1001;
if page eq 'RS1001_F1' and OVRLRESP eq 'SD'; 
keep subjid RSSPID OVRLRESP;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs2;
set clntrial.RS1001;
if page eq 'RS1001_F1' and TRGRESP ne ''; 
keep subjid RSSPID TRGRESP;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs3;
set clntrial.RS1001;
if page eq 'RS1001_F1' and NTRGRESP ne ''; 
keep subjid RSSPID NTRGRESP;
run;
Proc sort;
by subjid RSSPID;
run;
data rs;
merge rs1(in = a) rs2 rs3;
by subjid RSSPID;
if a;
run;
Proc sort;
by subjid RSSPID;
run;
data tu;
set clntrial.tu1001a;
if upcase(TUMIDTNW) eq 'NEW'; 
keep subjid TUMIDTNW TUDAT TULNKINW;
run;
Proc sort;
by subjid;
run;
data rstu;
merge tu rs(in = b) dm;
by subjid;
if b;
run;
data RS015;
retain SITEMNEMONIC subjid RSSPID OVRLRESP NTRGRESP TRGRESP TULNKINW TUDAT TUMIDTNW; 
set rstu;
length flag $200.;
if TRGRESP ne 'SD' or  NTRGRESP ne 'Non-CR/Non-PD' or upcase(TUMIDTNW) eq 'NEW' then
flag = 'TRGRESP ne SD or  NTRGRESP ne Non-CR/Non-PD or TUMIDTNW eq NEW';
keep SITEMNEMONIC subjid RSSPID OVRLRESP NTRGRESP TRGRESP TULNKINW TUDAT TUMIDTNW flag;
run;
Proc sort;
by subjid;
run;

/*Print RS015*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Overall response = Stable Disease, the following condition must be true:Target Response = Stable disease and Non-Target response = Non Progressive Disease or Not all Evaluted. And no New Tumors.";
  proc print data=RS015 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS015 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
