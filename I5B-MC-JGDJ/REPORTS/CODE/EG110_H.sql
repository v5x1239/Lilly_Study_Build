select x.*,SITEMNEMONIC
 from
 (select a.*,AEGRPID,AETERM,AECTCV4,AEDECOD,DICT_DICTVER,AELLT,AELLTCD
 from
 (select MERGE_DATETIME,SUBJID,BlockID,EGSPID,EGTPT,
 to_date(lpad(replace(EGDATMO,'-99', '01'),2,'0')||lpad(replace(EGDATDD,'-99', '01'),2,'0')|| EGDATYY,'MMDDYYYY') as EGDAT,
  decode(EGTIMHR,null,null,decode(EGTIMMI,null,null,lpad(replace(EGTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EGTIMMI,'-99', '00'),2,'0'))) AS EGTIM,
 EGMIEEVL,
 AEGRPID_RELREC 
 from I5B_MC_JGDJ.EG3001b_ALL
 where AEGRPID_RELREC is not null AND PAGE  IN ('EG3001_LF1', 'EG3001_LF2' )) A left join 
 (select SUBJID,AEGRPID,AETERM,AECTCV4,AEDECOD,DICT_DICTVER,AELLT,AELLTCD from I5B_MC_JGDJ.AE4001a_ALL
 where AEGRPID is not null
 ) b
 on a.SUBJID=b.SUBJID and a.AEGRPID_RELREC=b.AEGRPID) x left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on x.SUBJID=b.SUBJID