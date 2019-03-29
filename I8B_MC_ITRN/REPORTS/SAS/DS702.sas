/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS702.sas
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

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
if input(SITEMNEMONIC,best.) ge 325 and input(SITEMNEMONIC,best.) le 374;
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
data ds;
set clntrial.DS1001;
if DSSTDAT ne . then
DSSTDAT1 = datepart(DSSTDAT);
format DSSTDAT1 date9.;
if page eq 'DS1001_LF2';
/*id = AEGRPID_RELREC;*/
keep SUBJID BLOCKID DSSTDAT1 /*AEGRPID_RELREC id*/;
run;
proc sort;
by subjid;
run;
data ex;
set clntrial.ex1001;
if EXENDAT ne . then
EXENDAT1 = datepart(EXENDAT);
format EXENDAT1 date9.;
if page in ('EX1001_LF5','EX1001_C1LF5');
keep SUBJID BLOCKID EXENDAT1;
run;
proc sort;
by subjid;
run;
data ae11;
set clntrial.AE3001a;
if upcase(AEDECOD) eq 'HYPOGLYCAEMIA';  
keep SUBJID AEGRPID AETERM AEDECOD;
run;
proc sql;
create table ae1 as select *,count(subjid) as cnt from ae11
group by subjid
having cnt > 1
order by subjid,AEDECOD;
quit; 
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
if upcase(AESEV) eq 'SEVERE' then flag = 'AESEV is Severe';
keep SUBJID AEGRPID AESPID AESTDAT1 AEONGO AEENDAT1 AESEV flag;
run;
proc sort;
by subjid AEGRPID;
run;
data ae;
merge ae1(in = a) ae2(in = b);
by subjid AEGRPID;
if a;
id = AEGRPID;
run;
proc sort;
by subjid id;
run;
data mer;
merge ds(in = a) ae(in = b) ex;
by subjid;
if b;
run;
proc sort;
by subjid;
run;
data final;
merge mer(in = a) dm(in = b);
by subjid;
if a and b;
run;
data DS702;
retain SITEMNEMONIC SUBJID AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT AESEV EXENDAT DSSTDAT;
set final;
EXENDAT = EXENDAT1;
DSSTDAT = DSSTDAT1;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
format DSSTDAT AESTDAT AEENDAT EXENDAT date9.;
keep SITEMNEMONIC SUBJID AEGRPID AETERM AEDECOD AESPID AESTDAT AEONGO AEENDAT AESEV DSSTDAT EXENDAT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Disposition Summary";
  title2 "For Germany sites only (sites 325-374):If more than one severe hypoglycemia event is recorded on AE/SAE forms, 
	confirm that subject is discontinued from study treatment on the EX_LD/DS_TRT forms";

proc print data=DS702 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS702 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

