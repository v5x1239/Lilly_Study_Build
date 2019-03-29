/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE065.sas
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
keep SUBJID AEGRPID AESPID AESTDAT1 AEENDAT1 AEONGO AETOXGR AESER AEREL AEOUT;
run;
proc sort;
by subjid AEGRPID AESPID;
run;
data ae;
merge ae1 ae2;
by subjid AEGRPID;
if upcase(AEOUT) = "RECOVERED OR RESOLVED WITH SEQUELAE" then f1 = '#';
run;
data lag;
set ae;
sub = lag(subjid);
prid = lag(AEGRPID);
spid = lag(AESPID);
out = lag(aeout);
f = lag(f1);
run;
data fin;
length flag $ 1000.;
set lag;
if sub eq subjid and prid eq AEGRPID and f ne '' and AESPID gt spid 
then flag = 'Event outcome is Recovered with Sequelae, but another event with the same AE Group ID is present';
run;
proc sort;
by subjid;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data ae065;
retain SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AETOXGR AESER AEREL AEOUT;
set final;
AESTDAT = AESTDAT1;
AEENDAT = AEENDAT1;
format AESTDAT AEENDAT date9.;
label AEGRPID = 'AE Group ID' AESPID = 'AE Identifier' AETERM = 'Event Term' AEDECOD = 'Dictionary Derived Term'
AESTDAT = 'AE Start date' AEENDAT = 'AE End date' AEONGO = 'Ongoing' AETOXGR = 'AE CTCAE Grade' AESER = 'Seriousness'
AEREL = 'Related to study treatment' AEOUT = 'Outcome';
keep SITEMNEMONIC SUBJID AEGRPID AESPID AETERM AEDECOD AESTDAT AEENDAT AEONGO AETOXGR AESER AEREL AEOUT flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Events";
	title2 "Event outcome is Recovered with Sequelae, but another event with the same AE Group ID is present with a start date after the end
	date of the first entry. Please correct";

proc print data=AE065 noobs WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set AE065 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

