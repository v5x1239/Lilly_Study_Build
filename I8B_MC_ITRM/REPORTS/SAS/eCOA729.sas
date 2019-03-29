/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA729.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Check that Visit 18 MMTT Insulin Dose is the same as Visit 18 Meal Start Date.
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

data ml1001_ecoa(keep=SITECODE SUBJID VISITNUM MLSTDAT);
set CLUWE.ml1001_ecoa;
where VISITNUM = 18 ;
if MLSTDAT ne '' then do;
	MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
    format MLSTDAT_DATE9 date9.;
end;
drop MLSTDAT;
rename MLSTDAT_DATE9 = MLSTDAT;
proc sort; by SUBJID VISITNUM; run;

data ex1001_ecoa(keep=SITECODE SUBJID VISITNUM EXSTDAT);
set CLUWE.ex1001_ecoa;
where VISITNUM = 18 ;
if EXSTDAT ne '' then do;
	EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
    format EXSTDAT_DATE9 date9.;
end;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT;
proc sort; by SUBJID VISITNUM; run;

data eCOA729;
retain SITECODE SUBJID VISITNUM MLSTDAT EXSTDAT;
merge ml1001_ecoa(in=a) ex1001_ecoa(in=b);
by SUBJID VISITNUM ;
if a and b and MLSTDAT ne EXSTDAT;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA729";
  title2 "Check that Visit 18 MMTT Insulin Dose is the same as Visit 18 Meal Start Date";

proc print data=eCOA729 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA729 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

