/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA005.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : eCOA data exists with date after V2 date in Inform if subject is continuing at V2 in Inform.
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

/*eCOA005*/
/*eCOA data exists with date after V2 date in Inform if subject is continuing at V2 in Inform*/

proc sort data=CLUWE.eCOA_HEADER out=header005_; by SUBJID ECOAASMDT; where ECOAASMDT ne .; run;

data header005(keep=SITECODE SUBJECT SUBJID max_ECOAASMDT);
format max_ECOAASMDT date9.;
set header005_;
by subjid;
if not last.subjid then delete;
max_ECOAASMDT = ECOAASMDT;
run;

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data header005_sv;
merge header005(in=a) sv1001(in=b);
by subjid;
if a and b and blockid = '2';
proc sort; by subjid blockid; run;

data statgut2(keep=SUBJID blockid stat);
set CLUWE.statgut;
where stat = '100' and blockid = '2';
proc sort; by subjid blockid; run;

data ECOA005(keep = SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT);
retain SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT;
merge header005_sv(in=a) statgut2(in=b);
by subjid blockid;
if a and b and max_ECOAASMDT < VISDAT;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA005";
  title2 "eCOA data exists with date after V2 date in Inform if subject is continuing at V2 in Inform";

proc print data=eCOA005 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA005 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

