select distinct
 
 a.Merge_Datetime,
 b.SITEMNEMONIC,
 a.SUBJID,
 a.SURVSTAT,
 a.SSDAT,
 a.AEGRPID,
 a.AESPID,
 a.AETERM,
 a.AESTDAT,
 a.AEENDAT,
 a.AEONGO,
 a.AEOUT
 
 from
 
 (select distinct
 
 a.Merge_Datetime,
 a.SUBJID,
 a.SURVSTAT,
 a.SSDAT,
 b.AEGRPID,
 b.AETERM,
 b.AESPID,
 b.AESTDAT,
 b.AEENDAT,
 b.AEONGO,
 b.AEOUT
 
 from
 
 (select distinct
 
 Merge_Datetime,
 SUBJID,
 SURVSTAT,
 to_date(lpad(replace(SSDATMO,'-99', '01'),2,'0')
      ||lpad(replace(SSDATDD,'-99', '01'),2,'0')
      || SSDATYY,'MMDDYYYY')  as SSDAT           
 from I5B_MC_JGDJ.SS1001_DS1001_all
 where SURVSTAT = 'ALIVE' and page in ('SS1001_DS1001_LF1')) a
 
 left join
 
 (select distinct
 
 a.*,b.AESPID,b.AESTDAT,b.AEENDAT,b.AEONGO,b.AEOUT  
 
 from 
 
 (select distinct
 
 SUBJID,
 AEGRPID,
 AETERM
 
 from  I5B_MC_JGDJ.AE4001A_all
 where page in ('AE4001_LF2')) a
 
 left join
 
 (select distinct
 
 SUBJID,
 AEGRPID,
 AESPID,
 to_date(lpad(replace(AESTDATMO,'-99', '01'),2,'0')
      ||lpad(replace(AESTDATDD,'-99', '01'),2,'0')
      || AESTDATYY,'MMDDYYYY')  as AESTDAT,
 case when AEENDATMO='2' then to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(AEENDATDD,'-99', '28'),2,'0')
      || AEENDATYY,'MMDDYYYY')
    else to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(AEENDATDD,'-99', '30'),2,'0')|| AEENDATYY,'MMDDYYYY') end  as AEENDAT,
 AEONGO,
 AEOUT     
 
 from  I5B_MC_JGDJ.AE4001B_all
 where page in ('AE4001_LF2')) b
 
 on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID
 where b.AEOUT = 'FATAL') b
 
 on a.subjid=b.subjid
 where b.AESTDAT <= a.SSDAT) A 
 
 left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) B
 on a.SUBJID=b.SUBJID 
