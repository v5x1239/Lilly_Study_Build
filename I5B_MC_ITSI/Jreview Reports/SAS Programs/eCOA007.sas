/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : ECOA007.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : If subject discontinued prior to V801, no dates present in eCOA data are after subject study disposition.
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itsi\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code


**************************************** End of Header ******************************************/

/************************* Start of environment/input/output programming ************************/

options nofmterr;

/*eCOA007*/
/*If subject discontinued prior to V801, no dates present in eCOA data are after subject study disposition. */

proc sort data=CLUWE.eCOA_HEADER out=header005_; by SUBJID ECOAASMDT; where ECOAASMDT ne .; run;

data header005(keep=SITECODE SUBJECT SUBJID max_ECOAASMDT);
format max_ECOAASMDT date9.;
set header005_;
by subjid;
if not last.subjid then delete;
max_ECOAASMDT = ECOAASMDT;
run;

data header007_(keep=SUBJECT SUBJID max_ECOAASMDT);
set header005;
run;

data header007;
merge CLUWE.eCOA_HEADER(in=a) header007_;
by SUBJID;
if a;
run;

data ECOA007(keep=SITECODE SUBJECT DISCON_VISIT DSSTDAT max_ECOAASMDT);
retain SITECODE SUBJECT DISCON_VISIT DSSTDAT max_ECOAASMDT;
set header007;
where (discon_visit ne '' and input(discon_visit, ?8.) < 801) and (DSSTDAT ne . and max_ECOAASMDT > DSSTDAT);
proc sort nodupkey; by _all_; run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "ECOA007";
  title2 "If subject discontinued prior to V801, no dates present in eCOA data are after subject study disposition";

proc print data=ECOA007 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set ECOA007 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

