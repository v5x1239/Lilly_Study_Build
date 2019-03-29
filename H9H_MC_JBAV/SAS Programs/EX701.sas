/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX701.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : Only one dose reduction is allowed.  Need to confirm this for all patients
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

/*****************************DS011**************************************/

data ex1001(keep=subjid blockid page exspid expoccur EXDSAJTP exadj cegrpid_relrec exendat exentimh exentimi exstdat exsttimhr exsttimi expdose expdoseu);
set clntrial.ex1001;
where page = "EX1001_F4" and EXDSAJTP = "DOSE REDUCED";
proc sort; by subjid EXDSAJTP; run;

data ex701;
set ex1001;
by EXDSAJTP;
if first.EXDSAJTP and last.EXDSAJTP then delete;
run;

/*Print EX701*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Only one dose reduction is allowed.  Need to confirm this for all patients";
  proc print data=EX701 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX701 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

********************** End Programming Code ******************************;
