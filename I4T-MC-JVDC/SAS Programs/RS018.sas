/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS018.sas
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
if page eq 'RS1001_F1' and TRGRESP eq 'CR'; 
keep subjid RSSPID TRGRESP spid;
run;
Proc sort;
by subjid spid;
run;
data tu;
set clntrial.tu2001b;
spid = TRSPID;
keep subjid TUMSTATT TRSPID TRLNKID spid;
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
if TUMSTATT ne 'ABSENT' then flag = 'Target Response is CR, and Tumor States are not recorded as "Absent"';
run;
data RS018;
retain SITEMNEMONIC subjid RSSPID TRGRESP TRSPID TRLNKID TUMSTATT; 
set fin1;
keep SITEMNEMONIC subjid RSSPID TRGRESP TRSPID TRLNKID TUMSTATT flag;
run;
Proc sort;
by subjid;
run;

/*Print RS018*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "The response for Target Response is Complete Response, and Tumor States for all Target tumors are not recorded as Absent";
  proc print data=RS018 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS018 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
