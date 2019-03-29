/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA727.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Check MMTT Insulin Dose date/time is between 0-5 minutes prior to  Meal Start Date/time for same visit
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

data ml1001_ecoa(keep=SITECODE SUBJID VISITNUM MLSTDAT MLSTTIM);
set CLUWE.ml1001_ecoa;
where MLSTDAT ne '';
	MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
format MLSTDAT_DATE9 date9.;
drop MLSTDAT;
rename MLSTDAT_DATE9 = MLSTDAT;
	MLSTTIM_TIME5 = input(MLSTTIM,hhmmss.);
format MLSTTIM_TIME5 time5.;
drop MLSTTIM;
rename MLSTTIM_TIME5 = MLSTTIM;
proc sort; by SUBJID VISITNUM; run;

data ex1001_ecoa(keep=SITECODE SUBJID VISITNUM EXSTDAT EXSTTIM);
set CLUWE.ex1001_ecoa;
where EXSTDAT ne '' and EXSTTIM ne '';
	EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
format EXSTDAT_DATE9 date9.;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT;
	EXSTTIM_TIME5 = input(EXSTTIM,hhmmss.);
format EXSTTIM_TIME5 time5.;
drop EXSTTIM;
rename EXSTTIM_TIME5 = EXSTTIM;
proc sort; by SUBJID VISITNUM; run;

data eCOA727;
retain SITECODE SUBJID VISITNUM MLSTDAT EXSTDAT;
merge ml1001_ecoa(in=a) ex1001_ecoa(in=b);
by SUBJID VISITNUM ;
if a and b and MLSTDAT = EXSTDAT and (((EXSTTIM + 300) < MLSTTIM) or (EXSTTIM >  MLSTTIM));
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA727";
  title2 "Check MMTT Insulin Dose date/time is between 0-5 minutes prior to  Meal Start Date/time for same visit";

proc print data=eCOA727 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA727 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

