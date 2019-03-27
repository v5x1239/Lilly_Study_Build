/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS010.sas
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
if page eq 'RS1001_F1' and OVRLRESP ne 'PD'; 
spid = RSSPID;
keep subjid RSSPID OVRLRESP spid;
run;
Proc sort;
by subjid spid;
run;
data tu1;
set clntrial.tu1001a;
TRLNKID = TULNKINW;
keep subjid TUMIDTNW TULNKINW TRLNKID;
run;
Proc sort;
by subjid TRLNKID;
run;
data tu2;
set clntrial.tu1001b;
spid = TRSPID;
if TUMSTNW ne '';
keep subjid TRLNKID TRSPID TUMSTNW spid;
run;
Proc sort;
by subjid TRLNKID;
run;
data tu;
merge tu1 tu2(in = a);
by subjid TRLNKID;
if a;
run;
Proc sort;
by subjid spid;
run;
data rstu;
merge tu rs1;
by subjid spid;
run;
Proc sort;
by subjid;
run;
data fin;
merge rstu(in = a) dm;
by subjid;
if a;
run;
data RS010;
retain SITEMNEMONIC subjid TULNKINW TUMIDTNW TRLNKID TRSPID TUMSTNW RSSPID OVRLRESP; 
set fin;
if TUMSTNW ne ''; 
keep SITEMNEMONIC subjid TULNKINW TUMIDTNW TRLNKID TRSPID TUMSTNW RSSPID OVRLRESP;
run;
Proc sort nodup;
by subjid TULNKINW TUMIDTNW TRLNKID TRSPID TUMSTNW OVRLRESP;
run;

/*Print RS010*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "Check for new Tumors and the Tumor State of the new Tumor is unaquivical then overall reponse should be Progressive Disease.";
  proc print data=RS010 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS010 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
