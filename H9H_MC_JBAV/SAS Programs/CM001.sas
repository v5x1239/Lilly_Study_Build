/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM001.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : If NO is selected, then no medications should be entered.  
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

/*CM001*/
data cm(keep=subjid blockid page cmyn);
set clntrial.cm1001;
where CMYN = 'N';
proc sort; by subjid; run;

data cm2;
set clntrial.cm1001;
where missing(CMYN) and not missing(cmspid);
proc sort; by subjid; run;

data cm001;
merge cm(in=a) cm2(in=b);
by subjid;
if a and b;
run;

/*Print cm001*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If NO is selected, then no medications should be entered. CM001";
  proc print data=cm001 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set cm001 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
