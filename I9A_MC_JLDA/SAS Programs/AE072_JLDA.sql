select a.*,b.SITEMNEMONIC
 from 
 (select a.*,AEGRPID,AETERM,AEDECOD,AEENDAT
 from 
 (select merge_datetime, SUBJID,DSDECOD,
 to_date(lpad(replace(DTHDATMO,'-99', '07'),2,'0') ||lpad(replace(DTHDATDD,'-99', '15'),2,'0') || DTHDATYY,'MMDDYYYY')     as DTHDAT 
 from <prot>.DS1001_ALL
 where DSDECOD='DEATH') a
 left join 
 (select a.*,AEENDAT
 from
 (select SUBJID,AEGRPID,AETERM,AEDECOD from <prot>.AE4001a_ALL) a
 left join
 (select  SUBJID,AEGRPID,
 to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')||lpad(replace(AEENDATDD,'-99', decode(AEENDATMO,'2','28','30')),2,'0')|| AEENDATYY,'MMDDYYYY') as AEENDAT
 from  <prot>.AE4001b_ALL ) b
 on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) b
 on a.SUBJID=b.SUBJID) a left join
 (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from <prot>.inf_subject sb, <prot>.inf_site_update st, <prot>.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID