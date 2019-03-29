/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST500.sas
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


/*libname clntrial oracle user="Z2X0984" pass="Rithika0984" defer=no path=prd934 access=READONLY schema=I5B_MC_JGDJ;*/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
data syst1;
set clntrial.syst3001;
if page eq 'SYST3001_LF1';
keep SUBJID blockid SYSGRPID SYSRSRGM;
run;
proc sort nodup;
by subjid;
run;
data syst2;
set syst1;
if upcase(SYSRSRGM) in ('NEOADJUVANT','ADJUVANT');
keep SUBJID;
run;
proc sort nodup;
by subjid;
run;
data syst3;
set syst1;
if upcase(SYSRSRGM) not in ('LOCALLY ADVANCE','METASTATIC');
keep SUBJID;
run;
proc sort nodup;
by subjid;
run;
data syst4;
merge syst2(in = a) syst3(in = b);
by subjid;
if a and b;
run;
proc sort nodup;
by subjid;
run;
data syst;
merge syst4(in = a) syst1;
by subjid;
if a;
run;
data fin;
merge syst(in = a) dm;
by subjid;
if a;
run;
data SYST500;
retain SITEMNEMONIC SUBJID blockid SYSGRPID SYSRSRGM;
set fin;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' blockid = 'Visit number'
SYSGRPID = 'Regimen number' SYSRSRGM = 'Reason for regimen' ;
keep SITEMNEMONIC SUBJID blockid SYSGRPID SYSRSRGM;
run;

ods csv file=&irfilcsv trantab=ascii;
  title1 "Systemic Therapy prior for this cancer";
  title2 "Value can only be Locally Advanced or Metastatic";

proc print data=SYST500 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set SYST500 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;



