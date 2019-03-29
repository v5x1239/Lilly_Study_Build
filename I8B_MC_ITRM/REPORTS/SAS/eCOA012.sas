/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA012.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Output records where HYPOSER=YES and no AE record where AEDECOD="HYPOGLYCAEMIA" and AESER=Y and HYPOSTDAT=AESTDAT"
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

/*eCOA012*/
/*Output records where HYPOSER=YES and no AE record where AEDECOD="HYPOGLYCAEMIA" and AESER=Y and HYPOSTDAT=AESTDAT"*/

data ae3001a(keep=SUBJID AETERM AEDECOD AEGRPID);
set CLUWE.ae3001a;
where upcase(AEDECOD) = 'HYPOGLYCAEMIA';
proc sort; by SUBJID AEGRPID; run;

data ae3001b(keep=SUBJID AEGRPID AESTDAT AEENDAT AEONGO AESER DATE);
set CLUWE.ae3001b;
where aeser = 'Y';
if coalesce(AESTDATMO,AESTDATDD,AESTDATYY) ne '' then
AESTDAT = mdy(AESTDATMO,AESTDATDD,AESTDATYY);
DATE = mdy(AESTDATMO,AESTDATDD,AESTDATYY);
if coalesce(AEENDATMO,AEENDATDD,AEENDATYY) ne '' then
AEENDAT = mdy(AEENDATMO,AEENDATDD,AEENDATYY);
format AESTDAT AEENDAT DATE date9.;
proc sort; by SUBJID AEGRPID; run;

data ae3001;
merge ae3001a(in=a) ae3001b(in=b);
by subjid aegrpid;
if a and b;
proc sort; by SUBJID DATE; run;

data hypo011(keep=SITECODE SUBJECT SUBJID ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT DATE);
set CLUWE.hypo1001_ECOA;
where HYPOSER = 'YES';
DATE = mdy(scan(HYPOSTDAT,2,'-'), scan(HYPOSTDAT,3,'-'), scan(HYPOSTDAT,1,'-'));
format DATE date9.;
proc sort; by subjid DATE; run;

data hypoae;
merge hypo011(in=a) ae3001(in=b);
by SUBJID DATE;
if a and not b;
run;

data ECOA012(keep=SITECODE SUBJECT ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT);
retain SITECODE SUBJECT ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT;
set hypoae;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA012";
  title2 "Output records where HYPOSER=YES and no AE record where AEDECOD=HYPOGLYCAEMIA and AESER=Y and HYPOSTDAT=AESTDAT";
proc print data=eCOA012 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA012 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
