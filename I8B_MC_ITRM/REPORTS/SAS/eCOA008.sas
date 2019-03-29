/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA008.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : If subject not discontinued at V801, no dates present in eCOA data are after V801. 
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

/*eCOA008*/
/*If subject not discontinued at V801, no dates present in eCOA data are after V801. */

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data sv1001_008;
set sv1001;
where BLOCKID = '801';
run;

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

data header007(drop=blockid);
merge CLUWE.eCOA_HEADER(in=a) header007_;
by SUBJID;
if a;
run;

data header008_;
set header007;
where input(discon_visit, ?8.) >= 801;
BLOCKID = discon_visit;
proc sort; by subjid blockid; run;

data header008;
merge header008_(in=a) sv1001_008(in=b);
by subjid;
if a and b and max_ECOAASMDT > VISDAT;
run;

data ECOA008(keep=SITECODE SUBJECT DISCON_VISIT DSSTDAT VISDAT max_ECOAASMDT);
retain SITECODE SUBJECT DISCON_VISIT DSSTDAT VISDAT max_ECOAASMDT;
set header008;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA008";
  title2 "If subject not discontinued at V801, no dates present in eCOA data are after V801.";

proc print data=eCOA008 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA008 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

