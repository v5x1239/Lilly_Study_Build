/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA706.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Check Last Dose Study Treatment (EX_LDOL/EX_LD) against latest Study Treatment date in eCOA.
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

data ex1001_ECOAa (keep=SUBJID max_EXSTDAT_ECOA);
format max_EXSTDAT_ECOA date9.;
set ecoa_ex1001;
by subjid;
if not last.subjid then delete;
max_EXSTDAT_ECOA = EXSTDAT;
run;

data ex1001_page(keep=SUBJID PAGE);
set CLUWE.ex1001;
where page = 'EX1001_C1LF4';
proc sort nodupkey; by SUBJID; run;

data ex1001(keep=SUBJID EXENDAT EXTRT);
set CLUWE.ex1001;
where input(catx("-",EXENDATMO,EXENDATDD,EXENDATYY),mmddyy10.) and EXTRT in ('OPEN LABEL TREATMENT', 'STUDY TREATMENT');
EXENDAT = input(catx("-",EXENDATMO,EXENDATDD,EXENDATYY),mmddyy10.);
    format EXENDAT date9.;
proc sort; by SUBJID EXENDAT; run;

data eCOA707(drop=page);
retain SUBJID EXTRT EXENDAT max_EXSTDAT_ECOA;
merge ex1001_ecoaa(in=a) ex1001(in=b) ex1001_page;
by subjid;
if a and b;
if PAGE = '' and EXTRT = 'OPEN LABEL TREATMENT' and EXENDAT ne max_EXSTDAT_ECOA then output;
if PAGE ne '' and EXTRT = 'STUDY TREATMENT' and EXENDAT ne max_EXSTDAT_ECOA then output;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA707";
  title2 "Check Last Dose Study Treatment (EX_LDOL/EX_LD) against latest Study Treatment date in eCOA.";

proc print data=eCOA707 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA707 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

