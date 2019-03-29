/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA719.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : If MMTT Meal Consumed is Yes, all other MMTT fields should  be complete.
SPECIFICATIONS (required)         :
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

options compress=yes;

/************************* Start of environment/input/output programming ************************/

data ml1001_ecoa(keep=SITECODE SUBJID VISITNUM MLSTDAT DAT MLOCCUR MLDOSTXT MLSTDAT MLSTTIM MLENDAT MLENTIM);
set CLUWE.ml1001_ecoa;
where MLSTDAT ne '' and MLOCCUR = 'YES';
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
    format MLSTDAT_DATE9 DAT date9.;
drop MLSTDAT;
rename MLSTDAT_DATE9 = MLSTDAT;
DAT = MLSTDAT_DATE9;
proc sort; by SUBJID VISITNUM DAT; run;

data ex1001_ecoa(keep=SITECODE SUBJID VISITNUM EXSTDAT DAT EXDOSE EXDOSEU EXSTTIM);
set CLUWE.ex1001_ecoa;
where EXSTDAT ne '';
EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
    format EXSTDAT_DATE9 DAT date9.;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT;
DAT = EXSTDAT_DATE9;
proc sort; by SUBJID VISITNUM DAT; run;

data eCOA719;
retain SITECODE SUBJID VISITNUM MLSTDAT DAT MLOCCUR MLDOSTXT MLSTDAT MLSTTIM MLENDAT MLENTIM EXSTDAT DAT EXDOSE EXDOSEU EXSTTIM;
merge ml1001_ecoa(in=a) ex1001_ecoa(in=b);
by SUBJID VISITNUM DAT;
if a and b 
and (MLDOSTXT = '' or MLSTTIM = '' or MLENDAT = '' or MLENTIM = '' or EXDOSE = . or EXDOSEU = '' or EXSTTIM = '');
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA719";
  title2 "If MMTT Meal Consumed is Yes, all other MMTT fields should  be complete.";

proc print data=eCOA719 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA719 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

