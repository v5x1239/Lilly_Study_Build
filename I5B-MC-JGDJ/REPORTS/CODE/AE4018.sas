/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE4018.sas
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
data ex1;
set clntrial.EX1001b;
if page eq 'EX1001_LF1' and EXSTDAT ne . then EXSTDAT1 = datepart(EXSTDAT);
if EXSTDAT ne . then
date = EXSTDAT1;
format EXSTDAT1 date date9.;
keep SUBJID EXSTDAT1 date;
if EXSTDAT1 ne .;
run;
proc sort;
by subjid;
run;
data ex2;
set clntrial.EX1001b;
if page eq 'EX1001_F2' and EXSTDAT ne . then EXSTDAT2 = datepart(EXSTDAT);
if EXSTDAT ne . then
date = EXSTDAT2;
format EXSTDAT2 date date9.;
keep SUBJID EXSTDAT2 date;
if EXSTDAT2 ne .;
run;
proc sort;
by subjid;
run;
data ex3;
set clntrial.EX1001b;
if page eq 'EX1001_F3' and EXSTDAT ne . then EXSTDAT3 = datepart(EXSTDAT);
if EXSTDAT ne . then
date = EXSTDAT3;
format EXSTDAT3 date date9.;
keep SUBJID EXSTDAT3 date;
if EXSTDAT3 ne .;
run;
proc sort;
by subjid;
run;
data ex;
set ex1 ex2 ex3;
by subjid;
date0 = date;
date1 = date + 7;
format date1 date0 date9.;
run;
proc sort;
by subjid date;
run;
data ae1;
set clntrial.AE4001a;
label CTCLLTCD = 'CTCLLTCD';
keep SUBJID AEGRPID AETERM AEDECOD CTCLLTCD;
run;
proc sort;
by subjid AEGRPID;
run;
data ae2;
set clntrial.AE4001b;
if AESTDAT ne . then
date = datepart(AESTDAT);
if AESTDAT ne . then
AESTDAT1 = datepart(AESTDAT);
if AEENDAT ne . then
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date date9.;
if AEHEIRR eq 'Y' and AETELTMT eq 'GREATER THAN 24 HOURS - 7 DAYS';
keep SUBJID AEGRPID AESPID AESTDAT1 AEENDAT1 AEONGO AEREL AETOXGR 
AESER AEOUT AEHEIRR AELOC AELOCOTH AELOCMD AETELTMT date;
run;
proc sort;
by subjid AEGRPID AESPID;
run;
data ae;
merge ae1 ae2(in = a);
by subjid AEGRPID;
if a;
if AEHEIRR eq 'Y' and AETELTMT eq 'GREATER THAN 24 HOURS - 7 DAYS';
run;
proc sort;
by subjid date;
run;
/*data fin;*/
/*merge ae(in = a) ex;*/
/*by subjid date;*/
/*if a;*/
/*run;*/
proc sql;
create table fin as select a.SUBJID, a.AETERM, a.AEDECOD, a.CTCLLTCD,a.AEGRPID, a.AESPID, a.AESTDAT1 as AESTDAT format date9., a.AEENDAT1 as AEENDAT format date9., a.AEONGO, a.AEREL, a.AETOXGR, 
a.AESER, a.AEOUT, a.AEHEIRR, a.AELOC, a.AELOCOTH, a.AELOCMD, a.AETELTMT,b.EXSTDAT1,b.EXSTDAT2,b.EXSTDAT3 from ae a, ex b
where a.subjid eq b.subjid;
quit;
data fin1;
set fin;
if AESTDAT ne . and EXSTDAT1 ne . then diff = AESTDAT - EXSTDAT1;
if AESTDAT ne . and EXSTDAT2 ne . then diff = AESTDAT - EXSTDAT2;
if AESTDAT ne . and EXSTDAT3 ne . then diff = AESTDAT - EXSTDAT3;
run;
proc sort;
by subjid;
run;
data final;
merge fin1(in = a) dm;
by subjid;
run;
data AE4018;
retain SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD CTCLLTCD AESTDAT AEENDAT AEONGO AETOXGR 
AESER AEREL AEOUT AEHEIRR AELOC AELOCOTH AELOCMD AETELTMT EXSTDAT1 EXSTDAT2 EXSTDAT3 diff;
set final;
if AEHEIRR eq 'Y' and AETELTMT eq 'GREATER THAN 24 HOURS - 7 DAYS';
label AEGRPID = 'AE Group ID' AESPID = 'AE Identifier' AETERM = 'Event Term' AEDECOD = 'Dictionary Derived Term'
AESTDAT = 'AE Start date' AEENDAT = 'AE End date' AEONGO = 'Ongoing' AETOXGR = 'AE CTCAE Grade' AESER = 'Seriousness'
AEREL = 'Related to study treatment' AEOUT = 'Outcome' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number'
CTCLLTCD = 'CTCAE Code' AEHEIRR = 'Hypersensitivity event or infusion-related reaction' AELOC = 'Anatomical location Adverse Event'
AELOCOTH = 'AE Location, Other specify' AELOCMD = 'Location not required' AETELTMT = 'Event Start Time Relative to Study Treatment Administration'
EXSTDAT1 = 'LY3012207/Placebo– Day 1' EXSTDAT2 = 'Doxorubicin – Day 1' EXSTDAT3 = 'LY3012207/Placebo– Day 8' diff = 'Days Difference';
keep SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD CTCLLTCD AESTDAT AEENDAT AEONGO AETOXGR 
AESER AEREL AEOUT AEHEIRR AELOC AELOCOTH AELOCMD AETELTMT EXSTDAT1 EXSTDAT2 EXSTDAT3 diff;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "If AEHEIRR = Y, and AETELTMT = > 24 Hours - 7 Days, AESTDAT must be within 7 Days of EXSTDAT";

proc print data=AE4018 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE4018 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

