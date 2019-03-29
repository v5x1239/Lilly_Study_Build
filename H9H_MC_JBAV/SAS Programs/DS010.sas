/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS010.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : If status is “Death”, then the AE Group ID entered must have a matching AE Group ID on the AE eCRF.
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

/*****************************DS010**************************************/

data ds1001(keep=subjid blockid dsdecod dscat_1 dsscat dsterm ds_start_date ds_death_date AEGRPID_RELREC merge);
format ds_start_date ds_death_date date9. merge 4.;
set clntrial.ds1001;
where upcase(dsdecod) = "DEATH";
merge = put(AEGRPID_RELREC, $4.);
ds_start_date=mdy(dsstdatmo,dsstdatdd,dsstdatyy);
ds_death_date=mdy(dthdatmo,dthdatdd,dthdatyy);
proc sort; by subjid AEGRPID_RELREC; run;

data ae3001b(keep=subjid aegrpid aeout merge);
set clntrial.ae3001b;
where upcase(aeout) = 'FATAL';
merge = aegrpid;
proc sort nodupkey; by subjid aegrpid; run;

data DS010;
retain subjid blockid dsdecod dscat_1 dsscat dsterm ds_start_date ds_death_date AEGRPID_RELREC aegrpid aeout;
merge ds1001(in=a) ae3001b(in=b);
by subjid merge;
if a and not b;
drop merge;
run;

/*Print DS1001*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Status = Death, then must have matching AEGRPID";
  proc print data=DS010 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS010 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

********************** End Programming Code ******************************;
