SELECT A.*,SITEMNEMONIC
 FROM
 (select x.*,
 case
 when AELOC is null then 'Flag'
 when AELOCOTH is null then 'Flag'
 else ''
 end as flag
 from
 (select a.*,b.AESPID,AESTDAT, AEONGO,AEENDAT,
 AETOXGR,AESER,AEREL,AEOUT,AEHEIRR,AELOC,AELOCOTH,AELOCMD,AETELTMT
  from 
  (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD,AECTCV4  from <prot>.AE4001a_ALL) a
  left join
  (select SUBJID,AEGRPID,AESPID,
  TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
    AETOXGR,AESER,AEREL,AEOUT,AEHEIRR,AELOC,AELOCOTH,AELOCMD,AETELTMT
   from <prot>.AE4001b_ALL) b
  on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) x
  where AEHEIRR='Y') A left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from <prot>.inf_subject sb, <prot>.inf_site_update st, <prot>.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
     on a.SUBJID=b.SUBJID                
