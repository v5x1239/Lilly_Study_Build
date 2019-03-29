select y.*
 from
 (select x.*,
  case 
  when AESTDAT != LAG (AEENDAT, 1) OVER (PARTITION BY subjid,AEGRPID  ORDER BY AESTDAT) then 
  'Flag'
  else '' end as Flag
  from (
   select a.*,b.SITEMNEMONIC from
  (select a.*,b.AESPID,b.AESTDAT,b.AEONGO,b.AEENDAT
   from 
  (select 
  merge_datetime,  SUBJECT_ID, SUBJID, AEGRPID,AETERM,AEDECOD
  from <prot>.AE4001A_ALL ) a
  left join 
  (select SUBJECT_ID,SUBJID,AESPID,AEGRPID,
    to_date(lpad(replace(AESTDATMO,'-99', '01'),2,'0')||lpad(replace(AESTDATDD,'-99', '01'),2,'0')|| AESTDATYY,'MMDDYYYY') as AESTDAT  
    ,AEONGO,
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT,
    AETOXGR,AEREL,AESER,AEOUT
    from <prot>.AE4001b_ALL) b
  on a.SUBJID=b.SUBJID where a.AEGRPID=b.AEGRPID) a
  left join (select dm.SUBJECT_ID,SUBJID,Sex,st.SITEMNEMONIC
                     from <prot>.inf_subject sb, <prot>.inf_site_update st,<prot>.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
   ON A.subject_id=B.subject_id) x
  order by SITEMNEMONIC,SUBJID,AEGRPID) y
  where 
 SUBJID||AEGRPID in (select (SUBJID||AEGRPID) as subjid
 from <prot>.AE4001b_ALL
 group by SUBJID,AEGRPID
 having count(AEGRPID)>1)