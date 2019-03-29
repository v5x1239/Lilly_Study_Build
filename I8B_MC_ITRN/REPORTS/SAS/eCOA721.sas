/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA721.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Identify duplicate HYPO1001 records (same date and time where at least one record is entered by the Investigator but both records are not eDiary assessments)
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

data hypo1001(keep= SITECODE SUBJECT HYPOSTDAT HYPOSTTIM HYPOEVAL CESCAT DATTIM);
set cluwe.hypo1001_ecoa;
DATTIM = HYPOSTDAT||HYPOSTTIM;
run ;

proc sort data=hypo1001 nouniquekeys uniqueout=singles out=dups;
by SUBJECT DATTIM;
run;

data eCOA721(drop=DATTIM);
set dups;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA721";
  title2 "Identify duplicate HYPO1001 records (same date and time where at least one record is entered by the Investigator but both records are not eDiary assessments)";

proc print data=eCOA721 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA721 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

