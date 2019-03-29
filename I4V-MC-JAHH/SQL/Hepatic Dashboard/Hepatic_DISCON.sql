SELECT 'Hepatic Discon' as CATEGORY, SUBJID, BLOCKID, PAGE, DSDECOD, AEGRPID, AELLTCD,
                  HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT
         FROM
           (select SUBJID, BLOCKID, PAGE, DSDECOD, AEGRPID_RELREC
               from I4V_MC_JAHH.DS1001_all 
               WHERE DSDECOD is not null and AEGRPID_RELREC is not null) a
           INNER JOIN
           (select SUBJID as SUBJID2, AEGRPID, AELLTCD 
           from I4V_MC_JAHH.AE3001a_all
           where AELLTCD is not null) b
           on a.SUBJID = B.SUBJID2 AND a.AEGRPID_RELREC = b.AEGRPID
           INNER JOIN
           (Select LLTCD_LO_LVL_TERM_CD, PRFRD_TERM_CD, max(DCTNRY_VRSN_TXT)
               from MDF_SS_OWNER.CDMS_MEDDRA_LLT 
               WHERE LLTCD_LO_LVL_TERM_CD is not null 
               GROUP BY LLTCD_LO_LVL_TERM_CD, PRFRD_TERM_CD) c
           on B.AELLTCD = c.LLTCD_LO_LVL_TERM_CD
           INNER JOIN
           (Select PRFRD_TERM_CD, HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT, max(DCTNRY_VRSN_NBR_TXT)
               from MDF_SS_OWNER.CDMS_MEDDRA_HRCHY
               where HI_LVL_GRP_TERM_NM_TXT ='Hepatobiliary investigations' 
               OR SYSTM_ORGN_CLS_NM_TXT ='Hepatobiliary disorders'
               GROUP BY PRFRD_TERM_CD, HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT) d 
           on c.PRFRD_TERM_CD = d.PRFRD_TERM_CD
UNION ALL
SELECT '_END OF FILE_' CATEGORY, NULL SUBJID, NULL  BLOCKID, NULL  PAGE, NULL DSDECOD, NULL AEGRPID, NULL AELLTCD,
NULL HI_LVL_GRP_TERM_NM_TXT, NULL SYSTM_ORGN_CLS_NM_TXT FROM DUAL