select SITEMNEMONIC, SUBJID, AEGRPID, AESPID, AETERM, AEDECOD, AESTDAT, AEENDAT, AEONGO, AETOXGR, AESER, AEREL, AEOUT,
case when AEOUT in ('RECOVERED OR RESOLVED','RECOVERED OR RESOLVED WITH SEQUELAE','FATAL' ) and AEENDAT is null then 'X' end as Flag
from (select d.merge_datetime, d.SUBJECT_ID,d.SUBJID, d.AEGRPID, AESPID, AETERM, AEDECOD,  TO_DATE (
                          LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')
                       || LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')
                       || AESTDATYY,
                       'MMDDYYYY')
                       AS AESTDAT , to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')||lpad(replace(AEENDATDD,'-99', '30'),2,'0')|| AEENDATYY,'MMDDYYYY') as AEENDAT,
                       AEONGO, AETOXGR, AESER, AEREL, AEOUT from (select * from I5B_MC_JGDJ.AE4001A_ALL where AEGRPID is not null) d left join (select * from I5B_MC_JGDJ.AE4001B_ALL where AEGRPID is not null) e
                       on d.subjid=e.subjid and d.AEGRPID=e.AEGRPID) x left join (SELECT sb.subject_id, st.SITEMNEMONIC
                            FROM I5B_MC_JGDJ.inf_subject sb,
                                 I5B_MC_JGDJ.inf_site_update st
                           WHERE sb.SITEGUID = st.CT_RECID) o
                  ON x.SUBJECT_ID = o.subject_id
                  where AEOUT in ('RECOVERED OR RESOLVED','RECOVERED OR RESOLVED WITH SEQUELAE','FATAL' )