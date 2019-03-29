/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA002.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : check that MMTT date is 0-4 days prior to corresponding visit.
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

/*eCOA002*/
/*check that MMTT date is 0-4 days prior to corresponding visit*/

data ecoa_ex1001(keep=SUBJECT SITECODE VISITNUM EXCAT ECOAASMDT SUBJID BLOCKID);
set CLUWE.ex1001_ecoa;
where visitnum ne . and ECOAASMDT ne '' and EXCAT = 'EXPOSURES RELATIVE TO MIXED MEAL TOLERANCE TEST';
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by SUBJID BLOCKID; run;

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data eCOA002(keep=SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT;
merge ecoa_ex1001(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and (ECOAASMDT > VISDAT or ECOAASMDT < VISDAT -4);
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

