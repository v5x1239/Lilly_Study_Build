/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE058.sas
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
data ex;
length page1 $20.;
set clntrial.ex1001b;
EXSTDAT1 = datepart(EXSTDAT);
EXENDAT1 = datepart(EXENDAT);
format EXSTDAT1 EXENDAT1 date9.;
id = AEGRPRL4;
if page = 'EX1001_LF1' then page1 = 'EX_INF_LY/PLCB_D1';
if page = 'EX1001_F2' then page1 = 'EX_INF_DOX_D1';
if page = 'EX1001_F3' then page1 = 'EX_INF_LY/PLCB_D8';
if upcase(EXDSAJTP) = 'DOSE REDUCED';
keep SUBJID PAGE1 BLOCKID EXDSAJTP AEGRPRL4 EXSTDAT1 EXENDAT1 id;
run;
proc sort;
by subjid ID;
run;
data ae1;
set clntrial.AE4001a;
keep SUBJID AEGRPID AETERM AEDECOD;
run;
proc sort;
by subjid AEGRPID;
run;
data ae2;
set clntrial.AE4001b;
AESTDAT1 = datepart(AESTDAT);
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESPID AESTDAT1 AEENDAT1 AEONGO AEREL;
run;
proc sort;
by subjid AEGRPID AESPID;
run;
data ae;
merge ae1 ae2;
by subjid AEGRPID;
id = AEGRPID;
run;
proc sort;
by subjid ID;
run;
data fin;
merge ex(in = a) ae;
by subjid id;
if a;
run;
proc sort;
by subjid;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data AE058;
retain SITEMNEMONIC SUBJID PAGE BLOCKID EXDSAJTP AEGRPRL4 EXSTDAT EXENDAT AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AEREL;
set final;
page = page1;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
EXSTDAT = EXSTDAT1;
EXENDAT = EXENDAT1;
format AESTDAT AEENDAT EXENDAT EXSTDAT date9.;
label AEGRPID = 'AE Group ID' AESPID = 'AE Identifier' AETERM = 'Event Term' AEDECOD = 'Dictionary Derived Term'
AESTDAT = 'AE Start date' AEENDAT = 'AE End date' AEONGO = 'Ongoing' AEREL = 'Related to study treatment'
SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' PAGE = 'Form Name' BLOCKID = 'Visit' EXDSAJTP = 'Dose Adjustment Type'
AEGRPRL4 = 'Adverse Event' EXSTDAT = 'Treatment Start Date' EXENDAT = 'Treatment End Date';
keep SITEMNEMONIC SUBJID PAGE BLOCKID EXDSAJTP AEGRPRL4 EXSTDAT EXENDAT AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AEREL;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "when study drug treatment start dates and study drug treatment end dates are captured repeatedly in trial:  
If 'Drug Interrupted', there must be an entry in EX with End Date between Event's Start Date and Event's End Date.";

proc print data=AE058 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE058 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

