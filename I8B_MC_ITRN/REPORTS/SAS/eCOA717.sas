/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA717.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : MMTT Meal Start Time MMTT should be between 08:00 and 15:00.
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrn\data\shared\*.*
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

data ml1001(keep=SITECODE SUBJECT VISITNUM MLSTDAT MLSTTIM);
set CLUWE.ml1001_ecoa;
where MLSTTIM ne '';
    format MLSTTIM_TIME5 time5.;
MLSTTIM_TIME5 = input(MLSTTIM,hhmmss.);
drop MLSTTIM;
rename MLSTTIM_TIME5 = MLSTTIM;
proc sort; by SUBJECT VISITNUM MLSTDAT MLSTTIM; run;

data eCOA717;
retain SITECODE SUBJECT VISITNUM MLSTDAT MLSTTIM;
set ml1001;
where MLSTTIM < input('08:00:00',hhmmss.) or MLSTTIM > input('15:00:00',hhmmss.);
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA717";
  title2 "MMTT Meal Start Time MMTT should be between 08:00 and 15:00.";

proc print data=eCOA717 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA717 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

