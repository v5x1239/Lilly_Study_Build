/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM028.sas
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
data cm;
set clntrial.cm1001_J;
CMSTDAT1 = datepart(CMSTDAT);
CMENDAT1 = datepart(CMENDAT);
format CMSTDAT1 CMENDAT1 date9.;
id = CMAEGRPID4;
label CMSPID = 'CM number' CMTRT = 'Medication Term' CMINDC = 'CM Indication'
CMAEGRPID4 = 'AE group ID' CMONGO = 'Ongoing';
keep SUBJID CMSPID CMTRT CMINDC CMAEGRPID4 CMSTDAT1 CMENDAT1 id;
run;
proc sort;
by subjid ID;
run;
data ae1;
set clntrial.AE4001a;
keep SUBJID AEGRPID AETERM;
run;
proc sort;
by subjid AEGRPID;
run;
data ae2;
set clntrial.AE4001b;
AESTDAT1 = datepart(AESTDAT);
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESTDAT1 AEENDAT1 AEONGO;
run;
proc sort;
by subjid AEGRPID AESTDAT1;
run;
data ae3;
set ae2;
by subjid AEGRPID AESTDAT1;
if first.AEGRPID;
run;
data ae;
merge ae1 ae3;
by subjid AEGRPID;
id = AEGRPID;
run;
proc sort;
by subjid ID;
run;
data fin;
merge cm(in = a) ae;
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
data CM028;
retain SITEMNEMONIC SUBJID CMSPID CMTRT CMINDC CMAEGRPID4 CMSTDAT CMENDAT AEGRPID AETERM AESTDAT AEENDAT AEONGO;
set final;
page = page1;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
CMSTDAT = CMSTDAT1;
CMENDAT = CMENDAT1;
if CMSTDAT1 ne . and AESTDAT1 ne . and CMSTDAT1 < AESTDAT1;
format AESTDAT AEENDAT CMSTDAT CMENDAT date9.;
label AEGRPID = 'AE Group ID' AETERM = 'Event Term' AESTDAT = 'AE Start date'
AEENDAT = 'AE End date' AEONGO = 'Ongoing'
SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number';
keep SITEMNEMONIC SUBJID CMSPID CMTRT CMINDC CMAEGRPID4 CMSTDAT CMENDAT AEGRPID AETERM AESTDAT AEENDAT AEONGO;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "ConMed";
  title2 "If 'Adverse Event' is selected as Indication, and the AE Group ID entered matches an AE Group ID in 
  Study Adverse Events CRF,  then the start date of the medication must be >= the start date of the associated Event ID.";

proc print data=CM028 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set CM028 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

