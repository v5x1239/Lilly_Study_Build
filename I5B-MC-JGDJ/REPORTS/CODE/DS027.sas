/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS027.sas
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
proc sort;
by SUBJID;
run;
proc sql;
create table ds as select SUBJID, BlockID, datepart(DSSTDAT) as DSSTDAT format date9. from
clntrial.DS1001 where DSSTDAT ne . and page = 'DS1001_F2'
order by SUBJID;
run;
data temp;
infile DATALINES dsd missover;
input form $5. form1 $5.;
CARDS;
HOSP HOSP
TRF  TRF
AE   AE
CM   CM
;
run;
proc sql;
create table ds1 as select a.subjid,b.form,b.form1 from ds a,temp b
order by subjid,form;
quit;
data hosp1;
set clntrial.HO2001A;
length form $5.;
form = 'HOSP';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data hosp2;
set clntrial.HO2001B;
length form $5.;
form = 'HOSP';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data cm1;
set clntrial.cm1001A;
length form $5.;
form = 'CM';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data cm2;
set clntrial.cm1001B;
length form $5.;
form = 'CM';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data ae1;
set clntrial.AE4001A;
length form $5.;
form = 'AE';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data ae2;
set clntrial.AE4001B;
length form $5.;
form = 'AE';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data trt1;
set clntrial.TRF3001A;
length form $5.;
form = 'TRF';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data trt2;
set clntrial.TRF3001B;
length form $5.;
form = 'TRF';
keep SUBJID form;
run;
proc sort nodup;
by SUBJID;
run;
data all;
set hosp1 hosp2 trt1 trt2 ae1 ae2 cm1 cm2;
by subjid;
run;
proc sort nodup;
by SUBJID form;
run;
data mer;
merge ds1(in = a) all(in = b);
by SUBJID form;
if a and not b;
run;
data fin;
merge ds(in = a) mer(in = b) dm;
by subjid;
if a and b;
run;
data DS027;
retain SITEMNEMONIC SUBJID blockid DSSTDAT;
set fin;
length flag $10.;
if form1 ne '' then flag = form1;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' blockid = 'Visit Number'
DSSTDAT  = 'Discontinuation date';
keep SITEMNEMONIC SUBJID blockid DSSTDAT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "DS";
  title2 "When DSSCAT = Study Disposition and DSSTDAT is present, then any other study specific running record CRFs should either have the YN item = No or at least one record should be present.";

proc print data=DS027 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set DS027 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

