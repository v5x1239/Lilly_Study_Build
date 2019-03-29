/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS003.sas
PROJECT NAME (required)           : I5B_MC_JGDJ
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A, AE4001B
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
data TU1;
set clntrial.TU1001B;
if TRDAT ne . then TRDAT_TU1F1S2 = datepart(TRDAT);
date = TRDAT_TU1F1S2;
format TRDAT_TU1F1S2 date date9.;
SPID1 = TRSPID;
ID = TRSPID;
keep SUBJID TRDAT_TU1F1S2 TRSPID SPID1 date id;
run;
proc sort nodup;
by subjid id date;
run;
data TU2;
set clntrial.TU2001B;
if TRDAT ne . then TRDAT_TU2F1 = datepart(TRDAT);
date = TRDAT_TU2F1;
format TRDAT_TU2F1 date date9.;
TRSPID = TRSPID_TU2F1;
ID = TRSPID_TU2F1;
keep SUBJID TRDAT_TU2F1 TRSPID TRSPID_TU2F1 date id;
run;
proc sort nodup;
by subjid id date;
run;
data TU3;
set clntrial.TU3001B;
if TRDAT ne . then TRDAT_TU3F1S2 = datepart(TRDAT);
date = TRDAT_TU3F1S2;
format TRDAT_TU3F1S2 date date9.;
SPID3 = TRSPID;
ID = TRSPID;
keep SUBJID TRDAT_TU3F1S2 TRSPID SPID3 date id;
run;
proc sort nodup;
by subjid id date;
run;
data tu;
merge tu1 tu2 tu3;
by subjid id date;
run;
proc sort nodup;
by subjid date;
run;
data RS1;
set clntrial.RS1001;
if RSDAT ne . then RSDAT1 = datepart(RSDAT);
date = RSDAT1;
id = RSSPID;
format RSDAT1 date date9.;
if RSPERF eq 'Y';
label BLOCKID = 'Visit' RSPERF = 'Overall response assessment performed' 
RSSPID = 'Response Assessment Number' OVRLRESP = 'Overall Response' 
OVRLRNRP = 'Overall Response - Non Radiological Progression'
TRGRESP = 'Target Response' NTRGRESP = 'Non-Target Response';
keep SUBJID BLOCKID RSPERF RSSPID OVRLRESP OVRLRNRP date RSDAT1 TRGRESP NTRGRESP id;
run;
proc sort nodup;
by subjid BLOCKID id;
run;
data RS2;
set clntrial.RS1001;
id = RSSPID;
label TRGRESP = 'Target Response';
if TRGRESP ne '';
keep SUBJID BLOCKID TRGRESP id;
run;
proc sort nodup;
by subjid BLOCKID id;
run;
data RS3;
set clntrial.RS1001;
id = RSSPID;
label NTRGRESP = 'Non-Target Response';
if NTRGRESP ne '';
keep SUBJID BLOCKID NTRGRESP id;
run;
proc sort nodup;
by subjid BLOCKID id;
run;
data rs;
merge rs1(in = a) rs2 rs3;
by subjid BLOCKID id;
if a;
run;
proc sort nodup;
by subjid date;
run;
data rds;
merge rs(in=a) tu;
by subjid date;
if a;
run;
proc sort;
by subjid;
run;
data fin;
merge rds(in = a) dm;
by subjid;
if a;
run;
data final;
set fin;
length flag $80.;
if date ne . and RSSPID ne '' and RSSPID ne TRSPID then flag = 'Response Assessment Number must match an Assessment Number on Tumor evaluation';
if flag ne '' and SPID3 eq '' and TRSPID_TU2F1 eq '' then flag = '';
run;
data RS003;
retain SITEMNEMONIC SUBJID BLOCKID RSPERF RSSPID OVRLRESP OVRLRNRP RSDAT TRGRESP NTRGRESP TRSPID_TU2F1 Spid3 Spid1;
set final;
RSDAT = RSDAT1;
format RSDAT date9.;
label RSDAT = 'Date of Response Assessment' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number'
spid3 = 'Non-Target Assessment Number' TRSPID_TU2F1 = 'Target Assessment Number' spid1 = 'New Tumor Assessment Number';
keep SITEMNEMONIC SUBJID BLOCKID RSPERF RSSPID OVRLRESP OVRLRNRP RSDAT TRGRESP NTRGRESP Spid1 TRSPID_TU2F1 Spid3 flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "RS";
  title2 "Response Assessment Number must match an Assessment Number on Tumor evaluation";

proc print data=rs003 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set RS003 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

