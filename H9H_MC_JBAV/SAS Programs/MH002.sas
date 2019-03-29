/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH002.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : If Yes is selected, then past and/or concomitant diseases or  past surgeries need to be recorded.  
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

/*mh002*/

data mh(keep=subjid blockid page mhyn);
set clntrial.MH7001;
where mhyn = 'Y';
proc sort nodup; by subjid page; run;

data mh2;
set clntrial.mh7001;
where missing(mhyn) and not missing(mhspid);
proc sort; by subjid page; run;

data mh002;
merge mh(in=a) mh2(in=b);
by subjid page;
if a and not b;
run;

/*Print mh002*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Yes is selected, then past and/or concomitant diseases or  past surgeries need to be recorded.";
  proc print data=mh002 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set mh002 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
