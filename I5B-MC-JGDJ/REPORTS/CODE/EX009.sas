/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX009.sas
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
data vs1;
set clntrial.VS1001;
if page eq 'VS1001_LF1';
keep SUBJID Height;
run;
proc sort;
by subjid;
run;
data vs2;
set clntrial.VS1001;
keep SUBJID blockid WEIGHT WEIGHTU;
run;
proc sort;
by subjid;
run;
data vs;
merge VS2(in = a) vs1;
by subjid;
if a;
run;
proc sort nodup;
by subjid blockid;
run;
data ES;
set clntrial.EX1001B;
if page eq 'EX1001_F2';
keep SUBJID blockid EXSPID EXPDOSEU EXDOSEU;
run;
proc sort nodup;
by subjid blockid;
run;
data rds;
merge es(in = a) vs(in = b);
by subjid blockid;
if a;
run;
proc sort nodup;
by subjid;
run;
data fin;
merge rds(in = a) dm;
by subjid;
if a;
run;
data EX009;
retain SITEMNEMONIC SUBJID blockid EXSPID EXPDOSEU EXDOSEU Height WEIGHT WEIGHTU;
set fin;
label SITEMNEMONIC = 'Site Number' SUBJID = 'Subject Number' BlockID = 'Visit number' Height = 'Height'
EXSPID = 'sponsor defined identifier' EXPDOSEU = 'Planned dose' EXDOSEU = 'Dose per administration'
WEIGHT = 'Weight' WEIGHTU = 'Weight unit';
keep SITEMNEMONIC SUBJID blockid EXSPID EXPDOSEU EXDOSEU Height WEIGHT WEIGHTU;
run;
proc sort nodup;
by subjid;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "EX";
  title2 "Calculate BSA using Du Bois formula from height and Latest weight;
  then calculate expected dose and fire if not within +/-5% variance in the calculated total dose.";

proc print data=EX009 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX009 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

