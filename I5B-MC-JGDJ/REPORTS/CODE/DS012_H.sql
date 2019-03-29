select a.MERGE_DATETIME,SITEMNEMONIC,a.SUBJID,a.BLOCKID,a.page,DSDECOD,AEGRPID_RELREC,AEGRPID,AESER,AESDTH 
 from
 (select a.MERGE_DATETIME,a.SUBJID,a.BLOCKID,a.page,DSDECOD,AEGRPID_RELREC,AEGRPID,AESER,AESDTH    from I5B_MC_JGDJ.DS1001_ALL a,
 I5B_MC_JGDJ.AE4001b_ALL b
 where DSDECOD ='DEATH' and a.page in ('DS1001_F1', 'DS1001_F2','DS1001_F4','SS1001_DS1001')and  AEGRPID_RELREC is not null and AEGRPID is not null 
 and 
 a.SUBJID=b.SUBJID and AEGRPID_RELREC=AEGRPID and AESDTH!='Y') a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
 on a.SUBJID=b.SUBJID