/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH006.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : AA001 - Place holder for Report name - Add descripton here
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : 
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  PremKumar     	  Original version of the code*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
data mh;
set clntrial.mh7001;
cod = MHDECOD;
if MHSTDAT ne . then
MHSTDAT1 = datepart(MHSTDAT);
if MHENDAT ne . then
MHENDAT1 = datepart(MHENDAT);
format MHSTDAT1 MHENDAT1 date9.;
keep SUBJID MHSPID MHTERM MHDECOD MHSTDAT1 MHONGO MHSEV MHENDAT1 MHLLT DICT_DICTVER cod;
run;
proc sort;
by SUBJID MHDECOD MHSTDAT1;
run;
data ae1;
set clntrial.AE3001a;
cod = AEDECOD;
keep SUBJID AEGRPID AETERM AEDECOD cod;
run;
proc sort;
by subjid AEGRPID;
run;
data ae21;
set clntrial.AE3001b;
if AESTDAT ne . then
AESTDAT1 = datepart(AESTDAT);
if AEENDAT ne . then
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESPID AESTDAT1 AEONGO AEENDAT1
AESEV AESER AERELDVC AEREL;
run;
proc sort;
by subjid AEGRPID AESPID AESTDAT1;
run;
data ae2;
set ae21;
by subjid AEGRPID AESPID AESTDAT1;
if first.AESPID then f1 = '#';
run;
proc sort;
by subjid AEGRPID;
run;
data ae;
merge ae1 ae2;
by subjid AEGRPID;
id = AEGRPID;
run;
proc sort;
by subjid COD;
run;
data aemh;
merge mh(in = a) ae(in = b);
by subjid COD;
if a and b;
run;
data fin;
set aemh;
if f1 ne '' and AESTDAT1 ne . and MHENDAT1 ne . then diff = AESTDAT1 - MHENDAT1;
if diff ne . and diff lt 1;
run;
proc sort;
by SUBJID;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data MH006;
retain SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD MHLLT DICT_DICTVER MHSTDAT MHONGO MHENDAT MHSEV AEGRPID  
AESPID AETERM AEDECOD AESTDAT AEONGO AEENDAT AESEV AESER AEREL AERELDVC;
set final;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
MHSTDAT = MHSTDAT1;
MHENDAT = MHENDAT1;
format MHSTDAT MHENDAT AESTDAT AEENDAT date9.;
keep SITEMNEMONIC SUBJID MHSPID MHTERM MHDECOD MHLLT DICT_DICTVER MHSTDAT MHONGO MHENDAT MHSEV AEGRPID  
AESPID AETERM AEDECOD AESTDAT AEONGO AEENDAT AESEV AESER AEREL AERELDVC;
run;
proc sort;
by SUBJID MHDECOD MHSTDAT;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Pre-Existing Conditions and Medical History";
  title2 "If an identical term is entered in MH and AE forms, AE start date must be more than 1 day after MH stop date";

proc print data=MH006 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set MH006 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

