/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon2a.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Exception based report to identify missing MLDOSE_CARB from ML3001
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : \\IX1LECFS02.rf.lilly.com\icon.grp\DS_END\219268_I8B-MC-ITRM\ecoa\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

/************************* Start of environment/input/output programming ************************/

/*DIAB_eCOA_URI_Recon2_PREP*/

data ML3001(keep=SUBJECT SITECODE ECOAENDT MLCAT MLDOSE_CARB MLDOSE_CARBU MLSTDAT MLSTTIM);
set CLUWE.ML3001_ECOA;
proc sort; by SUBJECT MLSTDAT MLSTTIM; run;

/*DIAB_eCOA_URI_Recon2a*/

data DIAB_eCOA_URI_Recon2a;
retain SUBJECT SITECODE ECOAENDT MLCAT MLDOSE_CARB MLDOSE_CARBU MLSTDAT MLSTTIM;
set ML3001;
where MLCAT is not null and MLDOSE_CARB in (.,0.00);
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon2a";
  title2 "Exception based report to identify missing MLDOSE_CARB from ML3001";

proc print data=DIAB_eCOA_URI_Recon2a noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon2a nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
