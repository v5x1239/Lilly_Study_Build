/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon3a.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Exception based report to identify missing EXDOSE from EX1001
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
/*DIAB_eCOA_URI_Recon3_PREP*/

data EX1001(keep=SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT);
set CLUWE.EX1001_ECOA;
proc sort; by SUBJECT EXSTDAT EXSTTIM; run; 

/*DIAB_eCOA_URI_Recon3a*/

data DIAB_eCOA_URI_Recon3a;
retain SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT;
set EX1001;
where EXTPT is not null and EXDOSE in (.,0.00);
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon3a";
  title2 "Exception based report to identify missing EXDOSE from EX1001";

proc print data=DIAB_eCOA_URI_Recon3a noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon3a nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
