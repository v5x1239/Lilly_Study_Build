/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH005.sas
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
data ae1;
set clntrial.AE3001a;
keep SUBJID AEGRPID AETERM AEDECOD AELLT DICT_DICTVER;
run;
proc sort;
by subjid AEGRPID;
run;
data ae2;
set clntrial.AE3001b;
if AESTDAT ne . then
AESTDAT1 = datepart(AESTDAT);
if AEENDAT ne . then
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESPID AESTDAT1 AEONGO AEENDAT1 AESEV;
run;
proc sort;
by subjid AEGRPID;
run;
data ae;
merge ae1(in = a) ae2(in = b);
by subjid AEGRPID;
if a;
cod = AEDECOD;
run;
proc sort;
by subjid cod;
run;
data mh;
set clntrial.mh7001;
if MHSTDAT ne . then
MHSTDAT1 = datepart(MHSTDAT);
if MHENDAT ne . then
MHENDAT1 = datepart(MHENDAT);
format MHSTDAT1 MHENDAT1 date9.;
cod = MHDECOD;
DOMAIN = 'MH';
DICT = DICT_DICTVER;
if MHSPID ne . and MHONGO eq 'Y';
keep SUBJID MHSPID MHTERM MHDECOD MHSTDAT1 MHONGO MHSEV DOMAIN MHENDAT1 MHLLT DICT MHSTDAT_C MHENDAT_C cod;
run;
proc sort;
by SUBJID COD;
run;
data aemh;
merge ae(in = a) mh(in = b);
by SUBJID COD;
if a and b;
run;
data lag;
set aemh;
length flag $50.;
if MHSEV eq AESEV and AESER ne 'Y' then flag = 'AESER is not marked as Serious';
run;
proc sort;
by SUBJID;
run;
data final;
merge lag(in = a) dm;
by subjid;
if a;
run;
data MH005;
retain SITEMNEMONIC SUBJID DOMAIN MHSPID MHTERM MHDECOD MHLLT DICT_DICTVER MHSTDAT_C MHONGO MHSEV MHENDAT_C 
AEGRPID AESPID AETERM AEDECOD AELLT DICT_DICTVER AESTDAT AEONGO AEENDAT AESEV flag;
set final;
label AEGRPID = 'AE GROUP ID' AESPID = 'AE NUMBER'  AETERM = 'ADVERSE EVENT' AEDECOD = 'DICTIONARY DERIVED TERM' 
AELLT = 'LOWEST LEVEL TERM' DICT_DICTVER = 'DICTIONARY VERSION' AESTDAT = 'START DATE' AEONGO = 'ONGOING'
AEENDAT = 'END DATE' AESEV = 'SEVERITY' SUBJID = 'SUBJECT ID' MHSPID = 'MH NUMBER' MHTERM = 'MEDICAL HISTORY TERM' 
MHDECOD = 'DICTIONARY DERIVED EVENT TERM' MHLLT = 'LOWEST LEVEL TERM' DICT = 'DICTIONARY VERSION'
MHSTDAT_C = 'START DATE' MHONGO = 'ONGOING' MHSEV = 'SEVERITY' MHENDAT_C = 'MHENDAT';
keep SITEMNEMONIC SUBJID DOMAIN MHSPID MHTERM MHDECOD MHLLT DICT_DICTVER MHSTDAT_C MHONGO MHSEV MHENDAT_C 
AEGRPID AESPID AETERM AEDECOD AELLT DICT_DICTVER AESTDAT AEONGO AEENDAT AESEV;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Pre-Existing Conditions and Medical History";
  title2 "If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of severity must be recorded or event must become serious.";

proc print data=MH005 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set MH005 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

