/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS011.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : If  status is “Death”, Date of Death must be = AEGRPID_RELREC's End Date in AE CRF.
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

data ds1001a(keep=subjid blockid dsdecod dscat_1 dsscat dsterm AEGRPID_RELREC ds_start_date ds_death_date merge);
format ds_start_date ds_death_date date9. merge 4.;
set clntrial.ds1001;
where upcase(dsdecod) = "DEATH";
merge = input(AEGRPID_RELREC, 4.);
ds_start_date=mdy(dsstdatmo,dsstdatdd,dsstdatyy);
ds_death_date=mdy(dthdatmo,dthdatdd,dthdatyy);
proc sort; by subjid AEGRPID_RELREC; run;

data ae3001ba(keep=subjid aegrpid aeout ae_end_date merge);
format ae_end_date date9.;
set clntrial.ae3001b;
where upcase(aeout) = 'FATAL';
merge = aegrpid;
ae_end_date=mdy(aeendatmo,aeendatdd,aeendatyy);
proc sort nodupkey; by subjid aegrpid; run;

data DS011;
retain subjid blockid dsdecod dscat_1 dsscat dsterm ds_start_date ds_death_date AEGRPID_RELREC aegrpid aeout ae_end_date;
merge ds1001a(in=a) ae3001ba(in=b);
by subjid merge;
if a and b and ds_death_date ne ae_end_date;
drop merge;
run;

/*Print DS1011*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Status = Death, then must DOD must = AEENDT";
  proc print data=DS011 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS011 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

********************** End Programming Code ******************************;
