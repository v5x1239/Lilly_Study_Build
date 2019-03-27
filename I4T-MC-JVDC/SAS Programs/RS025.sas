/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS025.sas
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
if page eq 'RS1001_F1' and NTRGRESP eq 'Non-CR/Non-PD'; 
keep subjid RSSPID NTRGRESP spid;
run;
Proc sort;
by subjid spid;
run;
data tu;
set clntrial.tu3001b;
spid = TRSPID;
keep subjid TUMSTATN TRLNKID TRSPID spid;
run;
Proc sort;
by subjid spid;
run;
data rstu;
merge rs(in = a) tu;
by subjid spid;
if a;
run;
proc sort;
by subjid;
run;
data fin;
merge rstu(in = a) dm;
by subjid;
if a;
run;
data fin1;
set fin;
length flag $ 300.;
if TUMSTATN eq 'UNEQUIVOCAL PROGRESSION' then flag = 'Target Response is Non-CR/Non-PD, and Tumor States are recorded as UNEQUIVOCAL PROGRESSION';
run;
data RS025;
retain SITEMNEMONIC subjid RSSPID NTRGRESP TRSPID TRLNKID TUMSTATN; 
set fin1;
keep SITEMNEMONIC subjid RSSPID NTRGRESP TRSPID TRLNKID TUMSTATN flag;
run;
Proc sort;
by subjid;
run;

/*Print RS025*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If Non-Target Response is Non Complete Response/Non Progressive Disease, ensure that none of the Non-Target Tumors have a tumor state of Unequivocal Progression";
  proc print data=RS025 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS025 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
