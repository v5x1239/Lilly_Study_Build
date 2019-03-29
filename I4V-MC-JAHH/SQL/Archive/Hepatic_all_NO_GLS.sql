SELECT Category, SUBJID
        From 
        (
         SELECT 'Hepatic Discon' as CATEGORY, SUBJID, BLOCKID, PAGE, DSDECOD, AEGRPID, AELLTCD,
                   HI_LVL_GRP_TERM_NM_TXT, SYSTM_ORGN_CLS_NM_TXT
          FROM 
            (select SUBJID, BLOCKID, PAGE, DSDECOD, AEGRPID_RELREC
                from <prot>.DS1001_all 
                WHERE DSDECOD is not null and AEGRPID_RELREC is not null) a
            INNER JOIN
            (select SUBJID as SUBJID2, AEGRPID, AELLTCD 
            from <prot>.AE3001a_all
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
        ) DISCON
        Union all 
        SELECT Category, SUBJID
        From 
        (
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
        ) SAE
        Union all 
        SELECT Category, SUBJID
        From 
        (
       SELECT 'Labs' as CRITERIA, TYPE,
   CASE WHEN TRIM(TEST) = 'E03' THEN 'ALT >= 5X ULN'
        WHEN TRIM(TEST) = 'E13' THEN 'ALP >= 2X ULN'
        WHEN TRIM(TEST) = 'G01' THEN 'TBL >= 2X ULN'
   END AS CATEGORY, SUBJID, TEST, RESULT, HIGH, DATETIME,
   CASE WHEN TEST = 'E03' and RESULT >= HIGH*5 and RESULT_lag >= HIGH_lag*5 and RESULT_TYPE_lag >= HIGH_TYPE_lag*5 and TYPE != TYPE_lag THEN TYPE||'/'||TYPE_lag
        WHEN TEST = 'E03' and RESULT >= HIGH*5 and RESULT_lag >= HIGH_lag*5 and RESULT_TYPE_lag >= HIGH_TYPE_lag*5 and TYPE = TYPE_lag THEN TYPE
        WHEN TEST = 'E03' and RESULT >= HIGH*5 and RESULT_TYPE_lag >= HIGH_TYPE_lag*5 THEN TYPE
        WHEN TEST = 'E03' and RESULT >= HIGH*5 and RESULT_lag >= HIGH_lag*5 THEN TYPE_lag
        WHEN TEST in ('E13','G01') and RESULT >= HIGH*2 and RESULT_lag >= HIGH_lag*2 and RESULT_TYPE_lag >= HIGH_TYPE_lag*2 and TYPE != TYPE_lag THEN TYPE||'/'||TYPE_lag
        WHEN TEST in ('E13','G01') and RESULT >= HIGH*2 and RESULT_lag >= HIGH_lag*2 and RESULT_TYPE_lag >= HIGH_TYPE_lag*2 and TYPE = TYPE_lag THEN TYPE
        WHEN TEST in ('E13','G01') and RESULT >= HIGH*2 and RESULT_TYPE_lag >= HIGH_TYPE_lag*2 THEN TYPE
        WHEN TEST in ('E13','G01') and RESULT >= HIGH*2 and RESULT_lag >= HIGH_lag*2 then TYPE_lag
   END as PREVIOUS_TYPE
 FROM
 (
 SELECT to_number(SUBJID) as SUBJID, TEST, RESULT, HIGH, DATETIME, RESULT_lag, HIGH_lag, RESULT_TYPE_lag, HIGH_TYPE_lag, TYPE, TYPE_lag
 FROM
 (
 SELECT SUBJID, TEST, RESULT, HIGH, DATETIME,
 lag(RESULT,1) OVER (PARTITION by SUBJID, TEST ORDER BY DATETIME) RESULT_lag,
 lag(HIGH,1) OVER (PARTITION by SUBJID, TEST ORDER BY DATETIME) HIGH_lag, 
 RESULT_TYPE_lag, HIGH_TYPE_lag, TYPE, lag(TYPE,1) OVER (PARTITION by SUBJID, TEST ORDER BY DATETIME) TYPE_lag 
 FROM
 (
 SELECT SUBJID,
        TEST,
        RESULT,
        HIGH,
        DATETIME,
        lag(RESULT,1) OVER (PARTITION by SUBJID, TEST ORDER BY DATETIME) RESULT_TYPE_lag,
        lag(HIGH,1) OVER (PARTITION by SUBJID, TEST ORDER BY DATETIME) HIGH_TYPE_lag,
        TYPE
   FROM (SELECT subj_id AS SUBJID,
                RCVR_TST_CD AS TEST,
                SI_NMRC_RSLT AS RESULT,
                TO_NUMBER (SI_RSLT_REF_RNG_HI) AS HIGH,
                CLLCTN_DTM AS DATETIME,
                'CLRM' AS TYPE
           FROM mdf_ss_owner.clrm_lab_study_data_VW
          WHERE     RCVR_TST_CD IN ('E03', 'E13', 'G01')
                AND CLNCL_STUDY_ID = TRANSLATE('<prot>','_','-')) a
 UNION ALL
 SELECT SUBJID,
        TEST,
        RESULT,
        HIGH,
        DATETIME,
        LAG (RESULT, 1) OVER (PARTITION BY SUBJID, TEST ORDER BY DATETIME)
           RESULT_TYPE_lag,
        LAG (HIGH, 1) OVER (PARTITION BY SUBJID, TEST ORDER BY DATETIME)
           HIGH_TYPE_lag,
        'LB9001' as TYPE
   FROM (SELECT D.SUBJID, D.TEST, D.RESULT, D.HIGH,
                CASE
                   WHEN ITEMNAME = 'LBTIMHR' AND ITEMNAME2 = 'LBTIMMI'
                   THEN
                      TO_DATE (
                            LPAD (REPLACE (LBDATMO, '-99', '01'), 2, '0')
                         || LPAD (REPLACE (LBDATDD, '-99', '01'), 2, '0')
                         || LBDATYY
                         || LPAD (REPLACE (LBTIMHR, '-99', '23'), 2, '0')
                         || LPAD (REPLACE (LBTIMMI, '-99', '59'), 2, '0'),
                         'MMDDYYYYHH24MI')
                   ELSE
                      CASE
                         WHEN LBDATYY IS NOT NULL
                         THEN
                            TO_DATE (
                                  LPAD (REPLACE (LBDATMO, '-99', '01'),
                                        2,
                                        '0')
                               || LPAD (REPLACE (LBDATDD, '-99', '01'),
                                         2,
                                        '0')
                               || LBDATYY
                               || '2359',
                               'MMDDYYYYHH24MI')
                         ELSE
                            NULL
                      END
                END
                   AS DATETIME
           FROM 
           (SELECT *
                      FROM (SELECT TO_CHAR (a.SUBJID) AS SUBJID, A.BLOCKID, A.PAGE, A.PAGERPT,
                                   SUBSTR (LTRIM (a.LBTEST_GLS), 1, 3) AS TEST,
                                   CASE WHEN TRIM (TRANSLATE (A.LBORRES,'1234567890.>',' ')) IS NULL
                                      THEN TO_NUMBER (TRIM (LEADING '>' FROM A.LBORRES))
                                      ELSE NULL
                                   END
                                      AS RESULT,
                                   CASE
                                      WHEN TRIM (TRANSLATE (A.LBORNRHI,'1234567890.>',' '))
                                              IS NULL
                                      THEN
                                         TO_NUMBER (TRIM (A.LBORNRHI))
                                      ELSE NULL
                                   END
                                      AS HIGH, 'LB9001' AS TEMP1
                              FROM <prot>.lb9001_all a 
                              WHERE SUBSTR(ltrim(a.LBTEST_GLS),1,3) IN ('E03', 'E13', 'G01')) a
                           LEFT JOIN (SELECT DISTINCT
                                             b.ITEMNAME, 'LB9001' AS TEMP2
                                        FROM <prot>.INF_ITEMINSTANCE b
                                       WHERE TRIM (b.ITEMNAME) = 'LBTIMHR') b
                              ON a.temp1 = b.temp2
                           LEFT JOIN (SELECT DISTINCT
                                             c.ITEMNAME AS ITEMNAME2,
                                             'LB9001' AS TEMP3
                                        FROM <prot>.INF_ITEMINSTANCE c
                                       WHERE TRIM (c.ITEMNAME) = 'LBTIMMI') c
                              ON a.temp1 = c.temp3) d
                LEFT JOIN
                   (SELECT e.*
                      FROM <prot>.lb9001_all e where e.LBDATYY is not null) e
                ON     d.SUBJID = e.SUBJID
                   AND d.BLOCKID = e.BLOCKID
                   AND d.PAGE = e.PAGE
                   AND d.PAGERPT = e.PAGERPT)
 ))
                           WHERE ((TEST = 'E03' and RESULT >= HIGH*5) and ((RESULT_lag >= HIGH_lag*5) or (RESULT_TYPE_lag >= HIGH_TYPE_lag*5)))
                           OR ((TEST in ('E13','G01') and RESULT >= HIGH*2) and ((RESULT_lag >= HIGH_lag*2) or (RESULT_TYPE_lag >= HIGH_TYPE_lag*2))))
       ) LABS