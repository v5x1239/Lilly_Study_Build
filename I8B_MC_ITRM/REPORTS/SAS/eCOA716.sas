/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA716.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Hypoglycemic Events associated with Visit 8 or Visit 18 should have an Event Date and Time within 0-4.5 hours after V8 or V18 MMTT Meal Start Date and Time in eCOA.
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

data hypo1001(keep=SITECODE SUBJECT VISITNUM HYPOSTDAT HYPOSTTIM HDATETIME);
set CLUWE.hypo1001_ecoa;
where HYPOSTDAT ne '' and HYPOSTTIM ne '';
HYPOSTDAT_DATE9 = input(HYPOSTDAT,yymmdd10.);
    format HYPOSTDAT_DATE9 date9. HYPOSTTIM_TIME5 time5. HDATETIME datetime20.;
HYPOSTTIM_TIME5 = input(HYPOSTTIM,hhmmss.);
drop HYPOSTDAT HYPOSTTIM;
rename HYPOSTDAT_DATE9 = HYPOSTDAT
	   HYPOSTTIM_TIME5 = HYPOSTTIM;
HDATETIME = DHMS(HYPOSTDAT_DATE9,0,0,HYPOSTTIM_TIME5);
proc sort; by SUBJECT VISITNUM; run;

data ml1001(keep=SITECODE SUBJECT VISITNUM MLSTDAT MLSTTIM MLDATETIME);
set CLUWE.ml1001_ecoa;
where MLSTDAT ne '' and MLSTTIM ne '';
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
    format MLSTDAT_DATE9 date9. MLSTTIM_TIME5 time5. MLDATETIME datetime20.;
MLSTTIM_TIME5 = input(MLSTTIM,hhmmss.);
drop MLSTDAT MLSTTIM;
rename MLSTDAT_DATE9 = MLSTDAT
	   MLSTTIM_TIME5 = MLSTTIM;
MLDATETIME = DHMS(MLSTDAT_DATE9,0,0,MLSTTIM_TIME5);
proc sort; by SUBJECT VISITNUM; run;

data ecoa716a;
merge hypo1001(in=a) ml1001(in=b);
by subject visitnum;
if a and b;
diffx = HDATETIME-MLDATETIME;
diff = diffx/3600;
proc sort; by subject HDATETIME; run;

data ecoa716b;
set ecoa716a;
where diff >= 0 and diff <= 4.5;
proc sort nodupkey; by subject HDATETIME; run;

data eCOA716(drop=MLSTDAT MLSTTIM MLDATETIME HDATETIME diffx diff);
retain SITECODE SUBJECT VISITNUM HYPOSTDAT HYPOSTTIM;
merge ecoa716a(in=a) ecoa716b(in=b);
by subject HDATETIME;
if a and not b;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA716";
  title2 "Hypoglycemic Events associated with Visit 8 or Visit 18 should have an Event Date and Time within 0-4.5 hours after V8 or V18 MMTT Meal Start Date and Time in eCOA.";

proc print data=eCOA716 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA716 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

