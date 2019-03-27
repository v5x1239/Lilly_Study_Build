/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS014.sas
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
if OVRLRESP ne ''; 
keep subjid /*MERGE_DATETIME*/ RSSPID OVRLRESP page;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs2;
set clntrial.RS1001;
if TRGRESP ne ''; 
keep subjid /*MERGE_DATETIME*/ RSSPID TRGRESP page;
run;
Proc sort;
by subjid RSSPID;
run;
Data rs3;
set clntrial.RS1001;
if NTRGRESP ne ''; 
keep subjid /*MERGE_DATETIME*/ RSSPID NTRGRESP page;
run;
Proc sort;
by subjid RSSPID;
run;
data rs;
merge rs1 rs2 rs3;
by subjid RSSPID;
if OVRLRESP eq 'PR';
run;data tu;
set clntrial.tu1001a;
keep subjid TUMIDTNW;
run;
Proc sort;
by subjid;
run;
/*Data rs2;*/
/*set clntrial.RS1001;*/
/*if page eq 'RS1001_F1' and RSSPID ne . and TRGRESP ne ''; */
*keep subjid /*MERGE_DATETIME*/ RSSPID TRGRESP;
/*run;*/
/*Proc sort;*/
/*by subjid RSSPID;*/
/*run;*/
/*data rs;*/
/*merge rs1(in = a) rs2;*/
/*by subjid RSSPID;*/
/*if a;*/
/*run;*/
/*Proc sort;*/
/*by subjid;*/
/*run;*/
data mer;
merge rs(in = a) tu dm;
by subjid;
if a;
run;
data RS014;
retain /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID OVRLRESP TRGRESP NTRGRESP TUMIDTNW; 
set mer;
keep /*MERGE_DATETIME*/ SITEMNEMONIC subjid RSSPID OVRLRESP TRGRESP NTRGRESP TUMIDTNW;
run;
Proc sort;
by subjid;
run;

/*Print RS014*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disease Response";
title2 "If overall response = Partial Response, one of the following conditions must be true: ";
  proc print data=RS014 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS014 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
