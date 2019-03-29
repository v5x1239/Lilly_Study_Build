/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CLRM05.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Check for duplicate lab data.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD934
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Cooney 		Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

data clrm(keep= SITE_ID SUBJ_ID LAB_VISIT_NM ACCSSN_ID CLLCTN_DTM TST_NM);
set clntrial.CLRM_DMP;
where CLNCL_STUDY_ID = "I3O-MC-JSBF";
proc sort; by subj_id accssn_id cllctn_dtm TST_NM; run;

data CLRM05;
set clrm;
by subj_id accssn_id cllctn_dtm TST_NM;
if first.TST_NM and last.TST_NM then delete;
run;

/*Print CLRM05*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Check for duplicate lab data.";
  proc print data=CLRM05 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CLRM05 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
