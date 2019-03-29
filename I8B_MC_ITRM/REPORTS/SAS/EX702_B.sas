/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX702_B.sas
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data DM;
set clntrial.dm1001c;
label SITEMNEMONIC = 'Site Number';
keep SITEMNEMONIC SUBJID;
run;
proc sort;
by subjid;
run;
data sv1;
set clntrial.sv1001;
if VISDAT ne . then
VISDAT1 = datepart(VISDAT);
format VISDAT1 date9.;
label OCCUR = 'VISITOCCUR';
keep SUBJID BLOCKID VISDAT1 OCCUR VISDATMD;
run;
proc sort;
by SUBJID BLOCKID;
run;
data sv2;
set clntrial.sv1001;
if BLOCKID eq '8' then block = BLOCKID;
if BLOCKID eq '8';
keep subjid block BLOCKID;
run;
proc sort;
by SUBJID BLOCKID;
run;
data sv;
merge sv1 sv2(in = a);
by subjid BLOCKID;
if a;
run;
proc sort;
by SUBJID;
run;
data ex;
set clntrial.ex1001;
if EXSTDAT ne . then
EXSTDAT1 = datepart(EXSTDAT);
format EXSTDAT1 date9.;
if EXSTDAT ne . and page in ('EX1001_C1LF4');
formname = 'EX_FD';
keep SUBJID EXSTDAT1 page formname;
run;
proc sort;
by subjid;
run;
data dsex;
merge ex(in = a) sv;
by subjid;
if a;
run;
data fin;
set dsex;
length flag $30.;
if BLOCK ne '8' then flag = 'No Blockid = 8';
run;
proc sort;
by SUBJID;
run;
data final;
merge fin(in = a) dm;
by subjid;
if a;
run;
data EX702_B;
retain SITEMNEMONIC SUBJID formname EXSTDAT VISDAT BLOCKID OCCUR VISDATMD;
set final;
EXSTDAT = EXSTDAT1;
VISDAT = VISDAT1;
format VISDAT EXSTDAT date9.;
keep SITEMNEMONIC SUBJID formname EXSTDAT VISDAT BLOCKID OCCUR VISDATMD flag;
run;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Study Treatment";
  title2 "Ensure that EX_FDOL is only entered if subject completed V2 and was not a screen failure nor LTFU, and ensure EX_FD is only entered if subject has completed V8";

proc print data=EX702_B noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set EX702_B nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

