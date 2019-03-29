/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA009.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : No dates present in eCOA data between Informed Consent and V2 in Inform.
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

/*eCOA009*/
/*No dates present in eCOA data between Informed Consent and V2 in Inform.*/

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data sv1001_009;
set sv1001;
where BLOCKID = '2' and VISDAT ne .;
SV_BLOCKID = BLOCKID;
drop blockid;
run;

data ds2001(keep=SUBJID DS_BLOCKID DSSTDAT_IC);
set CLUWE.ds2001;
if coalesce(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY) ne '' then
DSSTDAT_IC = mdy(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY);
format DSSTDAT_IC date9.;
DS_BLOCKID = BLOCKID;
if DSSTDAT_IC = . then delete;
proc sort; by subjid; run;

data header009;
merge CLUWE.eCOA_HEADER(in=a) sv1001_009(in=b) ds2001(in=c);
by subjid;
if a and ECOAASMDT > DSSTDAT_IC and ECOAASMDT < VISDAT;
run;

data eCOA009(keep=SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC SV_BLOCKID VISDAT);
retain SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC SV_BLOCKID VISDAT;
set header009;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA009";
  title2 "No dates present in eCOA data between Informed Consent and V2 in Inform.";

proc print data=eCOA009 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA009 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
