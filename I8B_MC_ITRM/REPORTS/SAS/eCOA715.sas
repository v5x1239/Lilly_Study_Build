/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA715.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Bolus Correction Dose Start Date and Time should be 0-4.5 hours after V8 or V18 MMTT Meal Start Date and Time in eCOA.
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrm\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

options compress=yes;

/************************* Start of environment/input/output programming ************************/

data ex1001(keep=SUBJID BLOCKID EXSTDAT EXSTTIM EDATETIME EXCAT);
set CLUWE.ex1001;
where coalescec(EXSTDATYY, EXSTDATMO, EXSTDATDD) ne '' and coalescec(EXSTTIMHR, EXSTTIMMI) ne '';
EXSTDAT = mdy(EXSTDATMO,EXSTDATDD,EXSTDATYY);
if length(EXSTTIMHR) = 1 then EXSTTIMHR = '0'||EXSTTIMHR;
if length(EXSTTIMMI) = 1 then EXSTTIMMI = '0'||EXSTTIMMI;
EXSTTIM = input(compress(EXSTTIMHR)||':'||compress(EXSTTIMMI)||':00',hhmmss.);
    format EXSTDAT date9. EXSTTIM time5. EDATETIME datetime20.;
EDATETIME = DHMS(EXSTDAT,0,0,EXSTTIM);
proc sort; by SUBJID; run;

data ml1001(keep=SUBJID MLSTDAT MLSTTIM MLDATETIME);
set CLUWE.ml1001_ecoa;
where MLSTDAT ne '' and MLSTTIM ne '';
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
    format MLSTDAT_DATE9 date9. MLSTTIM_TIME5 time5. MLDATETIME datetime20.;
MLSTTIM_TIME5 = input(MLSTTIM,hhmmss.);
drop MLSTDAT MLSTTIM;
rename MLSTDAT_DATE9 = MLSTDAT
	   MLSTTIM_TIME5 = MLSTTIM;
MLDATETIME = DHMS(MLSTDAT_DATE9,0,0,MLSTTIM_TIME5);
proc sort; by SUBJID; run;

data ecoa715a;
merge ex1001(in=a) ml1001(in=b);
by SUBJID;
if a and b;
diffx = EDATETIME-MLDATETIME;
diff = diffx/3600;
proc sort; by SUBJID EDATETIME; run;

data ecoa715b;
set ecoa715a;
where diff >= 0 and diff <= 4.5;
proc sort nodupkey; by SUBJID EDATETIME; run;

data eCOA715(drop=MLSTDAT MLSTTIM MLDATETIME EDATETIME diffx diff);
retain SUBJID BLOCKID EXSTDAT EXSTTIM EXCAT;
merge ecoa715a(in=a) ecoa715b(in=b);
by subjid EDATETIME;
if a and not b;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA715";
  title2 "Bolus Correction Dose Start Date and Time should be 0-4.5 hours after V8 or V18 MMTT Meal Start Date and Time in eCOA.";

proc print data=eCOA715 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA715 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

