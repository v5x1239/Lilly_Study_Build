select a.merge_datetime, SITEMNEMONIC, a.SUBJID, AEGRPID, AESPID, AETERM, AEDECOD, AESTDAT , AEENDAT, AEONGO, AEREL, EXSTDAT_EX1001_F1,  EXSTDAT_EX1001_F2 
from (select d.merge_datetime, d.SUBJECT_ID,d.SUBJID, d.AEGRPID, AESPID, AETERM, AEDECOD,  TO_DATE (
                          LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')
                       || LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')
                       || AESTDATYY,
                       'MMDDYYYY')
                       AS AESTDAT , to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')||lpad(replace(AEENDATDD,'-99', '30'),2,'0')|| AEENDATYY,'MMDDYYYY') as AEENDAT,
                       AEONGO, AEREL from (select * from I5B_MC_JGDJ.AE4001A_ALL where AEGRPID is not null) d left join (select * from I5B_MC_JGDJ.AE4001B_ALL where AEGRPID is not null) e
                       on d.subjid=e.subjid and d.AEGRPID=e.AEGRPID) a left join (select SUBJID,TO_DATE (
                          LPAD (REPLACE (EXSTDATMO, '-99', '01'), 2, '0')
                       || LPAD (REPLACE (EXSTDATDD, '-99', '01'), 2, '0')
                       || EXSTDATYY,
                       'MMDDYYYY')
                       AS EXSTDAT_EX1001_F1 from  I5B_MC_JGDJ.EX1001B_ALL where page='EX1001_LF1' and blockid='1') b on a.subjid=b.subjid left join (select SUBJID,TO_DATE (
                          LPAD (REPLACE (EXSTDATMO, '-99', '01'), 2, '0')
                       || LPAD (REPLACE (EXSTDATDD, '-99', '01'), 2, '0')
                       || EXSTDATYY,
                       'MMDDYYYY')
                       AS EXSTDAT_EX1001_F2 from  I5B_MC_JGDJ.EX1001B_ALL where page='EX1001_F2' and blockid='1') d on a.subjid=d.subjid left join (SELECT sb.subject_id, st.SITEMNEMONIC
                            FROM I5B_MC_JGDJ.inf_subject sb,
                                 I5B_MC_JGDJ.inf_site_update st
                           WHERE sb.SITEGUID = st.CT_RECID) o
                  ON a.SUBJECT_ID = o.subject_id
                  where AEREL='Y' and (AESTDAT <= EXSTDAT_EX1001_F1 or  AESTDAT <= EXSTDAT_EX1001_F2)