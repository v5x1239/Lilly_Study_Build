/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA015.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : WPAI should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform"
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_ITRN\data\shared\*.*
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

/*eCOA015*/
/*WPAI should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform*/

data wpai2001(keep=SITECODE SUBJECT subjid blockid VISITNUM ECOAASMDT);
set CLUWE.wpai2001_ECOA;
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by subjid blockid; run;

data statgut13(keep=SUBJID blockid stat);
set CLUWE.statgut;
where stat = '100';
proc sort; by subjid blockid; run;

data sv1001(keep=SUBJID BLOCKID VISDAT);
set CLUWE.sv1001;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data wpaisvstat;
merge wpai2001(in=a) sv1001(in=b) statgut13(in=c);
by subjid blockid;
if a and b and c and ECOAASMDT ne VISDAT;
run;

data eCOA015(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT;
set wpaisvstat;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA015";
  title2 "WPAI should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform";
proc print data=eCOA015 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA015 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
