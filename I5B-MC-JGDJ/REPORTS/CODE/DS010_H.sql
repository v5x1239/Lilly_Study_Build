select a.MERGE_DATETIME,SITEMNEMONIC,a.SUBJID,a.BLOCKID,a.page,DSDECOD,AEGRPID_RELREC,AEGRPID 
 from
 (select a.MERGE_DATETIME,a.SUBJID,a.BLOCKID,a.page,DSDECOD,AEGRPID_RELREC,AEGRPID   from <prot>.DS1001_ALL a,
 <prot>.AE4001A_ALL b
 where DSDECOD ='DEATH' and a.page in ('DS1001_F1', 'DS1001_F2','DS1001_F4','SS1001_DS1001')and  AEGRPID_RELREC is not null and AEGRPID is not null 
 and 
 a.SUBJID=b.SUBJID and AEGRPID_RELREC not in (select AEGRPID from <prot>.AE4001A_ALL b where  a.SUBJID=b.SUBJID ) 
 order by SUBJID,AEGRPID_RELREC,AEGRPID) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from <prot>.inf_subject sb, <prot>.inf_site_update st, <prot>.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
 on a.SUBJID=b.SUBJID