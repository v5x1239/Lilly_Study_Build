/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : CM205.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : CM3001 Events Not Coded Consistantly or Missing
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
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

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

*** Calculate the frequency of terms;
proc freq data=clntrial.CM3001 noprint;
  table CMTRT*CMDECOD / missing nopercent norow nocol out=CM_terms;
run;

Proc sort data=CM_terms; by CMTRT CMDECOD; run;

*** Select the Missing or Inconsistant Terms;
Data CM_terms_coding (drop=rec_flg);
  set CM_terms (drop=PERCENT) end=eof;
  by CMTRT CMDECOD;
  retain rec_flg 0;
  if not(first.CMTRT and last.CMTRT) then do;
    output;
	rec_flg=1;
  end;
  if eof and not(rec_flg) then do;
    CMTRT="There are no records that satisfy the condition:";
    CMDECOD="No Missing or Inconsistant Terms";
	count=.;
	output;
  end;
run;

*** Create output;
ods csv file=&irfilcsv;
proc print data=CM_terms_coding;
  title1 "CM3001 Events Not Coded Consistantly or Missing";
run;
ods csv close;
