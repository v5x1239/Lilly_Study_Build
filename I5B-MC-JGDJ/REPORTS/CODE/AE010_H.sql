select a.*,DSSTDAT,DSDECOD,AEGRPID_RELREC
  from
  (select a.*,b.SITEMNEMONIC
   from 
   (select a.*,b.AESPID,AESTDAT,AEENDAT,AEONGO
   from 
   (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AECTCV4,AEDECOD,AELLT,AELLTCD from I5B_MC_JGDJ.AE4001a_ALL) a
   left join
   (select SUBJID,AEGRPID,AESPID,
   to_date(lpad(replace(AESTDATMO,'-99', '01'),2,'0')||lpad(replace(AESTDATDD,'-99', '01'),2,'0')|| AESTDATYY,'MMDDYYYY') as AESTDAT,  
   TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT,
   AEONGO 
   from I5B_MC_JGDJ.AE4001b_ALL) b
   on a.SUBJID=b.SUBJID where a.AEGRPID=b.AEGRPID) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on a.SUBJID=b.SUBJID 
  )a inner join (select SUBJID,AEGRPID_RELREC,page,
  to_date(lpad(replace(DSSTDATMO,'-99', '07'),2,'0') ||lpad(replace(DSSTDATDD,'-99', '15'),2,'0') || DSSTDATYY,'MMDDYYYY') as DSSTDAT,
  DSDECOD 
  from I5B_MC_JGDJ.DS1001_ALL
  where page ='DS1001_F2') b
  on a.SUBJID=b.SUBJID