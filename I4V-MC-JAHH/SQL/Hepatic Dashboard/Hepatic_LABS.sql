SELECT 'Labs' as CRITERIA,
  CASE WHEN TRIM(TEST) = 'E03' THEN 'ALT >= 5X ULN'
       WHEN TRIM(TEST) = 'E13' THEN 'ALP >= 2X ULN'
       WHEN TRIM(TEST) = 'G01' THEN 'TBL >= 2X ULN'
  END AS CATEGORY, TYPE, SUBJID, TEST, RESULT, HIGH, DATETIME,
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
  FROM (SELECT a.SUBJID, a.TEST, a.RESULT, a.HIGH, a.DATETIME 
               FROM 
          (SELECT TO_CHAR (a.SUBJID) AS SUBJID, A.BLOCKID, A.PAGE, A.PAGERPT,
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
                                     AS HIGH, 'LB9001' AS TEMP1,
                                     TO_DATE (LPAD (REPLACE (LBDATMO, '-99', '01'),2,'0') || LPAD 
                             (REPLACE (LBDATDD, '-99', '01'),2,'0') || LBDATYY || '2359','MMDDYYYYHH24MI')
                        AS DATETIME
                             FROM <prot>.lb9001_all a 
                             WHERE SUBSTR(ltrim(a.LBTEST_GLS),1,3) IN ('E03', 'E13', 'G01')) a )
))
                          WHERE ((TEST = 'E03' and RESULT >= HIGH*5) and ((RESULT_lag >= HIGH_lag*5) or (RESULT_TYPE_lag >= HIGH_TYPE_lag*5)))
                          OR ((TEST in ('E13','G01') and RESULT >= HIGH*2) and ((RESULT_lag >= HIGH_lag*2) or (RESULT_TYPE_lag >= HIGH_TYPE_lag*2))))
UNION ALL
SELECT '_END OF FILE_' CRITERIA, NULL CATEGORY, NULL TYPE, NULL SUBJID, NULL TEST, NULL RESULT, NULL HIGH, NULL DATETIME, NULL PREVIOUS_TYPE FROM DUAL