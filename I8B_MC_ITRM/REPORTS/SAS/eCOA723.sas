/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA723.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Identify duplicate ML1001 records (same date)
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

data ml1001(keep= SITECODE SUBJECT MLSTDAT MLSTTIM DATTIM);
set cluwe.ml1001_ecoa;
DATTIM = MLSTDAT||MLSTTIM;
proc sort;
 by SUBJECT DATTIM ;
run ;

proc freq data = ml1001 noprint ;
 by SUBJECT ;
 table DATTIM / out = ml1001_DUPS (keep = SUBJECT DATTIM count
 where = (Count > 1)) ;
run ; 

data eCOA723(drop=DATTIM count);
retain SITECODE SUBJECT MLSTDAT MLSTTIM;
merge ml1001(in=a) ml1001_DUPS(in=b);
by SUBJECT DATTIM;
if a and b;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA723";
  title2 "Identify duplicate ML1001 records (same date)";

proc print data=eCOA723 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA723 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

