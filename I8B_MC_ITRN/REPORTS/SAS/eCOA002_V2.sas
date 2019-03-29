/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA002.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : check that MMTT date is 0-4 days prior to corresponding visit.
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_ITRN\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code
2.0  Joe Cooney	   Update to replace ECOASMDT with EXSTDAT PRISM: 8588


**************************************** End of Header ******************************************/

/************************* Start of environment/input/output programming ************************/

options nofmterr;

/*eCOA002*/
/*check that MMTT date is 0-4 days prior to corresponding visit*/

data ecoa_ml1001(keep=SUBJECT SITECODE VISITNUM MLSTDAT SUBJID BLOCKID);
set CLUWE.ml1001_ecoa;
where visitnum ne . and MLSTDAT ne '';
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
    format MLSTDAT_DATE9 date9.;
drop MLSTDAT;
rename MLSTDAT_DATE9 = MLSTDAT;
proc sort; by SUBJID BLOCKID; run;

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data eCOA002(keep=SITECODE SUBJECT VISITNUM MLSTDAT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM MLSTDAT BLOCKID VISDAT;
merge ecoa_ml1001(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and (MLSTDAT > VISDAT or MLSTDAT < VISDAT -4);
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA002";
  title2 "check that MMTT date is 0-4 days prior to corresponding visit";

proc print data=eCOA002 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA002 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

