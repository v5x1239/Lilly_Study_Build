select a.*,b.MHTERM,b.MHDECOD,b.MHSPID,b.MHSTDAT,MHENDAT,MHONGO,MHTOXGR
   from
   (select a.*,b.SITEMNEMONIC
   from
   (select a.*,b.AESPID,AESTDAT, AEONGO,AEENDAT, AETOXGR,AESER
   from 
   (select MERGE_DATETIME,SUBJID,AEGRPID,AETERM,AEDECOD from <prot>.AE4001a_ALL) a
   left join
   (select SUBJID,AEGRPID,AESPID,
   TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
   TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
   AETOXGR,AESER
   from <prot>.AE4001b_ALL) b
   on a.SUBJID=b.SUBJID and a.AEGRPID=b.AEGRPID) a
   left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
   from <prot>.inf_subject sb, <prot>.inf_site_update st, <prot>.DM1001_all dm
   where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
   on a.SUBJID=b.SUBJID) a
   inner join 
   (SELECT SUBJID, MHSPID,MHTERM,MHDECOD,case 
 when MHSTDATYY is not null then (STDT||'/'||STMO||'/'||MHSTDATYY)
 else ''
 end AS MHSTDAT,
 case 
 when MHENDATYY is not null then (EDDT||'/'||EDMO||'/'||MHENDATYY)
 else ''
 end AS MHENDAT
 ,
 MHONGO,MHTOXGR
 FROM
 (select  SUBJID, MHSPID,MHTERM,MHDECOD,
 replace(MHSTDATMO,'-99', 'UNK') AS STMO,
 replace(MHSTDATDD,'-99', 'UNK') AS STDT,
 MHSTDATYY,
 replace(MHENDATMO,'-99', 'UNK') AS EDMO,
 replace(MHENDATDD,'-99', 'UNK') AS EDDT,
 MHENDATYY,
   MHONGO,MHTOXGR  
    from <prot>.MH8001_all
    where page = 'MH8001_LF1') X) b
   on a.SUBJID=b.SUBJID and a.AEDECOD=b.MHDECOD