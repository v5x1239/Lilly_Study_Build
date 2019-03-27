/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : GLS100B.sas
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
LBREQ_LAB_RQSTN_NBR_TXT,LBPROC_LAB_PRCDR_CD_TXT,LBTESTCD_LAB_TST_CD_TXT,LAB_UNT_CD
order by SUBJID_PAT_NBR, VIS_NBR, LBACSTDT_LAB_CLLCT_DT_TMSTMP,
LBREQ_LAB_RQSTN_NBR_TXT,LBPROC_LAB_PRCDR_CD_TXT,LBTESTCD_LAB_TST_CD_TXT,LAB_UNT_CD;
quit;
data lab2;
set lab1;
if SUBJID_PAT_NBR eq lag(SUBJID_PAT_NBR) and VIS_NBR eq lag(VIS_NBR) and LBACSTDT_LAB_CLLCT_DT_TMSTMP eq lag(LBACSTDT_LAB_CLLCT_DT_TMSTMP) and
LBREQ_LAB_RQSTN_NBR_TXT eq lag(LBREQ_LAB_RQSTN_NBR_TXT) and LBPROC_LAB_PRCDR_CD_TXT eq lag(LBPROC_LAB_PRCDR_CD_TXT) and 
LBTESTCD_LAB_TST_CD_TXT eq lag(LBTESTCD_LAB_TST_CD_TXT) and LAB_UNT_CD eq lag(LAB_UNT_CD) and LAB_RSLT_TXT ne lag(LAB_RSLT_TXT);
keep SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD;
run;
proc sort;
by SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD;
run;
proc sort data = lab1 out = lb1;
by SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD;
run;
data mer;
merge lab2(in = a) lb1;
by SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD;
if a;
run;
data GLS100B;
retain USDYID_UNQ_STDY_ID_TXT	INVID_INVSTGTR_NBR SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD	LAB_RSLT_TXT; 
set mer;
keep USDYID_UNQ_STDY_ID_TXT	INVID_INVSTGTR_NBR SUBJID_PAT_NBR VIS_NBR LBACSTDT_LAB_CLLCT_DT_TMSTMP
LBREQ_LAB_RQSTN_NBR_TXT	LBPROC_LAB_PRCDR_CD_TXT	LBTESTCD_LAB_TST_CD_TXT	LAB_UNT_CD	LAB_RSLT_TXT;
run;
Proc sort;
by SUBJID_PAT_NBR;
run;

/*Print GLS100B*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "GLS";
title2 "CONDITIONAL - IF CRITICAL FOR ANALYSIS (REFER TO SAP): Check for duplicate lab/ECG data";
  proc print data=GLS100B noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set GLS100B nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
