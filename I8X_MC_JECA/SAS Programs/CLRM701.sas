/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CLRM701.sas
PROJECT NAME (required)           : I8X_MC_JECA
DESCRIPTION (required)            : Events with the same AEGRPID must have the same AEDECOD (Dictionary term) across the study
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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
1.0  Premkumar        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

Data Dm1;
	set clntrial.dm1001c;
	sub = subjid;
	keep SITEMNEMONIC subjid sub;
run;
proc sort;
	by subjid;
run;
data dm2;
	set clntrial.dm1001;
	yr1 = input(brthyr,best.);
	keep subjid sex brthyr yr1;
run; 
proc sort;
	by subjid;
run;
data dm;
	merge dm1 dm2;
	by subjid;
run;
data clrm;
	set clntrial.clrm_dmp;
	sub = input(SUBJ_ID,best.);
	yr1 = datepart(SUBJ_DOB);
	yr = year(yr1);
	if CLNCL_STUDY_ID eq 'I8X-MC-JECA';
	keep SITE_ID SUB SUBJ_ID SUBJ_SEX SUBJ_DOB LAB_VISIT_NM CLLCTN_DTM ACCSSN_ID yr;
run;
proc sort;
	by sub;
run;
data mer;
	merge dm clrm(in = a);
	by sub;
	if a;
run;
data CLRM701;
	retain SITEMNEMONIC SITE_ID SUB SUBJ_ID LAB_VISIT_NM CLLCTN_DTM ACCSSN_ID sex brthyr;
	set mer;	
	if SUBJ_SEX ne sex or yr ne yr1;
	keep SITEMNEMONIC SITE_ID SUB SUBJ_ID LAB_VISIT_NM CLLCTN_DTM ACCSSN_ID sex brthyr;
run;

/*Print CLRM701*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "CLRM";
title2 "Check the consistency of sex and birth years between CLRM and the CRF.";
  proc print data=CLRM701 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set CLRM701 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
