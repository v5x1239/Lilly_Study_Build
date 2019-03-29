select x.*
 from
 (   select a.*,b.SITEMNEMONIC
 from
 (select a.*,b.AETERM,b.AEDECOD,b.AESTDAT
 from
 (select distinct merge_datetime,
  SUBJID,MHSPID,MHTERM,MHDECOD,
  to_date(lpad(replace(MHSTDATMO,'-99', '01'),2,'0')||lpad(replace(MHSTDATDD,'-99', '01'),2,'0')|| MHSTDATYY,'MMDDYYYY') as MHSTDAT  
  ,
  to_date(lpad(replace(MHENDATMO,'-99', '12'),2,'0')||lpad(replace(MHENDATDD,'-99', decode(MHENDATMO,2,28,30)),2,'0')|| MHENDATYY,'MMDDYYYY')  as  MHENDAT 
  from I9A_MC_JLDA.mh8001_all) a
  inner join 
 (
 select a.SUBJID,AETERM,AEDECOD,AESTDAT
 from 
 (select  SUBJID, AETERM,AEGRPID, AEDECOD from I9A_MC_JLDA.AE4001a_all) a
 left join 
 (select SUBJID,AEGRPID,
 TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT from I9A_MC_JLDA.AE4001b_all) b
 on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) b
 on a.SUBJID=b.SUBJID and a.MHDECOD=b.AEDECOD) a  left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I9A_MC_JLDA.inf_subject sb, I9A_MC_JLDA.inf_site_update st, I9A_MC_JLDA.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID) x
                    where AESTDAT-MHENDAT >1
