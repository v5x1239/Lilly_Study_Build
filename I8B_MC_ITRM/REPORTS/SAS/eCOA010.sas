/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA010.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : No dates present in eCOA data prior to Informed Consent.
SPECIFICATIONS (required)         : DEV Ticket
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

/************************* Start of environment/input/output programming ************************/

options nofmterr;

/*eCOA010*/
/*No dates present in eCOA data prior to Informed Consent.*/

data ds2001(keep=SUBJID DS_BLOCKID DSSTDAT_IC);
set CLUWE.ds2001;
if coalesce(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY) ne '' then
DSSTDAT_IC = mdy(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY);
format DSSTDAT_IC date9.;
DS_BLOCKID = BLOCKID;
if DSSTDAT_IC = . then delete;
proc sort; by subjid; run;

data header010;
merge CLUWE.eCOA_header(in=a) ds2001;
by subjid;
if a and ECOAASMDT ne . and ECOAASMDT < DSSTDAT_IC;
run;

data eCOA010(keep=SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC);
retain SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC;
set header010;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA010";
  title2 "No dates present in eCOA data prior to Informed Consent.";

proc print data=eCOA010 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA010 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
