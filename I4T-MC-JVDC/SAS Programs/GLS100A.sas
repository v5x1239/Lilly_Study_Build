/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS100A.sas
PROJECT NAME (required)           : I4T_MC_JVDC
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

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I4T_MC_JVDC;*/

data lab;
set clntrial.GLS100_J;
keep USDYID_UNQ_STDY_ID_TXT	INVID_INVSTGTR_NBR SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD	LAB_RSLT_TXT;
run;
Proc sort;
by SUBJID_PAT_NBR;
run;
proc sql;
create table lab1 as select * , count(SUBJID_PAT_NBR) as cnt from lab
group by SUBJID_PAT_NBR, VIS_NBR, LBACSTDT_LAB_CLLCT_DT_TMSTMP,
LBREQ_LAB_RQSTN_NBR_TXT,LBPROC_LAB_PRCDR_CD_TXT,LBTESTCD_LAB_TST_CD_TXT,LAB_UNT_CD,LAB_RSLT_TXT
order by SUBJID_PAT_NBR, VIS_NBR, LBACSTDT_LAB_CLLCT_DT_TMSTMP,
LBREQ_LAB_RQSTN_NBR_TXT,LBPROC_LAB_PRCDR_CD_TXT,LBTESTCD_LAB_TST_CD_TXT,LAB_UNT_CD,LAB_RSLT_TXT;
quit;
data GLS100A;
retain USDYID_UNQ_STDY_ID_TXT	INVID_INVSTGTR_NBR SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD	LAB_RSLT_TXT; 
set lab1;
if cnt gt 1;
keep USDYID_UNQ_STDY_ID_TXT	INVID_INVSTGTR_NBR SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD	LAB_RSLT_TXT;
run;
Proc sort;
by SUBJID_PAT_NBR;
run;

/*Print GLS100A*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "GLS";
title2 "CONDITIONAL - IF CRITICAL FOR ANALYSIS (REFER TO SAP): Check for duplicate lab/ECG data";
  proc print data=GLS100A noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS100A nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
