/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GEN014B.sas
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
create table ds as select SUBJID,'DS_SUM_TRT' AS PAGENAME,datepart(DSSTDAT) as DSSTDAT format date9. from
clntrial.DS1001 where DSSTDAT ne . and page = 'DS1001_F2' AND  DSDECOD IN ('DEATH', 'WITHDRAWAL BY SUBJECT','STUDY TERMINATED BY IRB / ERB', 'STUDY TERMINATED BY SPONSOR',
'LOST TO FOLLOW UP') 
order by SUBJID;
run;
%Macro dt(dsn,dt);
data dt;
set clntrial.&dsn;
length variable form $20.;
variable = "&dt.";
form = "&dsn.";
IF &DT NE . THEN
date = datepart(&dt);
format date date9.;
keep subjid date variable form;
run;
proc append data=dt base=master;
run;
%Mend;
%Macro dt1(dsn,dt,PG);
data dt;
set clntrial.&dsn;
length variable form $20.;
variable = "&dt.";
form = "&dsn.";
IF &DT NE . THEN
date = datepart(&dt);
format date date9.;
IF PAGE EQ "&PG.";
keep subjid date variable form;
run;
proc append data=dt base=master;
run;
%Mend;
%Macro dt2(dsn,dt,PG);
data dt;
set clntrial.&dsn;
length variable form $20.;
variable = "&dt.";
form = "&PG.";
IF &DT NE . THEN
date = datepart(&dt);
format date date9.;
keep subjid date variable form;
run;
proc append data=dt base=master;
run;
%MEND;
%DT(SV1001,VISDAT);
%DT(MH8001,MHSTDAT);
%DT(MH8001,MHENDAT);
%DT(VS1001,VSDAT);
%DT(IRAD3001,IRADSTDAT);
%DT(IRAD3001,IRADENDAT);
%DT(SYST3001,SYSTSTDT);
%DT(SYST3001,SYSTENDT);
%DT(LB9001,LBDAT);
%DT(EX1001B,EXSTDAT);
%DT(EX1001B,EXENDAT);
%DT(RS1001,RSDAT);
%DT(QLQC2001,QLQCMDT);
%DT(PFS21001,PFS2DAT);
%DT(AE4001B,AESTDAT);
%DT(AE4001B,AEENDAT);
%DT(TU2001,TUDAT);
%DT(TU2001,TRDAT);
%DT(TU3001A,TUDAT);
%DT(TU3001B,TRDAT);
%DT(TU1001A_,TUDAT);
%DT(TU1001B,TRDAT);
%DT2(GENHO,HOSTDAT,HO2001);
%DT2(GENHO,HOENDAT,HO2001);
%DT2(GENTRF,TRFSTDAT,TRF3001);
%DT2(GENCM,CMSTDAT,CM1001B);
%DT2(GENCM,CMENDAT,CM1001B);
%DT2(GENEG,EGDAT,EG3001B);
%DT2(GENPR,PRSTDAT,PR1001B);
%DT2(GENEQ,EQ5D5LASMDAT,EQ5D5L1001B);
%DT2(GENEX,DSSTDAT,EX1001A);
%DT2(GENEX,EXPTRTDAT,EX1001A);
%DT2(GENSG,SGDAT,SG1001B);
%DT1(DS2001,DSSTDAT,DS2001_LF1);
PROC SORT DATA = MASTER;
BY SUBJID;
RUN;
DATA MER;
MERGE DS(IN = A) MASTER;
BY SUBJID;
IF A;
RUN;
DATA FINAL;
SET MER;
LENGTH FLAG $50.;
IF DATE NE . AND DSSTDAT NE . AND DATE GT DSSTDAT THEN FLAG = 'DSSTDAT is less than the date';
RUN;
PROC SORT;
BY SUBJID;
RUN;
data fin;
merge FINAL(in = a) dm;
by subjid;
if a;
run;
data GEN014B;
retain SITEMNEMONIC SUBJID PAGENAME DSSTDAT date variable form;
set fin;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number'
DSSTDAT  = 'Discontinuation date';
keep SITEMNEMONIC SUBJID PAGENAME DSSTDAT date variable form flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "General Data Review";
  title2 "Dates must be <= the subject's final disposition date";

proc print data=GEN014B noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set GEN014B nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

