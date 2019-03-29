/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM201.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : If YES is selected, then there should be at least one medication entered.  
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*CM201*/

data cm(keep=subjid blockid page cmyn);
set clntrial.cm1001;
where CMYN = 'Y';
proc sort nodupkey; by subjid page; run;

data cm2;
set clntrial.cm1001;
where missing(CMYN) and not missing(cmspid);
proc sort; by subjid page; run;

data cm201;
merge cm(in=a) cm2(in=b);
by subjid page;
if a and not b;
run;

/*Print cm201*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If YES is selected, then there should be at least one medication entered. CM1001";
  proc print data=cm201 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set cm201 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
