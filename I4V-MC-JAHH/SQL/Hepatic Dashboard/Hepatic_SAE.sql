SELECT 'Hepatic SAE' as CATEGORY, SUBJID, AEGRPID, AELLTCD, AESEV, AESER, HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT 
      FROM 
            (SELECT SUBJID, AEGRPID, AELLTCD
                from <prot>.AE3001A_all
                WHERE AELLTCD is not null) a
            INNER JOIN
            (SELECT SUBJID as SUBJID2, AEGRPID as AEGRPID2, AESEV, AESER
                FROM <prot>.AE3001B_all
                WHERE AESER = 'Y') b
            on a.SUBJID = b.SUBJID2 and a.AEGRPID = b.AEGRPID2
            INNER JOIN
            (Select LLTCD_LO_LVL_TERM_CD, PRFRD_TERM_CD, max(DCTNRY_VRSN_TXT)
               from MDF_SS_OWNER.CDMS_MEDDRA_LLT 
               WHERE LLTCD_LO_LVL_TERM_CD is not null 
               GROUP BY LLTCD_LO_LVL_TERM_CD, PRFRD_TERM_CD) c
           on a.AELLTCD = c.LLTCD_LO_LVL_TERM_CD
           INNER JOIN
           (Select PRFRD_TERM_CD, HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT, max(DCTNRY_VRSN_NBR_TXT)
               from MDF_SS_OWNER.CDMS_MEDDRA_HRCHY
               where HI_LVL_GRP_TERM_NM_TXT ='Hepatobiliary investigations' 
               OR SYSTM_ORGN_CLS_NM_TXT ='Hepatobiliary disorders'
               GROUP BY PRFRD_TERM_CD, HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT) d 
           on c.PRFRD_TERM_CD = d.PRFRD_TERM_CD
UNION ALL
SELECT '_END OF FILE_' CATEGORY, NULL SUBJID, NULL AEGRPID, NULL AELLTCD, NULL AESEV, NULL AESER,
NULL HI_LVL_GRP_TERM_NM_TXT, NULL SYSTM_ORGN_CLS_NM_TXT FROM DUAL