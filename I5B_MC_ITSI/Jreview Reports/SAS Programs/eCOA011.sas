/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA011.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Output records where HYPOEVAL="INVESTIGATOR" and HYPOSER=null where HYPOSTDAT and  HYPOSTTIM are equal to record with same date/time and HYTRTPRV="SUBJECT NOT CAPABLE OF
									TREATING SELF AND REQUIRED ASSISTANCE"
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itsi\data\shared\*.*
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

/*eCOA011*/
/*Output records where HYPOEVAL="INVESTIGATOR" and HYPOSER=null where HYPOSTDAT and  HYPOSTTIM are equal to record with same date/time and HYTRTPRV="SUBJECT NOT CAPABLE OF
TREATING SELF AND REQUIRED ASSISTANCE"*/

data eCOA011a(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOEVAL);
set CLUWE.hypo1001_ECOA;
where HYPOEVAL="INVESTIGATOR";
proc sort; by SUBJECT HYPOSTDAT HYPOSTTIM; run;

data eCOA011b(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV);
set CLUWE.hypo1001_ECOA;
where HYPOTRTPRV="SUBJECT NOT CAPABLE OF TREATING SELF AND REQUIRED ASSISTANCE";
proc sort; by SUBJECT HYPOSTDAT HYPOSTTIM; run;

data eCOA011(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV HYPOEVAL);
retain SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV HYPOEVAL;
merge eCOA011a(in=a) eCOA011b(in=b);
by SUBJECT HYPOSTDAT HYPOSTTIM;
if b and not a;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA011";
  title2 "Output records where HYPOEVAL=INVESTIGATOR and HYPOSER=null where HYPOSTDAT and  HYPOSTTIM are equal to record with same date/time and HYTRTPRV=SUBJECT NOT CAPABLE OF
TREATING SELF AND REQUIRED ASSISTANCE";

proc print data=eCOA011 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA011 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
