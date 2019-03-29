/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DA030.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : If more returned than expected has been ticked, check if returned amount is higher than expected
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

/*DA030*/

data daa(keep=subjid blockid rtamtcmp retamt);
set clntrial.da1001;
where rtamtcmp ne '';
proc sort nodup; by subjid blockid; run;

data sv(keep=subjid blockid visdat);
format visdat date9.;
set clntrial.sv1001;
visdat = mdy(VISDATMO,VISDATDD,VISDATYY);
proc sort nodup; by subjid blockid; run;

data da1;
merge daa(in=a) sv(in=b);
by subjid blockid;
if a;
run;

PROC SQL;
create table da030 as
select a.subjid, a.blockid, a.rtamtcmp, a.retamt, a.visdat, b.blockid as prev_VISIT, b.visdat as prev_DATE, b.retamt as prevRESULT, (a.retamt - b.retamt) as result_DIFF
from da1 a, da1 b
where a.subjid = b.subjid and input(a.blockid,3.) = input(b.blockid,3.) +1;
QUIT;

/*Print da030*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check return amount + result vs previous visit result";
  proc print data=da030 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set da030 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
