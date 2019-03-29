select  distinct a.*,SITEMNEMONIC
   from
   (select a.MERGE_DATETIME,a.SUBJID,a.AEGRPID,a.AETERM,a.AEDECOD,a.AESPID,a.AESTDAT,a.AEENDAT,a.AEONGO,
   a.AETOXGR,a.AESER,a.AEREL,a.AEOUT,
     case
     when  a.AEDECOD != b.AEDECOD and a.AESTDAT=b.AESTDAT then 'Duplicate'
     when   a.AEDECOD != b.AEDECOD and a.AESTDAT > b.AESTDAT and a.AESTDAT < b.AEENDAT then 'Overlapping Dates'
     when  a.AEDECOD != b.AEDECOD and a.AESTDAT > b.AESTDAT and b.AEONGO='Y' then 'Overlapping Dates' end as Flag 
   from
   (select a.*,b.AESPID,AESTDAT, AEONGO,AEENDAT,
   AETOXGR,AESER,AEREL,AEOUT
    from 
    (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD  from I5B_MC_JGDJ.AE4001a_ALL
    ) a
    left join
    (select SUBJID,AEGRPID,AESPID,
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
      TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
      AETOXGR,AESER,AEREL,AEOUT
     from I5B_MC_JGDJ.AE4001b_ALL) b
    on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID
    where AEDECOD in('Neutropenia' ,'Neutrophil count decreased','Pyrexia','Febrile neutropenia')) a 
    left join 
    ( select a.*,b.AESPID,AESTDAT, AEONGO,AEENDAT,
   AETOXGR,AESER,AEREL,AEOUT
    from 
    (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD  from I5B_MC_JGDJ.AE4001a_ALL) a
    left join
    (select SUBJID,AEGRPID,AESPID,
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
      TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
      AETOXGR,AESER,AEREL,AEOUT
     from I5B_MC_JGDJ.AE4001b_ALL) b
    on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID
    where AEDECOD in('Febrile neutropenia') ) b
    on a.SUBJID=b.SUBJID )a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                       from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                       where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
   on a.SUBJID=b.SUBJID 
   order by a.subjid, a.aegrpid, a.aespid                   
