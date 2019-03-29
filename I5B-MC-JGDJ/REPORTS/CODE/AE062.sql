select x.merge_datetime, SITEMNEMONIC, x.SUBJID, x.AEGRPID, AESPID, AETERM, AEDECOD, AESTDAT , AEENDAT, y.AEONGO,AETOXGR, AESER, AEREL, AEOUT,
case when y.aegrpid is not null then 'X' end as Flag1,
case when z.aegrpid is not null then 'X' end as Flag2
from (select d.merge_datetime, d.SUBJECT_ID,d.SUBJID, d.AEGRPID, AESPID, AETERM, AEDECOD,  TO_DATE (
                          LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')
                       || LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')
                       || AESTDATYY,
                       'MMDDYYYY')
                       AS AESTDAT , to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')||lpad(replace(AEENDATDD,'-99', '30'),2,'0')|| AEENDATYY,'MMDDYYYY') as AEENDAT,
                       AEONGO, AETOXGR, AESER, AEREL, AEOUT from (select * from I5B_MC_JGDJ.AE4001A_ALL where AEGRPID is not null) d left join (select * from I5B_MC_JGDJ.AE4001B_ALL where AEGRPID is not null) e
                       on d.subjid=e.subjid and d.AEGRPID=e.AEGRPID) x left join (select a.subjid,a.AEGRPID,b.AEONGO from (select subjid,AEGRPID,count (AEGRPID) as cn from (select * from I5B_MC_JGDJ.AE4001B_ALL 
where AEOUT in ('NOT RECOVERED OR NOT RESOLVED','RECOVERING OR RESOLVING','UNKNOWN'))
group by subjid,AEGRPID
having count (AEGRPID) = 1) a left join  (select distinct subjid, aegrpid, aeongo from I5B_MC_JGDJ.AE4001B_ALL) b
on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
where AEONGO !='Y') y on x.subjid=y.subjid and x.AEGRPID=y.AEGRPID left join (select subjid,AEGRPID from (select subjid,AEGRPID,count (AEGRPID) as cn from  I5B_MC_JGDJ.AE4001B_ALL 
group by subjid,AEGRPID
having count (AEGRPID) = 1 ) 
where subjid||AEGRPID in (select subjid||AEGRPID from  I5B_MC_JGDJ.AE4001B_ALL where AEOUT in ('NOT RECOVERED OR NOT RESOLVED','RECOVERING OR RESOLVING','UNKNOWN'))) z
on x.subjid=z.subjid and x.AEGRPID=z.AEGRPID left join (SELECT sb.subject_id, st.SITEMNEMONIC
                            FROM I5B_MC_JGDJ.inf_subject sb,
                                 I5B_MC_JGDJ.inf_site_update st
                           WHERE sb.SITEGUID = st.CT_RECID) o
                  ON x.SUBJECT_ID = o.subject_id 
                  where AEOUT in ('NOT RECOVERED OR NOT RESOLVED','RECOVERING OR RESOLVING','UNKNOWN')
                  order by subjid, aegrpid, aespid