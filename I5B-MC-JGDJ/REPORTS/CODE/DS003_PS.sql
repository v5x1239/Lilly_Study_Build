select distinct
 
 a.merge_datetime,
 b.SITEMNEMONIC,
 a.SUBJID,
 a.BLOCKID,
 a.DSSTDAT,
 a.DSDECOD
 
 from
 
 (select distinct a.*, b.merge_datetime, b.BLOCKID, b.DSDECOD from (select * from (select distinct 
         SUBJID,
         to_date(lpad(replace(DSSTDATMO,'-99', '07'),2,'0') 
   ||lpad(replace(DSSTDATDD,'-99', '15'),2,'0') 
   || DSSTDATYY,'MMDDYYYY')  as DSSTDAT
 from I5B_MC_JGDJ.DS1001_ALL
 where DSSCAT in ('TREATMENT DISPOSITION' , 'STUDY DISPOSITION') and page in ('DS1001_F1' , 'DS1001_F1'))
 where DSSTDAT is not null
 group by SUBJID, DSSTDAT
 having count(*) > 1) A
 
 left join
 
 (select distinct SUBJID, merge_datetime, BLOCKID, DSDECOD from I5B_MC_JGDJ.DS1001_ALL) B
 
 on a.subjid=b.subjid) A 
 
 left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) B
  on a.SUBJID=b.SUBJID