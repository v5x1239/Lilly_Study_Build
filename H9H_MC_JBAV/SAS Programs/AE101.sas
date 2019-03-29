/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE101.sas
PROJECT NAME (required)           : I1R_MC_GLDI
DESCRIPTION (required)            : AE Events Not Coded Consistantly or Missing
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : AE
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
proc freq data=clntrial.AE3001A noprint;
  table AETERM*AEDECOD / missing nopercent norow nocol out=AE_terms;
run;

Proc sort data=AE_terms; by AETERM AEDECOD; run;

*** Select the Missing or Inconsistant Terms;
Data AE_terms_coding (drop=rec_flg);
  set AE_terms (drop=PERCENT) end=eof;
  by AETERM AEDECOD;
  retain rec_flg 0;
  if not(first.AETERM and last.AETERM) then do;
    output;
	rec_flg=1;
  end;
  if eof and not(rec_flg) then do;
    AETERM="There are no records that satisfy the condition:";
    AEDECOD="No Missing or Inconsistant Terms";
	count=.;
	output;
  end;
run;

*** Create output;
ods csv file=&irfilcsv;
proc print data=AE_terms_coding;
  title1 "AE Events Not Coded Consistantly or Missing";
run;
ods csv close;
