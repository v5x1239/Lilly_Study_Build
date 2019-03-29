/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS036.sas
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
data ds;
set clntrial.DS1001;
if DSSTDAT ne . then DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
blockid1 = blockid;
if upcase(DSDECOD) eq 'PROGRESSIVE DISEASE';
label DSDECOD = 'Reason for discontinuation';
keep SUBJID DSSTDAT1 DSDECOD blockid BLOCKRPT blockid1;
if page eq 'DS1001_F2';
run;
proc sort nodup;
by subjid blockid BLOCKRPT;
run;
data RS1;
set clntrial.RS1001;
if RSDAT ne . then RSDAT1 = datepart(RSDAT);
format RSDAT1 date9.;
id = RSSPID;
if OVRLRESP eq 'PD' and BLOCKID not in ('801','802_XXX');
label BLOCKID = 'Visit' RSPERF = 'Overall response assessment performed' 
RSSPID = 'Response Assessment Number' OVRLRESP = 'Overall Response' 
OVRLRNRP = 'Overall Response - Non Radiological Progression'
TRGRESP = 'Target Response' NTRGRESP = 'Non-Target Response' BLOCKRPT = '9XX-V8XX Visits';
keep SUBJID BLOCKID BLOCKRPT RSPERF RSSPID OVRLRESP OVRLRNRP RSDAT1 id;
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
by subjid blockid BLOCKRPT;
run;
data rds;
merge rs(in=a) ds;
by subjid blockid BLOCKRPT;
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
length flag1 $80.;
if upcase(DSDECOD) ne 'PROGRESSIVE DISEASE' then flag1 = 'DSDECOD is not equal to Progressive Disease on DS_SUM_TRT form';
run;
data RS036;
retain SITEMNEMONIC SUBJID BLOCKID BLOCKRPT RSPERF RSSPID OVRLRESP OVRLRNRP RSDAT TRGRESP NTRGRESP DSSTDAT DSDECOD;
set final;
RSDAT = RSDAT1;
DSSTDAT = DSSTDAT1;
format RSDAT DSSTDAT date9.;
label RSDAT = 'Date of Response Assessment' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number';
keep SITEMNEMONIC SUBJID BLOCKID BLOCKRPT RSPERF RSSPID OVRLRESP OVRLRNRP RSDAT TRGRESP NTRGRESP DSSTDAT DSDECOD flag1;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "RS";
  title2 "When overall response is PD, the reason for discontinuation must be PD";

proc print data=RS036 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set RS036 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

