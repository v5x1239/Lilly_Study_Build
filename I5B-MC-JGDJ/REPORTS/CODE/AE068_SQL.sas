select a.*,b.SITEMNEMONIC,'' as DMcomments,
    case
         when a.AEOUT = 'FATAL' and  a.AESTDAT > a.AEENDAT then 'Start date of event is after the end date of the fatal event'
         else ''
     end as flag
 
  from
  (select a.*,b.AESPID,b.AESER,b.AEOUT,b.AEREL,b.AESTDAT,b.AEENDAT,b.AEONGO,b.AETOXGR
  from 
  (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD from I5B_MC_JGDJ.AE4001a_ALL) a
  left join
  (select SUBJID,AEGRPID,AESPID,AESER,AEOUT,AEREL,
  TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT,
  TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AEENDATDD, '-99', '01'), 2, '0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT,AEONGO,AETOXGR from I5B_MC_JGDJ.AE4001b_ALL) b
  on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) a
   left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                     on a.SUBJID=b.SUBJID
                     where AEOUT='FATAL'
