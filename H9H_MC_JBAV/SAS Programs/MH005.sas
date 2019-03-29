/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH005.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of severity must be recorded or event must become serious  
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

/*mh005*/

data mh(keep=subjid blockid page mhongo mhterm mhdecod mhsev term);
format term $200.;
set clntrial.mh7001;
where mhongo = "Y";
term = mhdecod;
proc sort; by subjid term; run;

data aea(keep=subjid aegrpid aeterm aedecod term);
format term $200.;
set clntrial.ae3001a;
where aedecod ne '';
term = aedecod;
proc sort; by subjid aegrpid; run; 

data aeb(keep=subjid aegrpid aesev aeser);
set clntrial.ae3001b;
proc sort; by subjid aegrpid; run; 

data ae;
merge aea(in=a) aeb(in=b);
by subjid aegrpid;
if a and b;
proc sort; by subjid term; run;

data mh005(keep=subjid blockid page mhongo mhterm mhdecod mhsev aesev aeser);
merge mh(in=a) ae(in=b);
by subjid term;
if a and b and (aeser ne 'yes' and aesev = mhsev);
run;

/*Print mh005*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, 
		  a change of severity must be recorded or event must become serious";
  proc print data=mh005 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set mh005 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
