/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA004.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : check that visit dates for all datasets with visit variable match corresponding visit in Inform.
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

/*eCOA004*/
/*check that visit dates for all datasets with visit variable match corresponding visit in Inform*/

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

proc sort data=CLUWE.eCOA_HEADER out=header004; by SUBJID BLOCKID; run;

data eCOA004(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT;
merge header004(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and ECOAASMDT ne VISDAT;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA004";
  title2 "check that visit dates for all datasets with visit variable match corresponding visit in Inform";

proc print data=eCOA004 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA004 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

