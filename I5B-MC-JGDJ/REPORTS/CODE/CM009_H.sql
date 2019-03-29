select a.merge_datetime,SITEMNEMONIC,a.SUBJID,a.CMSPID,a.CMTRT,a.CMDECOD,a.CMSTDAT,a.CMONGO,a.CMENDAT,a.CMINDC,a.CMAEGRPID4,a.CMMHNO4,
 a.CMDOSE,a.CMDOSEU,a.CMDOSFRQ,a.CMROUTE
  from
  (select  a.*
  from
  (select merge_datetime,SUBJID,CMSPID,CMTRT,CMDECOD,CMINDC,CMAEGRPID4,CMONGO,TO_DATE (LPAD (REPLACE (CMSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (CMSTDATDD, '-99', '01'), 2, '0')||CMSTDATYY,'MMDDYYYY') AS CMSTDAT,
   to_date(lpad(replace(CMENDATMO,'-99', '12'),2,'0')||lpad(replace(CMENDATDD,'-99', '30'),2,'0')|| CMENDATYY,'MMDDYYYY') as CMENDAT,
   CMMHNO4,CMDOSE,CMDOSEU,CMDOSFRQ,CMROUTE
     from I5B_MC_JGDJ.CM1001B_ALL z) a ,
     (select merge_datetime,SUBJID,CMSPID,CMTRT,CMDECOD,CMINDC,CMAEGRPID4,CMONGO,TO_DATE (LPAD (REPLACE (CMSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (CMSTDATDD, '-99', '01'), 2, '0')||CMSTDATYY,'MMDDYYYY') AS CMSTDAT,
   to_date(lpad(replace(CMENDATMO,'-99', '12'),2,'0')||lpad(replace(CMENDATDD,'-99', '30'),2,'0')|| CMENDATYY,'MMDDYYYY') as CMENDAT,
   CMMHNO4,CMDOSE,CMDOSEU,CMDOSFRQ,CMROUTE
     from I5B_MC_JGDJ.CM1001B_ALL z) b
     where a.SUBJID=b.SUBJID and a.CMSPID!=b.CMSPID and a.CMINDC=b.CMINDC and a.CMAEGRPID4=b.CMAEGRPID4
     and a.CMDECOD=b.CMDECOD 
     and a.CMONGO=b.CMONGO  and a.CMMHNO4=b.CMMHNO4 and a.CMDOSE=b.CMDOSE
     and a.CMDOSEU=b.CMDOSEU and a.CMDOSFRQ=b.CMDOSFRQ and a.CMROUTE=b.CMROUTE
     order by a.SUBJID,a.CMTRT,a.CMSPID) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
  on a.SUBJID=b.SUBJID