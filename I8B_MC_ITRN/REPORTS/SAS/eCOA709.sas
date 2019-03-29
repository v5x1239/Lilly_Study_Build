/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA709.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Check that the date of Severe Hypoglycemic events associated with Visit 8 or Visit 18 match the date of MMTT dose for the corresponding visit.
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrn\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

options compress=yes;

/************************* Start of environment/input/output programming ************************/

data ex1001_ecoa(keep=SITECODE SUBJID VISITNUM EXSTDAT);
set CLUWE.ex1001_ecoa;
where EXSTDAT ne '' and visitnum ne .;
EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
    format EXSTDAT_DATE9 date9.;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT;
proc sort; by SITECODE SUBJID VISITNUM; run;

data hypo1001_ecoa(keep=SITECODE SUBJID VISITNUM HYPOSTDAT);
set CLUWE.hypo1001_ecoa;
where HYPOSTDAT ne '' and visitnum ne .;
HYPOSTDAT_DATE9 = input(HYPOSTDAT,yymmdd10.);
    format HYPOSTDAT_DATE9 date9.;
drop HYPOSTDAT;
rename HYPOSTDAT_DATE9 = HYPOSTDAT;
proc sort; by SITECODE SUBJID VISITNUM; run;

data eCOA709;
retain SITECODE SUBJID VISITNUM EXSTDAT HYPOSTDAT;
merge ex1001_ecoa(in=a) hypo1001_ecoa(in=b);
by SITECODE SUBJID VISITNUM;
if a and b and EXSTDAT ne HYPOSTDAT;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA709";
  title2 "Check that the date of Severe Hypoglycemic events associated with Visit 8 or Visit 18 match the date of MMTT dose for the corresponding visit.";

proc print data=eCOA709 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA709 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

