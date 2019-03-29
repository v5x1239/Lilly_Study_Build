select x.merge_datetime,SITEMNEMONIC, x.SUBJID, x.AEGRPID, x.AESPID, AETERM, AEDECOD, AESTDAT, AEENDAT, AEONGO, AETOXGR, AESER, AEREL, AEOUT,
case when y.aespid < x.aespid then 'X' end as Flag
from (select d.merge_datetime, d.SUBJECT_ID,d.SUBJID, d.AEGRPID, AESPID, AETERM, AEDECOD,  
TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT , 
TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'),2,'0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT,
                       AEONGO, AETOXGR, AESER, AEREL, AEOUT from (select * from I5B_MC_JGDJ.AE4001A_ALL where AEGRPID is not null) d left join (select * from I5B_MC_JGDJ.AE4001B_ALL where AEGRPID is not null) e
                       on d.subjid=e.subjid and d.AEGRPID=e.AEGRPID) x left join (select SUBJID, AEGRPID, AESPID from I5B_MC_JGDJ.AE4001B_ALL
                       where AEOUT='RECOVERED OR RESOLVED' ) y on x.subjid=y.subjid and x.AEGRPID=y.AEGRPID left join (SELECT sb.subject_id, st.SITEMNEMONIC
                            FROM I5B_MC_JGDJ.inf_subject sb,
                                 I5B_MC_JGDJ.inf_site_update st
                           WHERE sb.SITEGUID = st.CT_RECID) o
                  ON x.SUBJECT_ID = o.subject_id
                  order by subjid, aegrpid,aespid
               
                  