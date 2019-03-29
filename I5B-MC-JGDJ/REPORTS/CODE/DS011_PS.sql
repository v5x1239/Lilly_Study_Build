select distinct
 
 A.MERGE_DATETIME,
 B.SITEMNEMONIC,
 A.SUBJID,
 A.BLOCKID,
 A.DSDECOD,
 A.DTHDAT,
 A.AEGRPID_RELREC,
 A.AEGRPID,
 A.AEENDAT
 
 from
 
 (select distinct a.*,b.AEGRPID,b.AEENDAT from (select * from (select distinct
 
     SUBJID, merge_datetime, BLOCKID, DSDECOD, AEGRPID_RELREC,
     to_date(lpad(replace(DTHDATMO,'-99', '07'),2,'0') 
   ||lpad(replace(DTHDATDD,'-99', '15'),2,'0') 
   || DTHDATYY,'MMDDYYYY')  as DTHDAT
 from I5B_MC_JGDJ.DS1001_ALL
 where DSDECOD = 'DEATH' and page in ('DS1001_F1' , 'DS1001_F2' , 'DS1001_F4'))
 where DTHDAT is not null) A
 
 left join
 
 (select * from (select distinct
 
     SUBJID, AEGRPID, 
     case when AEENDATMO='2' then to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')
     ||lpad(replace(AEENDATDD,'-99', '28'),2,'0')
     || AEENDATYY,'MMDDYYYY')
    else to_date(lpad(replace(AEENDATMO,'-99', '12'),2,'0')
    ||lpad(replace(AEENDATDD,'-99', '30'),2,'0')
    || AEENDATYY,'MMDDYYYY') end  as AEENDAT
 from I5B_MC_JGDJ.AE4001B_ALL)
 where AEENDAT is not null) B 
 
 on a.SUBJID=b.SUBJID and a.AEGRPID_RELREC=b.AEGRPID
 where a.DTHDAT != b.AEENDAT) A
    
 left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) B
  on a.SUBJID=b.SUBJID