/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : DIAB_eCOA_URI_Recon3b.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Exception based report to identify missing Meals from EX1001
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

/*DIAB_eCOA_URI_Recon3b*/

data EX1001a(keep = SUBJECT EXSTDAT EXTPT_MORNING);
set EX1001;
where EXTPT = 'MORNING MEAL';
rename EXTPT = EXTPT_MORNING;
run;

data EX1001b(keep = SUBJECT EXSTDAT EXTPT_MIDDAY);
set EX1001;
where EXTPT = 'MIDDAY MEAL';
rename EXTPT = EXTPT_MIDDAY;
run;

data EX1001c(keep = SUBJECT EXSTDAT EXTPT_EVENING);
set EX1001;
where EXTPT = 'EVENING MEAL';
rename EXTPT = EXTPT_EVENING;
run;

data EX1001_2;
merge EX1001(in=a) EX1001a EX1001b EX1001c;
by SUBJECT EXSTDAT;
if a;
run;

data DIAB_eCOA_URI_Recon3b;
retain SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT;
set EX1001_2;
where EXSTDAT is not null and (EXTPT_MORNING is null or EXTPT_MIDDAY is null or EXTPT_EVENING is null);
drop EXTPT_MORNING EXTPT_MIDDAY EXTPT_EVENING;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "DIAB_eCOA_URI_Recon3b";
  title2 "Exception based report to identify missing Meals from EX1001";

proc print data=DIAB_eCOA_URI_Recon3b noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DIAB_eCOA_URI_Recon3b nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
