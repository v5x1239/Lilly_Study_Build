/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA724.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Check that Visit 8 MMTT lab collection date (Test Code I88) is the same as Visit 8 Meal Start Date
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

data ml1001(keep=SUBJID VISITNUM MLSTDAT );
set cluwe.ml1001_ecoa;
where VISITNUM = 8 and MLSTDAT ne '';
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
format MLSTDAT_DATE9 date9.;
drop MLSTDAT;
rename MLSTDAT_DATE9 = MLSTDAT;
proc sort; by SUBJID VISITNUM; run;

data clrm(keep= SITEID SUBJID VISITNUM TSTCD LBDTM);
set cluwe.clrm_lab;
where TSTCD = 'I88' and VISITNUM = '8' and LBDTM ne .;
LBDTM_DATE9 = datepart(LBDTM);
format LBDTM_DATE9 date9.;
drop LBDTM;
rename LBDTM_DATE9 = LBDTM;
VISITNUM_NUM = input(VISITNUM, 8.);
format VISITNUM_NUM 8.;
drop VISITNUM;
rename VISITNUM_NUM = VISITNUM;
SUBJID_NUM = input(SUBJID, 8.);
format SUBJID_NUM 8.;
drop SUBJID;
rename SUBJID_NUM = SUBJID;
proc sort; by SUBJID VISITNUM; run;

data eCOA724;
retain SITEID SUBJID VISITNUM TSTCD LBDTM MLSTDAT;
merge ml1001(in=a) clrm(in=b);
by SUBJID VISITNUM;
if a and b and MLSTDAT ne LBDTM;
proc sort nodupkey; by _all_; run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA724";
  title2 "Check that Visit 8 MMTT lab collection date (Test Code I88) is the same as Visit 8 Meal Start Date";

proc print data=eCOA724 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA724 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

