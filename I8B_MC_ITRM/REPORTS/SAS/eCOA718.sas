/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA718.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Check that MMTT Meal End date/time is 0-15 minutes after Meal Start date/time
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

data ml1001(keep=SITECODE SUBJECT VISITNUM MLSTDAT MLSTTIM MLENDAT MLENTIM stdatetime endatetime diff);
set CLUWE.ml1001_ecoa;
MLSTDAT_DATE9 = input(MLSTDAT,yymmdd10.);
MLENDAT_DATE9 = input(MLENDAT,yymmdd10.);
MLSTTIM_TIME5 = input(MLSTTIM,hhmmss.);
MLENTIM_TIME5 = input(MLENTIM,hhmmss.);
    format MLSTTIM_TIME5 MLENTIM_TIME5 diff time5. MLSTDAT_DATE9 MLENDAT_DATE9 date9. stdatetime endatetime datetime20.;
drop MLSTTIM MLENTIM MLSTDAT MLENDAT;
rename MLSTDAT_DATE9 = MLSTDAT
	   MLENDAT_DATE9 = MLENDAT
	   MLSTTIM_TIME5 = MLSTTIM
	   MLENTIM_TIME5 = MLENTIM;
stdatetime = DHMS(MLSTDAT_DATE9,0,0,MLSTTIM_TIME5);
endatetime = DHMS(MLENDAT_DATE9,0,0,MLENTIM_TIME5);
diff = endatetime - stdatetime;
proc sort; by SUBJECT VISITNUM stdatetime endatetime; run;

data eCOA718(drop = stdatetime endatetime diff);
retain SITECODE SUBJECT VISITNUM MLSTDAT MLSTTIM MLENDAT MLENTIM;
set ml1001;
where diff > 54000;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA718";
  title2 "Check that MMTT Meal End date/time is 0-15 minutes after Meal Start date/time";

proc print data=eCOA718 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA718 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

