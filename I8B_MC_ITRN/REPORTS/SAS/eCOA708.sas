/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA708.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Check dates of Treatment Interruption against eCOA Study Treatment data to confirm no doses are present during dates of interruption..
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

data ecoa_ex1001(keep=SUBJID EXSTDAT_ECOA);
set CLUWE.ex1001_ecoa;
where EXSTDAT ne '';
EXSTDAT_DATE9 = input(EXSTDAT,yymmdd10.);
    format EXSTDAT_DATE9 date9.;
drop EXSTDAT;
rename EXSTDAT_DATE9 = EXSTDAT_ECOA;
proc sort; by SUBJID; run;

data ex1001(keep=SUBJID EXSTDAT EXENDAT);
set CLUWE.ex1001;
where input(catx("-",EXSTDATMO,EXSTDATDD,EXSTDATYY),mmddyy10.) ne . and 
	  input(catx("-",EXENDATMO,EXENDATDD,EXENDATYY),mmddyy10.) ne . and
	  PAGE = 'EX1001_F1';
EXSTDAT = input(catx("-",EXSTDATMO,EXSTDATDD,EXSTDATYY),mmddyy10.);
EXENDAT = input(catx("-",EXENDATMO,EXENDATDD,EXENDATYY),mmddyy10.);
    format EXSTDAT EXENDAT date9.;
proc sort; by SUBJID; run;

data eCOA708;
retain subjid EXSTDAT_ECOA EXSTDAT EXENDAT;
merge ecoa_ex1001(in=a) ex1001(in=b);
by subjid;
if a and b and (EXSTDAT_ECOA > EXSTDAT AND EXSTDAT_ECOA < EXENDAT);
proc sort nodupkey; by _all_; run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA708";
  title2 "Check dates of Treatment Interruption against eCOA Study Treatment data to confirm no doses are present during dates of interruption.";

proc print data=eCOA708 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA708 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

