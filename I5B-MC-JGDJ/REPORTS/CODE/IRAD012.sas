/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : IRAD012.sas
PROJECT NAME (required)           : I5B_MC_JGDJ
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE4001A, AE4001B
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
data ds;
set clntrial.DS2001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
if page eq 'DS2001_LF1';
keep SUBJID DSSTDAT1;
run;
proc sort;
by subjid;
run;
data ir;
set clntrial.IRAD3001;
if IRADSTDAT ne . then
IRADSTDAT1 = datepart(IRADSTDAT);
if IRADENDAT ne . then
IRADENDAT1 = datepart(IRADENDAT);
format IRADSTDAT1 IRADENDAT1 date9.;
if page eq 'IRAD3001_LF2';
if page eq 'IRAD3001_LF2' then page = 'PR_IRAD_PD';
keep SUBJID PAGE PRSPID IRADSTDAT1 IRADENDAT1 IRADONGO IRADLOC IRADLOCOTH;
run;
proc sort;
by subjid ;
run;
data irs;
merge ir(in = a) ds(in = b);
by subjid;
if a and b;
run;
proc sort;
by subjid;
run;
data fin;
merge irs(in = a) dm;
by subjid;
if a;
run;
data final;
length flag $200.;
set fin;
if IRADENDAT1 ne . and DSSTDAT1 ne . and IRADENDAT1 < DSSTDAT1 then flag = 'End Date is before the informed consent date';
run;
data IRAD012;
retain SITEMNEMONIC SUBJID PAGE DSSTDAT PRSPID IRADSTDAT IRADENDAT IRADONGO IRADLOC IRADLOCOTH;
set final;
DSSTDAT = DSSTDAT1;
IRADENDAT = IRADENDAT1;
IRADSTDAT = IRADSTDAT1;
format DSSTDAT IRADSTDAT IRADENDAT date9.;
label DSSTDAT = 'Informed Consent Date' PAGE = 'Form Name' PRSPID = 'Sequence Identifier' IRADSTDAT = 'Start Date'
IRADENDAT = 'End Date' IRADONGO = 'Ongoing' IRADLOC = 'Anatomical Location' IRADLOCOTH = 'Irradiated Location - Other' 
SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number';
keep SITEMNEMONIC SUBJID PAGE DSSTDAT PRSPID IRADSTDAT IRADENDAT IRADONGO IRADLOC IRADLOCOTH FLAG;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "PR";
  title2 "The End date must be equal to or after the date of informed consent.";

proc print data=IRAD012 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set IRAD012 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

