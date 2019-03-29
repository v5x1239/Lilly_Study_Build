/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE072.sas
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
data ds1;
set clntrial.DS1001;
if page eq 'DS1001_F1' and DTHDAT ne . then DTHDAT_DS1F1 = datepart(DTHDAT);
if DTHDAT ne . then
date = DTHDAT_DS1F1;
format DTHDAT_DS1F1 date date9.;
sid = AEGRPREL;
label DTHDAT_DS1F1 = 'Death date for SF';
keep SUBJID DTHDAT_DS1F1 date sid;
if DTHDAT_DS1F1 ne .;
run;
proc sort;
by subjid;
run;
data ds2;
set clntrial.DS1001;
if page eq 'DS1001_F2' and DTHDAT ne . then DTHDAT_DS1F2 = datepart(DTHDAT);
if DTHDAT ne . then
date = DTHDAT_DS1F2;
format DTHDAT_DS1F2 date date9.;
label DTHDAT_DS1F2 = 'Death date for treatment SUM';
sid = AEGRPREL;
keep SUBJID DTHDAT_DS1F2 date sid;
if DTHDAT_DS1F2 ne .;
run;
proc sort;
by subjid;
run;
data ds3;
set clntrial.DS1001;
if page eq 'DS1001_F4' and DTHDAT ne . then DTHDAT_DS1F4 = datepart(DTHDAT);
if DTHDAT ne . then
date = DTHDAT_DS1F4;
format DTHDAT_DS1F4 date date9.;
sid = AEGRPREL;
label DTHDAT_DS1F4 = 'Death date for Continued Access Period';
keep SUBJID DTHDAT_DS1F4 date sid;
if DTHDAT_DS1F4 ne .;
run;
proc sort;
by subjid;
run;
data ds4;
set clntrial.SS1001_D;
if page eq 'SS1001_DS1001_LF1' and DTHDAT ne . then DTHDAT_SS1DS1F1 = datepart(DTHDAT);
if DTHDAT ne . then
date = DTHDAT_SS1DS1F1;
format DTHDAT_SS1DS1F1 date date9.;
sid = AEGRPID_RELREC;
label DTHDAT_SS1DS1F1 = 'Death date for Post Discontinuation Follow-up';
keep SUBJID DTHDAT_SS1DS1F1 date sid;
if DTHDAT_SS1DS1F1 ne .;
run;
proc sort;
by subjid;
run;
data ds;
merge ds1 ds2 ds3 ds4;
by subjid;
run;
proc sort;
by subjid;
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
if AESTDAT ne . then
AESTDAT1 = datepart(AESTDAT);
if AEENDAT ne . then
AEENDAT1 = datepart(AEENDAT);
format AESTDAT1 AEENDAT1 date9.;
keep SUBJID AEGRPID AESPID AESTDAT1 AEENDAT1 AEONGO AEREL AESER AEOUT AETOXGR;
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
by subjid;
run;
data fin;
merge ds(in = a) ae dm;
by subjid;
if a;
run;
data final;
set fin;
length flag1 flag2 $50.;
if date ne . and AEENDAT1 ne . and AEENDAT1 => date and sid ne AEGRPID then flag1 = 'AE end date is =>death date';
if AETERM ne '' and AEENDAT1 = . and AEONGO eq '' then flag2 = 'AE end date is null';
run;
data AE072;
retain SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AETOXGR AESER AEREL AEOUT
DTHDAT_DS1F1 DTHDAT_DS1F2 DTHDAT_DS1F4 DTHDAT_SS1DS1F1 flag1;
set final;
if AESTDAT ne . then
AESTDAT = AESTDAT1;
if AEENDAT ne . then
AEENDAT = AEENDAT1;
format AESTDAT AEENDAT date9.;
if AESPID ne '' and	AETERM ne '' and AEDECOD ne '' and AESTDAT ne . and AEENDAT ne . and AEONGO ne '' and
AETOXGR ne '' and AESER ne '' and AEREL ne '';
label AEGRPID = 'AE Group ID' AESPID = 'AE Identifier' AETERM = 'Event Term' AEDECOD = 'Dictionary Derived Term'
AESTDAT = 'AE Start date' AEENDAT = 'AE End date' AEONGO = 'Ongoing' AETOXGR = 'AE CTCAE Grade' AESER = 'Seriousness'
AEREL = 'Related to study treatment' AEOUT = 'Outcome' SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number';
keep SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AETOXGR AESER AEREL AEOUT
DTHDAT_DS1F1 DTHDAT_DS1F2 DTHDAT_DS1F4 DTHDAT_SS1DS1F1 flag1 flag2;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
  title2 "When subject died, all Adverse Events must have a stop date prior to the death date OR checked YES, except the Adverse Event,
  indicated as the cause of death.";

proc print data=AE072 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE072 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

