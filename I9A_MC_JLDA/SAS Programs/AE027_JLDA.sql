select a.*,b.SITEMNEMONIC
  from
  (select b.*
  from
  (select SUBJID,AEGRPID
  from 
  (select distinct SUBJID,AEGRPID,AETERM from <prot>.AE4001a_ALL) 
  group by SUBJID,AEGRPID
  having count(*)>1) a
  left join 
  (
  select a.*,b.AESTDAT,b.AESPID,b.AETOXGR,b.AESER
  from 
  (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD from <prot>.AE4001a_ALL) a
  left join
  (select SUBJID,AEGRPID,AESPID,AETOXGR,AESER,
  to_date(lpad(replace(AESTDATMO,'-99', '01'),2,'0')||lpad(replace(AESTDATDD,'-99', '01'),2,'0')|| AESTDATYY,'MMDDYYYY') as AESTDAT from <prot>.AE4001b_ALL) b
  on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) b
  on a.SUBJID=b.SUBJID) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from <prot>.inf_subject sb, <prot>.inf_site_update st, <prot>.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                     on a.SUBJID=b.SUBJID
  