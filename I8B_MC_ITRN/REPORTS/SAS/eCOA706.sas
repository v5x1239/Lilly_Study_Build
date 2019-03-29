/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA706.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Check First Dose Open Label Treatment (EX_FDOL) against earliest Study Treatment date in eCOA.
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

data ecoa_ex1001(keep=SUBJID EXSTDAT);
set CLUWE.ex1001_ecoa;
where EXSTDAT ne '';
EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
    format EXSTDAT_DATE9 date9.;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT;
proc sort; by SUBJID EXSTDAT; run;

data ex1001_ECOAa (keep=SUBJID min_EXSTDAT_ECOA);
format min_EXSTDAT_ECOA date9.;
set ecoa_ex1001;
by subjid;
if not first.subjid then delete;
min_EXSTDAT_ECOA = EXSTDAT;
run;

data ex1001(keep=SUBJID EXSTDAT);
set CLUWE.ex1001;
where input(catx("-",EXSTDATMO,EXSTDATDD,EXSTDATYY),mmddyy10.) ne .;
EXSTDAT = input(catx("-",EXSTDATMO,EXSTDATDD,EXSTDATYY),mmddyy10.);
    format EXSTDAT date9.;
proc sort; by SUBJID EXSTDAT; run;

data ex1001a (keep=SUBJID min_EXSTDAT);
format min_EXSTDAT date9.;
set ex1001;
by subjid;
if not first.subjid then delete;
min_EXSTDAT = EXSTDAT;
run;

data eCOA706;
retain subjid min_EXSTDAT_ECOA min_EXSTDAT;
merge ex1001_ecoaa(in=a) ex1001a(in=b);
by subjid;
if a and b and min_EXSTDAT_ECOA ne min_EXSTDAT;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA706";
  title2 "Check First Dose Open Label Treatment (EX_FDOL) against earliest Study Treatment date in eCOA.";

proc print data=eCOA706 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA706 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

