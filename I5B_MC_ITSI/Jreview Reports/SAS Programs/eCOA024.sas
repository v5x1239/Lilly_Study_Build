/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA024.sas
PROJECT NAME (required)           : I8B-MC-ITSI
DESCRIPTION (required)            : Reconcile HYPO across three different data bases (eCOA, Inform & LSS) where all systems should have the event as a serious Hypoglycemia.
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itsi\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

options compress=yes;

/************************* Start of environment/input/output programming ************************/

/*eCOA024*/
/*Reconcile HYPO across three different data bases (eCOA, Inform & LSS) where all systems should have the event as a serious Hypoglycemia.*/

proc sql;
create table eCOA024 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', coalesce(a.sitecode, b.SITEMNEMONIC, c.invid) as SITE label 'Site', coalesce(a.subjid_ecoa, b.subjid_ae, c.subjid_lss) as SUBJID label 'Subject ID',  
case when a.subjid_ecoa is not null and b.subjid_ae is not null and c.subjid_lss is not null then 'ECOA, AE, LSS'
	 when a.subjid_ecoa is not null and b.subjid_ae is not null and c.subjid_lss is null then 'ECOA, AE'
	 when a.subjid_ecoa is not null and b.subjid_ae is null and c.subjid_lss is not null then 'ECOA, LSS'
	 when a.subjid_ecoa is not null and b.subjid_ae is null and c.subjid_lss is null then 'ECOA'
	 when a.subjid_ecoa is null and b.subjid_ae is not null and c.subjid_lss is not null then 'AE, LSS'
	 when a.subjid_ecoa is null and b.subjid_ae is null and c.subjid_lss is not null then 'LSS'
	 when a.subjid_ecoa is null and b.subjid_ae is not null and c.subjid_lss is null then 'AE'
end as SOURCE label 'Record Sources',
case when a.subjid_ecoa is not null and b.subjid_ae is not null and c.subjid_lss is null then 'Hypo event missing from LSS'
	 when a.subjid_ecoa is not null and b.subjid_ae is null and c.subjid_lss is not null then 'Hypo event missing from AE'
	 when a.subjid_ecoa is not null and b.subjid_ae is null and c.subjid_lss is null then 'Hypo event missing from AE and LSS'
	 when a.subjid_ecoa is null and b.subjid_ae is not null and c.subjid_lss is not null then 'Hypo event missing from eCOA'
	 when a.subjid_ecoa is null and b.subjid_ae is null and c.subjid_lss is not null then 'Hypo event missing from AE and eCOA'
	 when a.subjid_ecoa is null and b.subjid_ae is not null and c.subjid_lss is null then 'Hypo event missing from eCOA and LSS'
	 else ''
end as MISSING_FLAG label 'Missing Hypo Event Flag',
case when a.subjid_ecoa is not null and b.subjid_ae is not null and upcase(a.HYPOSER) = 'YES' and upcase(b.AESER) in ('N', '') then 'Serious indicated for eCOA but not AE'
when a.subjid_ecoa is not null and b.subjid_ae is not null and upcase(a.HYPOSER) in ('NO', '') and upcase(b.AESER) = 'Y' then 'Serious indicated for AE but not eCOA'
end as SERIOUS_FLAG label 'Serious Event Flag',
a.HYPOTRTPRV label 'eCOA - Hypoglycemic Event Treatment Provider', a.HYPOSER label 'eCOA - Hypoglycemic Event Serious', 
HYPOSTDT label 'eCOA - Hypoglycemic Event Start Date', a.HYPOSTTIM label 'eCOA - Hypoglycemic Event Start Time', 
ECOASTDT label 'eCOA Completion Start Date', ECOASTTIM label 'eCOA Completion Start Time', b.AEDECOD label 'AE Decode Value', 
b.AEGRPID label 'AE - Group ID', AEENDAT label 'AE - End Date', b.AESER label 'AE - Serious', b.AESPID label 'AE - ID', AESTDAT label 'AE - Start Date', b.AETERM label 'AE - Event Term',
c.PRFRD_TERM_NM_TXT label 'LSS - Preferred Term', c.AETERM_EVNT_TERM label 'LSS - AE Event Term', SAEDT_SERIOUS_EVT_STRT_DT label 'LSS - SAE Serious Event Start Date', LSS_AEENDT_EVNT_END_DT label 'LSS - AE Event Start Date' FROM
(select SITECODE, SUBJID as SUBJID_ECOA, input(catx("-",HYPOSTDATMO,HYPOSTDATDD,HYPOSTDATYY),mmddyy10.) as HYPOSTDT format date9.,
HYPOSTTIM, input(catx("-",substr(ECOASTDT,6,2),substr(ECOASTDT,9,2),substr(ECOASTDT,1,4)),mmddyy10.) as ECOASTDT format date9.,
substr(ECOASTDT,12,8) as ECOASTTIM,
HYPOTRTPRV, HYPOSER 
from CLUWE.hypo1001_ecoa where HYPOTRTPRV = "SUBJECT NOT CAPABLE OF TREATING SELF AND REQUIRED ASSISTANCE") a
FULL JOIN
(SELECT SITEMNEMONIC, a.SUBJID as SUBJID_AE, AEDECOD, 
a.AEGRPID, input(catx("-",AEENDATMO,AEENDATDD,AEENDATYY),mmddyy10.) as AEENDAT format date9.,
AESER, AESPID, input(catx("-",AESTDATMO,AESTDATDD,AESTDATYY),mmddyy10.) as AESTDAT format date9.,
AETERM
FROM CLUWE.AE3001A a
LEFT JOIN CLUWE.AE3001b b
ON a.subjid = b.subjid
AND a.AEGRPID = b.AEGRPID
LEFT JOIN (SELECT sb.subject_id, st.SITEMNEMONIC
FROM CLUWE.inf_subject sb,
CLUWE.inf_site_update st
WHERE sb.SITEGUID = st.CT_RECID) o
ON a.SUBJECT_ID = o.subject_id where AEDECOD = "Hypoglycaemia") b
on a.SUBJID_ecoa = b.subjid_ae and (a.HYPOSTDT = b.AESTDAT OR a.ECOASTDT = b.AESTDAT)
FULL JOIN
(SELECT distinct a.USDYID,
substr(a.INVID,2,3) as INVID,
a.SUBJID as SUBJID_LSS,
PRFRD_TERM_NM_TXT,
AETERM_EVNT_TERM,
datepart(SAEDT_SERIOUS_EVT_STRT_DT) as SAEDT_SERIOUS_EVT_STRT_DT format date9.,
datepart(LSS_AEENDT_EVNT_END_DT) as LSS_AEENDT_EVNT_END_DT format date9.
FROM CLUWE.CDMS_LSSI_SAE_DNRLMZ a
LEFT JOIN
CLUWE.CDMS_MEDDRA_HRCHY b
on input(a.PTCD_PRFRD_TERM_CD,9.) =
b.PRFRD_TERM_CD where PRFRD_TERM_NM_TXT = "Hypoglycaemia") c
on a.subjid_ecoa = c.subjid_lss and (a.HYPOSTDT = SAEDT_SERIOUS_EVT_STRT_DT OR a.ECOASTDT = SAEDT_SERIOUS_EVT_STRT_DT 
										OR a.HYPOSTDT = LSS_AEENDT_EVNT_END_DT OR a.ECOASTDT = LSS_AEENDT_EVNT_END_DT)
order by SUBJID, a.HYPOSTDT, HYPOSTTIM, a.ECOASTDT, ECOASTTIM, b.AESTDAT, SAEDT_SERIOUS_EVT_STRT_DT, LSS_AEENDT_EVNT_END_DT; quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA024";
  title2 "Reconcile HYPO across three different data bases (eCOA, Inform & LSS) where all systems should have the event as a serious Hypoglycemia";

proc print data=eCOA024 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA024 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
